Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17766347503;
	Wed,  8 Apr 2026 18:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671918; cv=none; b=SI32yKXQpMjAR9Xaeupb6yViGwgtVQZWUlh57x8TT1I/LUYol8nxih0tC+5P7s1mbg913zAKx9+xE+ybfsRLcEXjHu4eUV5VGQhTkLzGJQqQB+hamx8zI8i4VjI3BZFBA19UT20yhbwUjK4r7X5fqQQCzhR5vxa7Fpa/HmhrNG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671918; c=relaxed/simple;
	bh=YLzASk2EMaDknaFs+PSNPs4TBnv/bEfgJAfTv+jFHck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmC8lr2nR1KyO9pMVisHdLsSEdeOmInIn/2kCl73f42ki0DtpuX3CU5rY84L15Eg1yVtL5O3kDQEOUSnpYjcXNg9Su5NaAh3RXigdoa/xqqsFGI5tPp1gsoTi6ypWgxhL8xgXF63UY+YFsx6qz1SHMhkgMDvzGc+vvGGFX2kvWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnWf+GfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnWf+GfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4D2C19421;
	Wed,  8 Apr 2026 18:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671918;
	bh=YLzASk2EMaDknaFs+PSNPs4TBnv/bEfgJAfTv+jFHck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnWf+GfHToHJ4Dmy/9cXk0f8TyDDeo251D6dgODtTwt8BsF3b/MfZSXTk1ia7pwWH
	 yp7LZyQLtnqQANGNAWQ+5sgdEFBLTVqj4mH6H6I5hrkHIH/gOGA3XJrVQT7fp7pwIz
	 KulNrv2nQoTgSeo8NWsSq3P0YHNt6PohPdHmLrZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Koike <koike@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com,
	stable@kernel.org
Subject: [PATCH 6.1 117/312] ext4: reject mount if bigalloc with s_first_data_block != 0
Date: Wed,  8 Apr 2026 20:00:34 +0200
Message-ID: <20260408175938.139952972@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Helen Koike <koike@igalia.com>

commit 3822743dc20386d9897e999dbb990befa3a5b3f8 upstream.

bigalloc with s_first_data_block != 0 is not supported, reject mounting
it.

Signed-off-by: Helen Koike <koike@igalia.com>
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b73703b873a33d8eb8f6
Link: https://patch.msgid.link/20260317142325.135074-1-koike@igalia.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3575,6 +3575,13 @@ int ext4_feature_set_ok(struct super_blo
 			 "extents feature\n");
 		return 0;
 	}
+	if (ext4_has_feature_bigalloc(sb) &&
+	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) {
+		ext4_msg(sb, KERN_WARNING,
+			 "bad geometry: bigalloc file system with non-zero "
+			 "first_data_block\n");
+		return 0;
+	}
 
 #if !IS_ENABLED(CONFIG_QUOTA) || !IS_ENABLED(CONFIG_QFMT_V2)
 	if (!readonly && (ext4_has_feature_quota(sb) ||


