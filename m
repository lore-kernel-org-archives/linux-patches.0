Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC75222D66;
	Thu, 12 Dec 2024 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019755; cv=none; b=GHO+dx9gqpFY+Mu7eQojUcrPSJog+inKwH54LSjP+bWV432joAPUAY6rlu1GFSKFCKqgmq8OZ4VQiH52guRUw7L9rwUWqrvyRJh2vXUyZYNQHtrv8VubasHk9VDUqPJrpruI9LB2HiUAWiPabOGM0XnQxrUu9GFLdTptR+vm+Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019755; c=relaxed/simple;
	bh=nYD1m9h7Zgiz7+HcURdpiqSjnPCmxb4ShJUUAJgKWGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0xEPlwLRW5GaBtOdBUELLIar0LPfF59I5UGkKzOLdUa69flwHq5NwjXOHTK6uv8IJMbhVGHrIKC5lqxgD3UrBKI5TNNvJB21SpDBTCX+W4VKK/PBN7/DqcgJI3nXHufT4ND7Le64fEZbtGHsbDJ2ezEUKe0CL+YYYGA1qiLBfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URKGpSBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URKGpSBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D669C4CECE;
	Thu, 12 Dec 2024 16:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019755;
	bh=nYD1m9h7Zgiz7+HcURdpiqSjnPCmxb4ShJUUAJgKWGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URKGpSBcbzZleZhmVsa9q90/8zrGr5It+/vrOlfInS3wDxGRdzOGPCU20AKYF3POF
	 zTPEZ1EgGD8G8njaKLEt4FZ6koqNpjAml1heM7J9IG6hiPzukR6A/HOgXSYRQnulD1
	 aMX1OsMM62+GygKDoWIWhsjQV8ZkmRA4MhZKGHPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Aurich <paul@darkrain42.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 259/772] smb: cached directories can be more than root file handle
Date: Thu, 12 Dec 2024 15:53:24 +0100
Message-ID: <20241212144400.618110569@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Aurich <paul@darkrain42.org>

[ Upstream commit 128630e1dbec8074c7707aad107299169047e68f ]

Update this log message since cached fids may represent things other
than the root of a mount.

Fixes: e4029e072673 ("cifs: find and use the dentry for cached non-root directories also")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 2ca1881919c7b..d09226c1ac902 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -354,7 +354,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
 		if (dentry && cfid->dentry == dentry) {
-			cifs_dbg(FYI, "found a cached root file handle by dentry\n");
+			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
 			spin_unlock(&cfids->cfid_list_lock);
-- 
2.43.0



