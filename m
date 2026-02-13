Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8501623645D;
	Fri, 13 Feb 2026 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990628; cv=none; b=OoZGuDzShFEMlCVCjbf6EVvFD0hE3eXjwYkK0kBWtqUNgXLrMmWdqynwDsCn6CPNp4FsVR22brbdCMoU9G77amrkBx/xVlYQVjtPnqLy+Ns0HFCFUV+pdBqotJ8BuqBfs/eR6JCJwA5hx9E036mPerf8kM8drN2iUSmrB3B3Acc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990628; c=relaxed/simple;
	bh=cC4wSR7fc8ay3dTn2pxbzyWDjWtMz8x75t7+xzn2N9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gYYm5R2/PDFgbZ+SQ8GnZpCheCquyRxfuZy4CpVIMu9w8jRz9G/ryCD0/7cFwwJHqO0/wgg5OxBhKenOZATKxv/QWurlRXY/qe7suvx7cKh8s05a8LJSDOFRu05GSNo1tVr/S839YDeNUbUML/fZ2rNs5wRA3ZefUXqiW0KiChs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZ6qVPsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZ6qVPsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0665FC116C6;
	Fri, 13 Feb 2026 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990628;
	bh=cC4wSR7fc8ay3dTn2pxbzyWDjWtMz8x75t7+xzn2N9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZ6qVPsEQjFLwuy8dHcy+P0Wkl3l9wqvw6WPTLdWhA6XDLVea1Zs4KnU49rgwg+/g
	 mWIdx81o0UEmhSuWhcJZ64PXCW9A62JgftcbZ5y/5BnTdnHWq+8tgSumy5JNmMIQ+x
	 Z7E/Iduh2IkjNkjtyLM8fUZpGBkJhck0X3yePHCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 03/49] smb: client: split cached_fid bitfields to avoid shared-byte RMW races
Date: Fri, 13 Feb 2026 14:47:22 +0100
Message-ID: <20260213134708.851183857@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -36,10 +36,10 @@ struct cached_fid {
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
 	unsigned long last_access_time; /* jiffies of when last accessed */
 	struct kref refcount;


