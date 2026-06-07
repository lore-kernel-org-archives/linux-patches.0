Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5B33195FD;
	Sun,  7 Jun 2026 10:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828669; cv=none; b=XodiYoyPNV818LCssWuWbmmgmIXYAMSHUA3mwRmLrWl0fkBFVNWPnEBbt7TFqpand8/TiLL7wVcW9ohtS2PCTehAE+9rurMrvvQcDQUwfHb96G1zciLdl8yE1/Daft7sDkoCAFXf83VWDuRexdZ8YKOd2Q/alICpgpLaMEutQLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828669; c=relaxed/simple;
	bh=xw6CU58FGN2umcQxwlfV3n6BufA23FUuOyq9g7BND4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMw/1RZekBe7EZ5bwWcZVubLABLK7modA/3vZ0KP0XlITI0hZHOaGEgl3Ecy8qVmeihoAtniTIWhMBP7iwcqTV6JewAbzSjXh/YuLK1KHIKzcOxgi3YhndoOv2jvBhfCqgwHySDxFK1SmZrlkfT32GkDwV4yvJqUZWcftbzRaIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAc4k10o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAc4k10o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5B11F00893;
	Sun,  7 Jun 2026 10:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828668;
	bh=ftlvWguDQfg1xNGvDBNYzkaR6ojctDK3PaBCnOaHogk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAc4k10ocQXuzYE8JY3XwjJmNNtqutXErn7uhxsvaaxYznrQUnqje9nse4JPU3g2z
	 SfWapZ2Z5feSrvhdJ2v4+aWPxlNBXbfrYS5kozHeN/VGCL+rkOreFa+fXeKxRMC1Bm
	 0IRY+/IKy5jzIBVdvdtYCrzzqTu4zNgKAx0YQWeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 181/315] Input: elan_i2c - validate firmware size before use
Date: Sun,  7 Jun 2026 11:59:28 +0200
Message-ID: <20260607095734.228106543@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 76b0d0baa9ae9c60e726bbe1b6ff0bec2c993634 upstream.

Ensure that the firmware file is large enough to contain the expected
number of pages and the signature (which resides at the end of the
firmware blob) before accessing them to prevent potential out-of-bounds
reads.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ae2dOgiFvXRm4BHo@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elan_i2c_core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -645,6 +645,11 @@ static ssize_t elan_sysfs_update_fw(stru
 		return error;
 	}
 
+	if (fw->size < data->fw_signature_address + sizeof(signature)) {
+		dev_err(dev, "firmware file too small\n");
+		return -EBADF;
+	}
+
 	/* Firmware file must match signature data */
 	fw_signature = &fw->data[data->fw_signature_address];
 	if (memcmp(fw_signature, signature, sizeof(signature)) != 0) {


