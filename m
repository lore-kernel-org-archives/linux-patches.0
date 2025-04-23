Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A3927B4F2;
	Wed, 23 Apr 2025 14:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419634; cv=none; b=F3fWIpSyeLUOi/s3c8jEFo75+bzB+LpDNGAcXFtyWKoz88/d4HJ5Lxplcs41wQEPJPQtqL8FaPfSNQSwkd141W/3NasDXx8Iat9wGu9RzxLNe6JQiCtVUKWco98f4/6YE8y+31XvExm9Pn6MmevI4vCgCf9mM/7GNO29CDSqSRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419634; c=relaxed/simple;
	bh=NfN/ZRGHogAxNDIEtetPVGzHbm+LVc5bSxskqo6tg04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqlP63sSdUlzF1dvFnRVkKMn5Re75f22XMg6ym5VqdqhfbcG1VtEgVOh3yv8vDCO7PKnWtahNyIfobreI53CuuxfQF110g+hsSB+DJiDyL7HAxI6HzW1nGnq7y+7nZnYo2uISMdRFnUEdxR/dscks2RJ0bjw56FVmv/Bs8bjRYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8+QJVI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8+QJVI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77104C4CEE2;
	Wed, 23 Apr 2025 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419633;
	bh=NfN/ZRGHogAxNDIEtetPVGzHbm+LVc5bSxskqo6tg04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8+QJVI4xW+ANhRESCoIB+M+QUMzkSJ9y64fWOXnd4jfFilAYjHLVRgDunS2BXgcA
	 O7z9IOwK11dhtkLPNzu6oLeoxyJEXGp4hKkhb+b++BOzZvQWrZ2NNepe/wfyHryT0a
	 p1DdOfo112wyeNzVYxSplethTVGpdoIXafa7JlqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/223] Bluetooth: btrtl: Prevent potential NULL dereference
Date: Wed, 23 Apr 2025 16:41:40 +0200
Message-ID: <20250423142618.259968977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0a6ca6dfb9484..59eb948664223 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1215,6 +1215,8 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
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



