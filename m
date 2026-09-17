Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8502B4C10E9;
	Thu, 17 Sep 2026 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658879; cv=none; b=qxNWzc74t+k0RFUaBGJ4Lzs7eKYz03woA1MVxYjkwy95S2beTLCovOBQ0I13QEtE1zDYs4YDdudN1KJ23ZDeh06LWKbHi6BxyG8MLM9k0PIOmV7XxamrIlT3swXBdQUxD4bFLOgaaRgICnN77+l4MdID84Glgtn5j+mX1bCtne8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658879; c=relaxed/simple;
	bh=eEANYvhLfZtC8YJDgGgTzaZkDPbrPgyyEXS+d3q/yzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMAV6FJDnV99atLBG8BvkPXKPtI3jh+dmhgDiX8+HJLFGiszKVHWOKzoD5kFQZNCuH7wdx1iKa3WaVvSJIDGtRCBNTH/9IpG81h6BjiuVdI0Zw8yTtW7Q7AvMwdQGkUei5TXJcxQDAi0m7J+b4o259O0oX5AOpjdMfZwktG9GTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTxyF+Ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTxyF+Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B26F1F000FF;
	Thu, 17 Sep 2026 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658868;
	bh=anhbweqgU0sfVMPt/zguPQTbkDNG5aBTeHBWSsUfL+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTxyF+IpHCGPGG9AHRBMoaS0F+Dp+o7y1cCcfs/+lHpG/H9u0jsjAbX0Khp73/iBU
	 rwc2cG1M/niwrjH2Oy3xzSaBaC8ryKE2vb0oojvA3ewhOdlLm78jCFHjlaR+qhj05u
	 THEqqnL9jX9hIKwJQxXSKut44xZkj0rZtVcivd04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 039/733] ntfs: return -ERANGE for undersized xattr buffer
Date: Thu, 17 Sep 2026 16:05:47 +0100
Message-ID: <20260917151351.723529066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit ada728801999e25e610091362447372f1b25dd25 ]

When the value buffer passed to getxattr(2) for system.dos_attrib,
system.ntfs_attrib or system.ntfs_attrib_be is smaller than the
attribute value, ntfs_getxattr() returns -ENODATA, which tells
userspace the attribute does not exist. The xattr API expects
-ERANGE in this case, and ntfs_get_ea() in the same file already
returns -ERANGE for regular EAs.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 25ff159dbfd38..08c35f9751114 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -591,7 +591,7 @@ static int ntfs_getxattr(const struct xattr_handler *handler,
 		if (!buffer) {
 			err = sizeof(u8);
 		} else if (size < sizeof(u8)) {
-			err = -ENODATA;
+			err = -ERANGE;
 		} else {
 			err = sizeof(u8);
 			*(u8 *)buffer = (u8)(le32_to_cpu(ni->flags) & 0x3F);
@@ -604,7 +604,7 @@ static int ntfs_getxattr(const struct xattr_handler *handler,
 		if (!buffer) {
 			err = sizeof(u32);
 		} else if (size < sizeof(u32)) {
-			err = -ENODATA;
+			err = -ERANGE;
 		} else {
 			err = sizeof(u32);
 			*(u32 *)buffer = le32_to_cpu(ni->flags);
-- 
2.53.0



