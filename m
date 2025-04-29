Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AA8227E95;
	Tue, 29 Apr 2025 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950278; cv=none; b=XwROtN7vvI+f50iZ1rIGucmfrbD9INt1WswsVcOdkK6pEKmtP6obDEDj7+8u1oZWvCXAsVrP60HohmNTKgQ4tCG9UBzFgwkkwFOPk46p7ESbJVSKbHAS4bbQCKDPu0R0aLvH3wEVIWeftqRYJjguHDPVq7m+unE5Ilz9eMkX2kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950278; c=relaxed/simple;
	bh=hgRnl4UgFsyz2gRQ6BKaT6ZzvxA6pBIBDIz5bIk9+gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/dlmvb9wpZeafB6UpWy2ce3NYiR69KnbZ7UVXbAwUROUTdBXuQDMO1CGkgxOBq/kDUz4Uk1WrwJvEsdkZtlfzf79I/Qgm8KyWdXxoaK124IZtS9ZeYC/gqjyERkLAIcpHk7mYQmmUPtj9O7Oaqw1zBN3BYEjR7MFCSj3lUrx9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kO9FXyWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kO9FXyWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2A4C4CEE3;
	Tue, 29 Apr 2025 18:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950278;
	bh=hgRnl4UgFsyz2gRQ6BKaT6ZzvxA6pBIBDIz5bIk9+gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kO9FXyWwsc/jPerUXOD3tk/3ycSQdPuxfKYgKw6ZyKYdPN3FE6jyQAvmpyY4IfguX
	 fkx1STK1ReYM1NkFWILaKpS90pUGjW8xpaTlfyIarZ04WgcerzaV6lbBz8hAyoI6Su
	 wiIlGSrGqLC91HGtVPWVnCZQTdadggGrrtisdzaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/204] ceph: Fix incorrect flush end position calculation
Date: Tue, 29 Apr 2025 18:42:13 +0200
Message-ID: <20250429161101.254624647@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit f452a2204614fc10e2c3b85904c4bd300c2789dc ]

In ceph, in fill_fscrypt_truncate(), the end flush position is calculated
by:

                loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;

but that's using the block shift not the block size.

Fix this to use the block size instead.

Fixes: 5c64737d2536 ("ceph: add truncate size handling support for fscrypt")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index db6977c15c282..f0befbeb6cb83 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2319,7 +2319,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 
 	/* Try to writeback the dirty pagecaches */
 	if (issued & (CEPH_CAP_FILE_BUFFER)) {
-		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;
+		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SIZE - 1;
 
 		ret = filemap_write_and_wait_range(inode->i_mapping,
 						   orig_pos, lend);
-- 
2.39.5



