Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F15340293;
	Sat, 30 May 2026 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161509; cv=none; b=qKsFeKGkmKtKaj70BAVXTqnos3B0rE4C9yAp5R9PLPfGL3H5px0Gc9RiulljTyOWe90oRNrSLX+DRa563d3dfjx5lCJ0XhFG9nipTrHEeWedQS3Ql+84MK7Aa1zPJQ2thfRBwBDd0Gr+/tqHIW+Pv2UyT9iQGJAVnS6ckcxbsi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161509; c=relaxed/simple;
	bh=ImqqjvZki91vl3BtxQVUNX/o7/JjVt8kYcdjvNfXhJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cffbrqx4/+qjcRN6TS8VX8bbZf/cN/2Ptx6X13y7DQ80c85YXXmWDzZYJjSCDnMBNsPTuputIG1TfNHgUGXuFE2Cq9av0xMdx+4jWVDhpx3ihXUGXSWpIsBlBBa+p6QTmong0LL1OcvCTeKo6no9A2/kOOXwXZNQuosnSMeNVV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeS8TNMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeS8TNMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1B61F00893;
	Sat, 30 May 2026 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161508;
	bh=cindSX4X2vPKf0wbLdwmBsVOQ99DiWhstJYc6tpF7kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeS8TNMSieIIjy7Gk6AlD9cHA1ax7y8OrRzhyeqePTlVMaATooNAAFRp8UgJe//fa
	 iAZp/wfcxnehrI2j5Oxa4Je8E3/eDfUTReAZK9bzUFiL4NqbWEM4x95VDONHp5Wb/H
	 lzYyrO78mUUy3G5khmlPJSNHSin+6/OQe/ev3VTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 645/969] fs/ntfs3: terminate the cached volume label after UTF-8 conversion
Date: Sat, 30 May 2026 18:02:49 +0200
Message-ID: <20260530160318.271842861@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7cf52b70987b0..35dd0018e2bd4 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -992,8 +992,13 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
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



