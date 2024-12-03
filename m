Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEEA646;
	Tue,  3 Dec 2024 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239114; cv=none; b=WXJ4N2LQdDNV3ZX7FBKDTlGuhUCWD1pQHhgCikqa5bii9h1RIaMGzKyMhVqhJHMukS0ih/IBh4aNLT1Z1t9oXnYQg2dPQy62f0osBh5NlJmAVreuXXbjY14lU9GEsHoMKPkt+3emlmHlt17zGuhSqp4GXLqG1y/lvcK5c1ajoX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239114; c=relaxed/simple;
	bh=7d5Xo2tH+Zcn9LcjK5emNjcyduZizoTj8FtfblQcNC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlMnEWoSxTf3Qe00rjVWcFHt5tqdaEYrhLD2xKOs3N53ewgPO1IcWuF/5zU35u+yeIWTse5BOeh0MfK/YoPj3FgGtHgiWbZC8rKDXR8jr65yXz9MyUO4Mj1aAnNhP/cL8UeCX5sQmDmfmnOBpKesnyGywt3hoQ0Z/O9QuqnucWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK/yxWsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK/yxWsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396E5C4CECF;
	Tue,  3 Dec 2024 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239114;
	bh=7d5Xo2tH+Zcn9LcjK5emNjcyduZizoTj8FtfblQcNC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK/yxWsXB2R5nWR5Fdr3tjhfm7h5FOCCD01c235CGtMextn939Jv5VR+Ba7hHtt36
	 CVAmgFe0rGDVIncDCA/u+Ubu0/BwizcBkHqWUwwwb4jh7yyMt0y4256LVjgG41Elkn
	 M+tMz7NN4IAibsrJubFFkjy0zzOK2necRABjdL+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Aurich <paul@darkrain42.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 477/817] smb: cached directories can be more than root file handle
Date: Tue,  3 Dec 2024 15:40:49 +0100
Message-ID: <20241203144014.489115530@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 0ff2491c311d8..adcba13352045 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -401,7 +401,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
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



