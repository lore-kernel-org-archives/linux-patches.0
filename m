Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9073946D0AD;
	Tue, 21 Jul 2026 18:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659463; cv=none; b=Bg5ZOdpKNxQq8NXQBZse1F20EFfUN57L3E++Wp68HjaQU4gd/uSX47EnNwIYPCReHwTOuyzR3XMabHiyLDtF7NePDNRLOKzvX+ziA5h3qB9KEYhpSHQ0djOORVs0xXs/xCdlzCjgSNcXuqthB3s16umZxurT++QWlEvhT8Oe2Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659463; c=relaxed/simple;
	bh=TRXsnUSxT8RUfI3KDWMETPE2ymck0lB1H8Lj+HOtUHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ2QhIKeF0kMevkTosWxHsX8vnqB0Uc/tNHINUoKN1pcYNtc0MErH6QErjHmcE06y/cVXuX3I0D+ZKnkv9m20s8Xn2fIMGwx2csQtrBK61JnbxuZPHZwVgtHtC6uNMyJjkkc4o+0CLXmvYzm9k0oe479mGNXWZ/UCXoVf59/kak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kn5Ub970; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kn5Ub970"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F182E1F00A3D;
	Tue, 21 Jul 2026 18:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659462;
	bh=pTnTI1DWvQmxSm52bRgzqtr0jPyywBjLWQNS300jwJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kn5Ub970T0+mAiyindyqXr6CtsFDLPYHf/QZMPPrMVzwXu7jzThjWmauY/AghkBD1
	 KN/wYe7YTcFIPHYYv44kCmivWkRg4+PZede/1AOJiNiVQNJ/c1KiP6wNcKShL96LbI
	 TU7XOxSKcyHPw7JjXab5RZjiiBVFcUAzWkI2kY3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 1487/1611] Bluetooth: btrtl: validate firmware patch bounds
Date: Tue, 21 Jul 2026 17:26:43 +0200
Message-ID: <20260721152548.891911920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit 609c5b04a28dc1b0f3af6a7bc93055135b2d2059 upstream.

rtlbt_parse_firmware() copies patch_length - 4 bytes before appending the
firmware version. A malformed firmware patch shorter than the version field
can make this subtraction underflow and turn the copy into an oversized
read and write during Bluetooth setup.

The existing patch_offset + patch_length check can also wrap on 32-bit
architectures. Validate the patch length and range without arithmetic
overflow before allocating or copying the patch.

Fixes: db33c77dddc2 ("Bluetooth: btrtl: Create separate module for Realtek BT driver")
Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btrtl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -786,8 +786,9 @@ static int rtlbt_parse_firmware(struct h
 	}
 
 	BT_DBG("length=%x offset=%x index %d", patch_length, patch_offset, i);
-	min_size = patch_offset + patch_length;
-	if (btrtl_dev->fw_len < min_size)
+	if (patch_length < sizeof(epatch_info->fw_version) ||
+	    patch_offset > btrtl_dev->fw_len ||
+	    patch_length > btrtl_dev->fw_len - patch_offset)
 		return -EINVAL;
 
 	/* Copy the firmware into a new buffer and write the version at


