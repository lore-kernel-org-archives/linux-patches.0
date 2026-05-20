Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF25D3A382F;
	Wed, 20 May 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296140; cv=none; b=JY4LK0APLQ5O16qtITsk22pDE5Fcyh/OVmuxUiK6G2afSF8znhLPTY527kx4n5HBBBzLqZVXam8MCEc3OtO4plYUiKi0jyQq8T4xxm35y3//XSCK9zsyln0CgE4oTcXKGxCJvN5614gJqicHxz9egm+PcQ1eL4BcTdvkSigNNhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296140; c=relaxed/simple;
	bh=J1+vTIy1xDweDTjEzMmvCC9/Uj0/OoCbkeNzPMmqKBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr+YWIj8qHIU0F3D/gXiS1OerHzYsQlHmwitRAEdJ7JN1wWiLVL2+YJriSQx0E0+qeDMyZdlGQy8XChxZVUKx0Fi03Fv/YjRpI72psyzgDHdKcuiFsjSkyPKJUTmaN2gf1C6K1SmMvCkPXFhbY3NU1ObAE0qDkf6S2EdZOXINMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxXmSES4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxXmSES4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8ABE1F000E9;
	Wed, 20 May 2026 16:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296139;
	bh=0IptEVblN/xwPTMiVpV5FtNoT1C5J2A5i38V9lSZxtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxXmSES44sC1WabCtI2ogNtrDhl8HKxsW7WeiMaRRrzuRp9+1XHNcTH0q6SVbWAwS
	 N5pZh9Q5tydBYGBYwRlCWet8BjngHnfdpgsn4n1cw1w1NyCXustRsS+17CKJHqGSXU
	 hha4MIDMqFhYhYld0rOYqDlS3LYLEnL2m0poIBtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0685/1146] fs/ntfs3: terminate the cached volume label after UTF-8 conversion
Date: Wed, 20 May 2026 18:15:35 +0200
Message-ID: <20260520162203.692108345@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a6cd43fe9b083fa23fe1595666d5738856cb261a ]

ntfs_fill_super() loads the on-disk volume label with utf16s_to_utf8s()
and stores the result in sbi->volume.label. The converted label is later
exposed through ntfs3_label_show() using %s, but utf16s_to_utf8s() only
returns the number of bytes written and does not add a trailing NUL.

If the converted label fills the entire fixed buffer,
ntfs3_label_show() can read past the end of sbi->volume.label while
looking for a terminator.

Terminate the cached label explicitly after a successful conversion and
clamp the exact-full case to the last byte of the buffer.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 174a7cb202a08..9ed485f9efbae 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1339,8 +1339,13 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 				      le32_to_cpu(attr->res.data_size) >> 1,
 				      UTF16_LITTLE_ENDIAN, sbi->volume.label,
 				      sizeof(sbi->volume.label));
-		if (err < 0)
+		if (err < 0) {
 			sbi->volume.label[0] = 0;
+		} else if (err >= sizeof(sbi->volume.label)) {
+			sbi->volume.label[sizeof(sbi->volume.label) - 1] = 0;
+		} else {
+			sbi->volume.label[err] = 0;
+		}
 	} else {
 		/* Should we break mounting here? */
 		//err = -EINVAL;
-- 
2.53.0



