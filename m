Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6011362;
	Tue,  3 Dec 2024 15:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241595; cv=none; b=eJft3TX08jr2RM0Rn0/lRjg6P+X9YkgsmqeGU75xvSSOddJ0ACFw5vJq/ITyibv3de34buOCOtAW6KG8czY0+7ke0I6QLIdF1V9CbSJm668/X7NcwVoAzLnMTJm9apkHyIcEgSWMd1TPPn5KMBu+VGr+LpeVgWkQqQkAbnAwbto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241595; c=relaxed/simple;
	bh=FO+JjVIhGJn9W5Kf8aRmZ5gml1VgAQQGgW6fryQVTgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUouFfXxaB7j73G7KzwztDZaNeOI/CS3v1o9GSf0HbSOo+XwxLN3gFOpR/exJyJ4VJAohqXFxyUig6OkovLYi8m6P8Qg/050OfM9iKgPLs0OOjtu5uWERGvDdJ7pCd/oPnV5duSParxW09H2cLW3iRphhJ7RieSz5dKyDUZy+Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYZEdGQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYZEdGQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6415C4CECF;
	Tue,  3 Dec 2024 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241595;
	bh=FO+JjVIhGJn9W5Kf8aRmZ5gml1VgAQQGgW6fryQVTgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYZEdGQ9hcc50brNVejB60arhWm1ibjw68aZhssft1MjePHmsCYfdbTwlHpOwvdPz
	 sZJonbtYuvYQ1SqhTRJNSb0Xzs+6LmNW5G7M6HzAQUx8j2YlF9rRVJR9A7RzKovTp6
	 Mx/BWRZ3ARMT2w1k7GQ1z8hLNMxt58NxbdFnWDbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Aurich <paul@darkrain42.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 462/826] smb: cached directories can be more than root file handle
Date: Tue,  3 Dec 2024 15:43:09 +0100
Message-ID: <20241203144801.786392780@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



