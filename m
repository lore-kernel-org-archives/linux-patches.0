Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB7824BC04;
	Tue, 29 Apr 2025 16:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945462; cv=none; b=El5d8bfBX+fE978nSIeUtdlwqZlDsEu3u5hb7AzCUOpgG+bMG2IC6ZItDHTLlKeEXi30R3B1OdL2ws4qhsziHPK5xSZd3LxrK7YOhVBv0zdlYEDf//dKAHKk/DiBrE8VaUPNMHrbLt5nVvBuyZeS4+x3mLFVYZns895HJcW3SLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945462; c=relaxed/simple;
	bh=bjoWJADaGYXpo0g/WL0wsjm0bUmIzwftRaVFijIKZEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxEb7fP141sO9YM2l3zFaAKtdSAjO07jfs/u5jhOUxE+J0HLKTX8HQpvY3mOWgLqMYCcbc8nRR5hjbddmAXSD2pvPfEKZoy4d8TrnrtW9ZP6P9qwmucxggmP9dKBgU2ElWI9RDdijzbG98hx3Dw1YCUnPd8gQCdsDWQaAnHCfiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAO/tout; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAO/tout"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B89C4CEE3;
	Tue, 29 Apr 2025 16:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945461;
	bh=bjoWJADaGYXpo0g/WL0wsjm0bUmIzwftRaVFijIKZEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAO/toutbmw/qUeZac1Uz0fpSQwaRefbHKk+1ilJOuuS9ebbpE00hEI16ftYit+o0
	 XzDabC74DkQHhCnZzNeZfm7Ywlliv2qyqFnb6oZ3Wp8CtdBNFV8IUJYwUohOQlwi+f
	 Ze0zBkUvYv2RfXnq7SeI6YqkynazO5xpBofqU550=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/179] Bluetooth: btrtl: Prevent potential NULL dereference
Date: Tue, 29 Apr 2025 18:40:31 +0200
Message-ID: <20250429161053.046181346@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 324dddea321078a6eeb535c2bff5257be74c9799 ]

The btrtl_initialize() function checks that rtl_load_file() either
had an error or it loaded a zero length file.  However, if it loaded
a zero length file then the error code is not set correctly.  It
results in an error pointer vs NULL bug, followed by a NULL pointer
dereference.  This was detected by Smatch:

drivers/bluetooth/btrtl.c:592 btrtl_initialize() warn: passing zero to 'ERR_PTR'

Fixes: 26503ad25de8 ("Bluetooth: btrtl: split the device initialization into smaller parts")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 0dfaf90a31b06..bdee7d2d88309 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -605,6 +605,8 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
 			rtl_dev_err(hdev, "mandatory config file %s not found",
 				    btrtl_dev->ic_info->cfg_name);
 			ret = btrtl_dev->cfg_len;
+			if (!ret)
+				ret = -EINVAL;
 			goto err_free;
 		}
 	}
-- 
2.39.5



