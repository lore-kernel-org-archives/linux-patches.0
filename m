Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1007421504F;
	Thu, 12 Dec 2024 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016320; cv=none; b=dKcDKT6YS1UNyTesDVKDYaWZRVV1ffowUTLxeEN/iNFqwX4jv6pm1O74eTzcpxUgxQc/ub2L4CiO9WGAK6kumWMUjZztTcSU2MnQjojTemVTYhW75PCaXXVg9MRrb/cPhpIVVQIHSmdYWk1LQ4JobORXmE48qHpHmyMprgCMnvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016320; c=relaxed/simple;
	bh=rYSV9eB/IQBNFJ+wprtOA/Veq+8P6isiVdowmteyH4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEf1C9us2Bm0NQf1hYuppoUec0c2Q0Dy+LuviovxXiNd3gtvEM73cd9Qj/SwXLZPs00omzwci+lWk6kLuV9bJkUZ9P0KUt+VLq/P4MpllFv0vEXiXeMbUtDoXad40h46sB6tsTAwUx5a1x3u9jXsGTRXXKs80rzujbclVM/eMrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gkmrgjo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gkmrgjo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F0AC4CECE;
	Thu, 12 Dec 2024 15:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016319;
	bh=rYSV9eB/IQBNFJ+wprtOA/Veq+8P6isiVdowmteyH4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gkmrgjo+qi9lKq8GPf8Uk6M6K17aABjdfnJcPZ/BqX1zA1J1URCdCqICE/Vh5butH
	 8kEd+2eH2krKYhdeofeKmBU1ov2kQG/rrVlNTGc+YioZBEMINwYhIR1rK9XwJxzvkW
	 ymDpjSg7GCoARewC/guVGdbWP3rfJezOYco5yMjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 158/466] fs/smb/client: cifs_prime_dcache() for SMB3 POSIX reparse points
Date: Thu, 12 Dec 2024 15:55:27 +0100
Message-ID: <20241212144313.037299920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Ralph Boehme <slow@samba.org>

commit 8cb0bc5436351de8a11eef13b7367d64cc0d6c68 upstream.

Spares an extra revalidation request

Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/readdir.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -71,6 +71,8 @@ cifs_prime_dcache(struct dentry *parent,
 	struct inode *inode;
 	struct super_block *sb = parent->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	bool posix = cifs_sb_master_tcon(cifs_sb)->posix_extensions;
+	bool reparse_need_reval = false;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	int rc;
 
@@ -85,7 +87,21 @@ cifs_prime_dcache(struct dentry *parent,
 		 * this spares us an invalidation.
 		 */
 retry:
-		if ((fattr->cf_cifsattrs & ATTR_REPARSE) ||
+		if (posix) {
+			switch (fattr->cf_mode & S_IFMT) {
+			case S_IFLNK:
+			case S_IFBLK:
+			case S_IFCHR:
+				reparse_need_reval = true;
+				break;
+			default:
+				break;
+			}
+		} else if (fattr->cf_cifsattrs & ATTR_REPARSE) {
+			reparse_need_reval = true;
+		}
+
+		if (reparse_need_reval ||
 		    (fattr->cf_flags & CIFS_FATTR_NEED_REVAL))
 			return;
 


