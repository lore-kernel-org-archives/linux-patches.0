Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3A82566DF;
	Thu, 17 Apr 2025 18:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916117; cv=none; b=KYIJiQWQHNGvSt88NwQ9IkCs7HgDr+6mkNDLlEWpwjvLQUqwlM7+BkICWvpXfnDsnzJGlVDoaUCo9lcjpuNSKmnXxNWNzysh7++pq47Cjk2tw2sEFY62uPc7Oi7XBhEFAdLepWLCU1KMIsV9BD6Wc1165dDEIwyFOKz37fo7tRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916117; c=relaxed/simple;
	bh=qIfMJRhibASJhzL074JC9WkeMMRNsdacttTnf236XH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3qUa/R5JLb173ROR/dGIHpLgo5YrTaVdtAiuti3J0PaSRqcTRqcjV0YWxVbv0lqX7T/s5/w0OSrzPfIflpNi7lnP92sU5Dlc3tQm+b7ITdudGQ9FdxngAPPyz/4ymKDXbptebE+ix0UXCVBu0D1CHGKmT8W7OJv10Vi0RSbRXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+Lx0ZxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+Lx0ZxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B256C4CEE4;
	Thu, 17 Apr 2025 18:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916117;
	bh=qIfMJRhibASJhzL074JC9WkeMMRNsdacttTnf236XH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+Lx0ZxImWOb/7r0i6YCZWn6LFJEczBK1yCrftN9PfbMJVIzal9yeUp03qOAKow8o
	 ogFuM7FDxO1neO4IVBJMxObVod3K5HG+nnhmDnQVUjJVD/vyxBPpPC1ZS+WKavmrVd
	 3oKng+7Gh5CpGSs0DcxnGbtArq5pJ+IHnldMgMh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 319/393] cifs: avoid NULL pointer dereference in dbg call
Date: Thu, 17 Apr 2025 19:52:08 +0200
Message-ID: <20250417175120.444449136@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Diupina <adiupina@astralinux.ru>

commit b4885bd5935bb26f0a414ad55679a372e53f9b9b upstream.

cifs_server_dbg() implies server to be non-NULL so
move call under condition to avoid NULL pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e79b0332ae06 ("cifs: ignore cached share root handle closing errors")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -816,11 +816,12 @@ smb2_handle_cancelled_close(struct cifs_
 		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
 		spin_unlock(&cifs_tcp_ses_lock);
 
-		if (tcon->ses)
+		if (tcon->ses) {
 			server = tcon->ses->server;
-
-		cifs_server_dbg(FYI, "tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
-				tcon->tid, persistent_fid, volatile_fid);
+			cifs_server_dbg(FYI,
+					"tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
+					tcon->tid, persistent_fid, volatile_fid);
+		}
 
 		return 0;
 	}


