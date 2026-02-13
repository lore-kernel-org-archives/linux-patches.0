Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A59135FF6F;
	Fri, 13 Feb 2026 13:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990902; cv=none; b=P66HFe4Ue9OAWNgtXJCqIhSu63XbIMDUzGvMfXQSdfzsxSSejPIefEvAx6mtYq2ReBRLLjLcfYCAhjmqWvITLqWPqGcFxYs1XSmqXvqck4Y9kAKqxuip083DPQ1XbzWXDf1jrUaFWD9Ap2Bq1A8Ix3z3j5PpF6heFvkeWcTKoWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990902; c=relaxed/simple;
	bh=bHQYFyfPyM1C5eDzdMCw8Lqhtaty7d5eI90fvGzeE4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kCraM16nlmzcK1rNn3pYk9r1tL9O/KL3KB56c/hsxIVfmGtg0NQ6zkBS2cC3QEfeCz7IVIPidI9MZBCO6T/Lw2ZM79K+p/KoInzZJnt5RELKTitr9VuUV0tC2/Rg7ckLXpzMOCsOZ64jhGcuqu4OGCJbFceSfqzVcQKDvTqX5xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFCse5JN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFCse5JN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F56C116C6;
	Fri, 13 Feb 2026 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990902;
	bh=bHQYFyfPyM1C5eDzdMCw8Lqhtaty7d5eI90fvGzeE4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFCse5JNFxEpJJyViSiq0e0E12UkOPI7tNc82J86l0d9dIxHG1nHgni6iDYNNQbr7
	 6D6QtH7kXgnfAIcKhJpin3L8GwVzwDAPhT4KkiZPLlRERSHK9pnQ8yOU9wPPjcY41+
	 kZqKWscKzsOEcozG4u0JXdG7e5JrFjD8kOaGdD34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 01/24] smb: client: split cached_fid bitfields to avoid shared-byte RMW races
Date: Fri, 13 Feb 2026 14:48:20 +0100
Message-ID: <20260213134704.784204140@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit ec306600d5ba7148c9dbf8f5a8f1f5c1a044a241 upstream.

is_open, has_lease and on_list are stored in the same bitfield byte in
struct cached_fid but are updated in different code paths that may run
concurrently. Bitfield assignments generate byte read–modify–write
operations (e.g. `orb $mask, addr` on x86_64), so updating one flag can
restore stale values of the others.

A possible interleaving is:
    CPU1: load old byte (has_lease=1, on_list=1)
    CPU2: clear both flags (store 0)
    CPU1: RMW store (old | IS_OPEN) -> reintroduces cleared bits

To avoid this class of races, convert these flags to separate bool
fields.

Cc: stable@vger.kernel.org
Fixes: ebe98f1447bbc ("cifs: enable caching of directories for which a lease is held")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -34,10 +34,10 @@ struct cached_fid {
 	struct list_head entry;
 	struct cached_fids *cfids;
 	const char *path;
-	bool has_lease:1;
-	bool is_open:1;
-	bool on_list:1;
-	bool file_all_info_is_valid:1;
+	bool has_lease;
+	bool is_open;
+	bool on_list;
+	bool file_all_info_is_valid;
 	unsigned long time; /* jiffies of when lease was taken */
 	struct kref refcount;
 	struct cifs_fid fid;


