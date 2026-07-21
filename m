Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ABA3C7DF5;
	Tue, 21 Jul 2026 21:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670414; cv=none; b=YMj1VQ3M6BT5p+PqGz0681p5gH+QDf8PGMQ4JzREphHVkp/o3gtFn/XkjX9F116PRpaEt08N9VFjAPKsFHoxyDjy0XFC1Hub0hwJDwpP3JWdktquoiB3nttnDbf6q4ypdfTufXvH83/ow0umrrxRyPnnYXWs9v2QdaqrMh5ffs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670414; c=relaxed/simple;
	bh=KMIlkgU0F18ScIAohwaZQL2jKP1hUYXb2JzT4qFYP/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBQgjfOx9SceT1JqrurDfpxKkS6129dOoivsz6Kdyb4qR7MU6bJFHZFCB55N8+M36UXXU9ov1UZjx5l9b4gCfcXAkJNi1nGf5soGQeUQp58jTkDxgYDguar/vBkmfcfSS9972bNXZ88TsxBVziPsC9S7mC7o8r3JBWOyhna2a7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKT5Q9Hv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKT5Q9Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F01C1F000E9;
	Tue, 21 Jul 2026 21:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670412;
	bh=4E5oCyxh6Q/0DaClk2JiK4qnXp8gPHV068EpLfWsjLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKT5Q9HvaKdpibGATFax+/e1AyWgEtVkeApjp3cn72sn0+h6JboVj4l5zRav932fa
	 9M78tjReMjs1qHuHmcdJFBwQfIK2VBdjD9tGGY+RxixvvyfscIJQ3ezmGXd6W4EEoI
	 VoL0xASZJUK449loE3uAiMIAuaQxBmDHJnMal2mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0922/1067] Bluetooth: btrtl: validate firmware patch bounds
Date: Tue, 21 Jul 2026 17:25:23 +0200
Message-ID: <20260721152445.160338947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -479,8 +479,9 @@ static int rtlbt_parse_firmware(struct h
 	}
 
 	BT_DBG("length=%x offset=%x index %d", patch_length, patch_offset, i);
-	min_size = patch_offset + patch_length;
-	if (btrtl_dev->fw_len < min_size)
+	if (patch_length < sizeof(epatch_info->fw_version) ||
+	    patch_offset > btrtl_dev->fw_len ||
+	    patch_length > btrtl_dev->fw_len - patch_offset)
 		return -EINVAL;
 
 	/* Copy the firmware into a new buffer and write the version at


