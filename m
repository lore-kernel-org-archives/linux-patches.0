Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A408913E03A;
	Fri,  6 Dec 2024 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497590; cv=none; b=HMczBZb47vhCGZdhXTA0meAS7H7sMfa7oyYZ/PbGwOj7OhB1o1QbCJfk7Rg0DT5VQ17dLZ9W8O24uSrQyHE6fz7/FOXjHtG3wVlKI2zdwkmr1RunKTm1WSuA9ox6q6bdKFCHnMmTNIc3hHGWHctSagiiSKjNqGu7fLzwxNOXoxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497590; c=relaxed/simple;
	bh=DPsgkVoLdfyD/lK9Sm2125eKrkkPL/P2RbA9cTt/VCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+iRioBU9XTKJnIHo/41HYCsF4Z3YN/vNhhF/d3U942fvXCpESfZe1AMG5cC52JuVmx5K+LGd8hme5v7ldqhyEnNp3glrAxVd8vaSDQuCQkpsUWEDd5FpgSN8qDwrnnPbt67Zd82Nj3726NqoGt8iU/qUAJqPf+SlCFpd6LqCZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcFYf2mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcFYf2mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5F2C4CED1;
	Fri,  6 Dec 2024 15:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497590;
	bh=DPsgkVoLdfyD/lK9Sm2125eKrkkPL/P2RbA9cTt/VCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcFYf2mt0FObNj4GQHx1kQAFHG4IzxUPVx9RfPIum1RUcAEmmI7w3qxnHtRDuiKel
	 pbX9QGdvYBuG4QsJn2vJ+Fn1nt4dgrT/7jTouCLjiIGG0Nqa5BlIMzqkWZi78LmOwp
	 ZjpHjAs8pfTASpuIVZaquCh58eMq+rT+dRTRFWdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Aurich <paul@darkrain42.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 333/676] smb: cached directories can be more than root file handle
Date: Fri,  6 Dec 2024 15:32:32 +0100
Message-ID: <20241206143706.353255507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



