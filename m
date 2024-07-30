Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780C11A76CE;
	Tue, 30 Jul 2024 17:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359515; cv=none; b=oAvruNIIsNY8WiM4lPV3s7WhTjBMAVbdZib9bxbzvVBrnxsdOfarUpZo0KILJ2QsvgVh4cVb6dH5W4JRPsFuraTWVliE32E14pS69t6Erw3f0Nifo793woor6CuFQsAkDePKDmZYpszRA5D3FrA4V1416i43ocqOChbJumk0qRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359515; c=relaxed/simple;
	bh=6Q4xdb1roaPVOMnubtvYfmjy6KSHJLNUEGrnNNCYK/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pL3n7sPxzrYOVBsYjWDrNbjIghIf+3IB9KxTjkqUpHlqxTMQu1kc0DlGVHGisVv37frQQkmREDo4zRBl60nRgB6e7KYO8h63xHQo9EZIJE/ECG9B1pch4RouuhXcLZQl/sGhatLGPdVobQQuLr1s2b4pmuPTQ7jwBI9UeqguRcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sciZCw30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sciZCw30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E16C32782;
	Tue, 30 Jul 2024 17:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359515;
	bh=6Q4xdb1roaPVOMnubtvYfmjy6KSHJLNUEGrnNNCYK/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sciZCw30fpw420tdJea4zpzn5UXmwhHxOFdJAStPbNgNRxKB/Iu4LB3j+xK+W2SI8
	 gNQIG9TbCGnLNdYiOBiz5JuO4R+2LWIqXzhi/t38kJ7j+DeQ3NnP4TJ1p4W2sPkEu6
	 2HJ6bkGL2gV4hrWxLoBUZ5l1Jtw13JtgOSKPap5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 495/809] fs/ntfs3: Replace inode_trylock with inode_lock
Date: Tue, 30 Jul 2024 17:46:11 +0200
Message-ID: <20240730151744.288876134@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 69505fe98f198ee813898cbcaf6770949636430b ]

The issue was detected due to xfstest 465 failing.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 2f903b6ce1570..9ae202901f3c0 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -299,10 +299,7 @@ static int ntfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		}
 
 		if (ni->i_valid < to) {
-			if (!inode_trylock(inode)) {
-				err = -EAGAIN;
-				goto out;
-			}
+			inode_lock(inode);
 			err = ntfs_extend_initialized_size(file, ni,
 							   ni->i_valid, to);
 			inode_unlock(inode);
-- 
2.43.0



