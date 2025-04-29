Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8715324E4A9;
	Tue, 29 Apr 2025 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948849; cv=none; b=ocJ1JHOdjIoNtDTsHKjTDsze+F1jAFID3WVh8F9SL8ccpu7UQbsHlZn3zGTYCi/DbpSYYANZu2yfZHDFHKLLsQCIoCUiv6wN+oxW+JZJI8jEthV5HYdwFYOKJXnXiMvz5bcrSQkOfd1Sayg2vTPfs5wdMR4Z+vVc1s9xAfee9d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948849; c=relaxed/simple;
	bh=l1FFNF6f2KEXL33dpqIlOqzLRMov4cDRl530iyDX1SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsK9nGAQncOrgGItKLilVlu63VvIMIokVokdEt7+yOo27DHaF/HCcqmyEC1P6MXljyrNIZVGOIMVsZMVFd/ADlNLjNOA9d6GXbw0EIlXsz0gP7VXWxChtoaLp4gS3Zvuk9OPBpk7jxmQWKLR285zAoGhyuV7Hq/cODsRM0PYWGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNtre3l8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNtre3l8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192AAC4CEE3;
	Tue, 29 Apr 2025 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948849;
	bh=l1FFNF6f2KEXL33dpqIlOqzLRMov4cDRl530iyDX1SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNtre3l8L3J56kRUdyaG04PrW6icHuWbwewDl9dKIWljKnZsZP3cANmF5ZgjrUa/w
	 rgUEcXj1nwifo5mZvhXbkJBhoQA3TZcdlm+P3lsfpEOhApNIjazSQ76Z9bFaFX+7Ns
	 eOKJugaylG+Bpq393fX3Y/PqKZ0wupPYY1162uc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/373] Bluetooth: btrtl: Prevent potential NULL dereference
Date: Tue, 29 Apr 2025 18:40:14 +0200
Message-ID: <20250429161128.804383129@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1f8afa0244d85..1918e60caa91e 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -677,6 +677,8 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
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



