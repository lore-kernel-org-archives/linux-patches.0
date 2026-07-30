Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AAA3A641D;
	Thu, 30 Jul 2026 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424212; cv=none; b=VqT7rGKU55iol3E2o+GP9ftDHK5MohQCF7suM8Np6qBh7x6Fy0PZPMqCQ3JQg7AaIPCrQucVILBAmF1thP1ZxCEtrqY802sW5yl0MeP1RtTTPjB+RSXaPSNPFkiB44SOu2ECP1iUwNRRon+lREeva9p3KjSWqCRrHNBSmBjavsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424212; c=relaxed/simple;
	bh=KYBRMIX2GHWz9yEXfgfmCmigOladiYg345se0pXSKcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3trWx8BplmY6LBJFs/yXyQcmfME0oE2G1X0elgWGr8Z6DY9c5aXSD7db7lBAw0qKAcftcsBhaUK1m+OAGjEPWeiuKwkwVHZcdgzBITEwqn+NTQAv7ROvdlYWI2ztOb2kGaTlGG3zsbN5NgZhrzxbCwxJ7FWEKNZunem7/QCb4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9HF7fKU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9HF7fKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D89B1F000E9;
	Thu, 30 Jul 2026 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424210;
	bh=VkdV6QaYch+3PTcAhh2x9LZIZ1ZHeOMJNiy2MhI0NOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9HF7fKU6xiux6Hnm5tU1i1eUI/Vlsp3QWRFmryIVn95ho2i1D53KuQe1c/5W9gjf
	 +rU1PmPtUNT6OEI+uAicCOWU9p7j/lUmy7KU7FyxwroM91acpK4kL/rfDO32DUVhup
	 U1gmvCXwY1ADsdv2aJGa6wQ25gBevi32+IftXlrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/675] ovl: add override_creds cleanup guard extension for overlayfs
Date: Thu, 30 Jul 2026 16:10:00 +0200
Message-ID: <20260730141450.869073160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6f5c84162a30514a795eab3495a12c19306d6f6c ]

Overlayfs plucks the relevant creds from the superblock. Extend the
override_creds cleanup class I added to override_creds_ovl which uses
the ovl_override_creds() function as initialization helper. Add
with_ovl_creds() based on this new class.

Link: https://patch.msgid.link/20251117-work-ovl-cred-guard-v4-1-b31603935724@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: a1e0eb8f55cf ("ovl: check access to copy_file_range source with src mounter creds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/overlayfs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d1eb1cbe7a4561..696b13d9e1f102 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -445,6 +445,11 @@ struct dentry *ovl_workdir(struct dentry *dentry);
 const struct cred *ovl_override_creds(struct super_block *sb);
 void ovl_revert_creds(const struct cred *old_cred);
 
+EXTEND_CLASS(override_creds, _ovl, ovl_override_creds(sb), struct super_block *sb)
+
+#define with_ovl_creds(sb) \
+	scoped_class(override_creds_ovl, __UNIQUE_ID(label), sb)
+
 static inline const struct cred *ovl_creds(struct super_block *sb)
 {
 	return OVL_FS(sb)->creator_cred;
-- 
2.53.0



