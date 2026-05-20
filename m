Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4336D3FE352;
	Wed, 20 May 2026 18:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302439; cv=none; b=NpZ8vl7fK4+mUikMntfDcPCATj75pql7/JjCfWQQ86xKmj4jQwsqEbPW3iLc0b9bCKEhSRbMY9Sg1hSKIyPXx8/1+brEvhLsjSRMOdUYIURMKmh4sTjN3JGYdu9E4+S4IB85/JUNhQ+Z2S/zRoQTBUamphLohzN7jHSjD1zEm+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302439; c=relaxed/simple;
	bh=99uApC/8eMRWYVAMlEXFdSGF0b0AoimQu9TqPISqwMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcje+3tLdQ1gLkDl0B1soSFoCazhwsplp++VE+R6WnfQ38yykPXvLy73IO/5j1CzC91v1Q5z0Cqv3HBwVGgaB6jxWpCx/1DpqTZ8uePHA+HaaEM9V68cDKOr8WDO5t2qFJ+EZd1vqrp2RLlVwNC+Z14tJTdH7R1Qyw/SISpCCzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hf3fngdN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hf3fngdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4601F00896;
	Wed, 20 May 2026 18:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302438;
	bh=Vy/+WAr+ukmcXbgeSL9MQHOsdmmIbRvcAALepxasdu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hf3fngdN8dOBaZuEQnQofyPmrv1n9Dl0KH/kzBHPxgxEIzxFv1gsrlpBJxAL9xqzz
	 JqCgvgpXBmipSbyFOsvY+4VPq0IcllDpkVsrtqOWl/6Pe81Al9HR8fdvBhaaA6qiUg
	 LQqdXXuvdnnuTtaQoX71rfQYpnhISWMNX2dTP9I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/508] fs/ntfs3: terminate the cached volume label after UTF-8 conversion
Date: Wed, 20 May 2026 18:21:31 +0200
Message-ID: <20260520162104.453092553@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0b96d0f995c61..a4cc56df549a6 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1228,8 +1228,13 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
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



