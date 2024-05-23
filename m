Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC7814BF8D;
	Thu, 23 May 2024 13:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470214; cv=none; b=Bx03FgWSWjCYxM8T7Rgx8ww5c6CXJE/r/j+iOQVgw/Sm+NdI23/bIjKuOX7dPcOd13feSuVwEbh3dFTuN4PZCzRzQV3VkHgvAvZ7yGmnDwd41lAhgWQhrW+/R+Vtz7archCKHa4QuRrtuW+bNgnM5+q4ksiW1B5hfN5hbB6BrEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470214; c=relaxed/simple;
	bh=J4uvElDrgjNnfw5m07YC8CviD80SNMQjRxotTRXNqX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eG3ZcXrneovEW5T95TeRtt/AGeOc7o5bbVy8DA4Y68CzZ5hdVysmJWvsDlZTyTA3OMqZVJR1OpfRPqlQH5CuF8Z/6KXA0cPaa4Yzh/wbzFtrkzQ4cK46RVGyeqwmlm4VKQMNSjphHGIhylMAVWX3V5HbVQau/dolJITNnK/qANw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saWF5lJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saWF5lJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70E6C32786;
	Thu, 23 May 2024 13:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470214;
	bh=J4uvElDrgjNnfw5m07YC8CviD80SNMQjRxotTRXNqX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saWF5lJK5TJdPl+3V7ve64WEUqYCPSvntrcmwAdTzZdIOMQ4S3dTw2FZMJ8gibbrI
	 D7ELQ7MLtMpkvsLrvlg7b77ovZ+9x4BzgRfL1RGBT6apzSmnZqqfIP5t8204M2Fs7e
	 De390G0Zh4wto/C2V+P9ZE4o96cOomeB5CUnlqAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Tsao <peter.tsao@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.9 01/25] Bluetooth: btusb: Fix the patch for MT7920 the affected to MT7921
Date: Thu, 23 May 2024 15:12:46 +0200
Message-ID: <20240523130330.443000086@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Tsao <peter.tsao@mediatek.com>

commit 958cd6beab693f395ffe07814ef77d2b45e8b0fc upstream.

Because both MT7920 and MT7921 use the same chip ID.
We use the 8th bit of fw_flavor to distingush MT7920.
The original patch made a mistake to check whole fw_flavor,
that makes the condition both true (dev_id == 0x7961 && fw_flavor),
and makes MT7921 flow wrong.

In this patch, we correct the flow to get the 8th bit value for MT7920.
And the patch is verified pass with both MT7920 and MT7921.

Signed-off-by: Peter Tsao <peter.tsao@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3118,6 +3118,7 @@ static int btusb_mtk_setup(struct hci_de
 			bt_dev_err(hdev, "Failed to get fw flavor (%d)", err);
 			return err;
 		}
+		fw_flavor = (fw_flavor & 0x00000080) >> 7;
 	}
 
 	mediatek = hci_get_priv(hdev);


