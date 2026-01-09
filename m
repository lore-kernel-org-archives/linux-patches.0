Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610E43596FC;
	Fri,  9 Jan 2026 12:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963161; cv=none; b=cFYXJfWYY7nSG2ZTKtn2dd/WxiGOq6olxJ8MhsY5xUo5kJNoC57EjbDqocF0jGuaYj13kbfmKShWqyTgCWQ/UE++JM32jhGa2tPmRNrwSFCHn3HjSEttRLXNAt7DhDpwiRw+SOLKH5nt1krt2m4dtOCZNDNLXNueKePUL8SOHQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963161; c=relaxed/simple;
	bh=cQyE/2qTQxDF/4NSUdNzoyNAr4DbYUwxpcZ4ATZRky0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZZ0CJeFBi+vx9MOAMKVYY0Vr82rJegeXPPTFEPDtKHL6Qo+aZleccXIADnHu1v0x9mDltNDM3IKvvQQbkEZwrPp2gPo4oHisXKZAnoC5sFTxAY1hH93Bj+hKX9KtrlvEnPDdrhRrWBjJbLLtLLMu6ELlvFWpG+Ew93CNPvu4QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Sc/pDfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Sc/pDfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13D8C4CEF1;
	Fri,  9 Jan 2026 12:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963161;
	bh=cQyE/2qTQxDF/4NSUdNzoyNAr4DbYUwxpcZ4ATZRky0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Sc/pDfWnm1+MT0Q7GDv9WCnnevRJCj0c9Kq+ep8ckRDInzpABMstG7ijsE6kvFR9
	 dk2fa7re/UMrZXbQEMo4BpcI6DqnUH0b7toWQ2P6rl/frzaKg0Asb0hCfr06j/pYxY
	 pG7eWS6vPa6n99X2TiJMXtotanWKZ5U/Qxq0HDUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Theodore Tso <tytso@mit.edu>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 618/634] ext4: filesystems without casefold feature cannot be mounted with siphash
Date: Fri,  9 Jan 2026 12:44:56 +0100
Message-ID: <20260109112140.890791757@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Lizhi Xu <lizhi.xu@windriver.com>

commit 985b67cd86392310d9e9326de941c22fc9340eec upstream.

When mounting the ext4 filesystem, if the default hash version is set to
DX_HASH_SIPHASH but the casefold feature is not set, exit the mounting.

Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Link: https://patch.msgid.link/20240605012335.44086-1-lizhi.xu@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[cascardo: small conflict fixup]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3552,6 +3552,14 @@ int ext4_feature_set_ok(struct super_blo
 	}
 #endif
 
+	if (EXT4_SB(sb)->s_es->s_def_hash_version == DX_HASH_SIPHASH &&
+	    !ext4_has_feature_casefold(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Filesystem without casefold feature cannot be "
+			 "mounted with siphash");
+		return 0;
+	}
+
 	if (readonly)
 		return 1;
 


