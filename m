Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A1E29A1;
	Tue, 17 Feb 2026 20:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361125; cv=none; b=jtCGZ5CKML7bs0GgZqHViAfkavSAhqJNKRKkzG+4ohE4vq9yUvS8fqUrHYGY0A/2AeyLIdgs6Lt01p2aNhlE4qOVrRBBgGjshXNE79/qY+nUnIsOTrc5okWOyUWv4oaz6oXqvB3yY3lAxQ25bAZHh3xH50AXLpTbTh3zv5oqz84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361125; c=relaxed/simple;
	bh=tMjmSlsOd7/MfQGQPL5hQ9G4B65pmLwqhEXG+LtO+f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ml9PWS3X29T7XZanZC9Aerb7pZIpGCWeRh6rVYesA21IWB+Mhp3CTMs6y27rrageg7Tu9hBHR6yV0AYIV4lbSLYwtAj0wh0MHbvlnQn3llljNpg2ikoktBbJDHXyMsMOPZiv6+lgpEV9laKlFAIFbE4uRaYtljuzS39n9COVR+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akl/rBGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akl/rBGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD8FC4CEF7;
	Tue, 17 Feb 2026 20:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361125;
	bh=tMjmSlsOd7/MfQGQPL5hQ9G4B65pmLwqhEXG+LtO+f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akl/rBGb+VgXg4Q3QYPjz0UZam99YO7G2CR35nJ53uTRPJpG3wBIDlWiYWONSciN0
	 G3pvEfDRPrs6mwJ8ixmixoYhUg5UlnOd9LMwvjJwUs+pnf3Ynt8zlkRuBSUVDgE2L2
	 pTeS3cEL1yJOxEe0PQnF/2CV9o5I/NjZVAj0pE/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 01/64] smb: client: split cached_fid bitfields to avoid shared-byte RMW races
Date: Tue, 17 Feb 2026 21:30:57 +0100
Message-ID: <20260217200007.563451087@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


