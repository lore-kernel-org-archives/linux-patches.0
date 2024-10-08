Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4615E1D31A0;
	Tue,  8 Oct 2024 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392062; cv=none; b=c6/O/N9yAEDiNROwBM8SG8Z/Ucjx7CcI6Cr+ZcSmID8Fd9C85KQGEJp1ZR8BX1yLTfcj5F80/FO2ROi1OHNGeHV/j6CpRpbgdIP6x7VrEkzxIrp9b0c3oHB2wVMex9ub8KsFL/BFXVnqaP0AxuyVTDwFfMJvU/8Kelawp/htMOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392062; c=relaxed/simple;
	bh=RI/Lm7XX3kcSo+VoME9+4FizVU35RA4duDMhy8IWgl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsYwLKmWFN9sJC637SfUEfrrjoTB8XxK3gKeAbpFYVk//ZPwMADKxjtakpYI+KO2EMyRQ6dJ0baS1Sq7lTFEEe4/hkT5+p9XnAJImgP1AVIzwIsdlP0jqhbwduux7JDfwYsztBfziWAsYCRIkb/1CMzfYgQ/WUIuSM9LLkphRM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ga9rdbpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ga9rdbpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B184DC4CEC7;
	Tue,  8 Oct 2024 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392062;
	bh=RI/Lm7XX3kcSo+VoME9+4FizVU35RA4duDMhy8IWgl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ga9rdbpyJELni9bPWgBlXnWGx8fDPsAQGftUgGS1kguBApfWYKPorQZjDZZeR5fsi
	 sRkjWNsht+v+Oa5F3SMfIrit9Wo2G39K/AkJv0Ty5MiyGkGqsW0clgH23uIGcTw27S
	 ls6P6DlnGsfO/oMvgC8HD+2Y5kgwKmsWW1w65dgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 304/558] ext4: filesystems without casefold feature cannot be mounted with siphash
Date: Tue,  8 Oct 2024 14:05:34 +0200
Message-ID: <20241008115714.280989985@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 985b67cd86392310d9e9326de941c22fc9340eec ]

When mounting the ext4 filesystem, if the default hash version is set to
DX_HASH_SIPHASH but the casefold feature is not set, exit the mounting.

Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Link: https://patch.msgid.link/20240605012335.44086-1-lizhi.xu@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7e73e13741d1e..cecea19908109 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3582,6 +3582,13 @@ int ext4_feature_set_ok(struct super_block *sb, int readonly)
 			 "mounted without CONFIG_UNICODE");
 		return 0;
 	}
+	if (EXT4_SB(sb)->s_es->s_def_hash_version == DX_HASH_SIPHASH &&
+	    !ext4_has_feature_casefold(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Filesystem without casefold feature cannot be "
+			 "mounted with siphash");
+		return 0;
+	}
 
 	if (readonly)
 		return 1;
-- 
2.43.0



