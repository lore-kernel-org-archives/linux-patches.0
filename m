Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220CF149C53;
	Wed,  5 Feb 2025 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764543; cv=none; b=VRetRs9Mx6Er1leD5Ece/+RUjFfSORJ3jUyPoHYb+5H4j1CuwcR22LnaOfybjJWmpjfLUgnx7ogkmvbDqFQvdtvm+Qs9sRO/+Ble84YdWPUuHOFMGEKImUEJmhZXcr56fieOTtDN01OU9sJpfacoDesrIytDGzBgQhncsLVyUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764543; c=relaxed/simple;
	bh=74sVX/GtghBVf9EB0y+vr/OKALmQgz8+jtCE18gdnvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4ILXLUIz6JNO7hKNQvR7Yp1ZAzDRlWlqHX9KDk/drBEtkPEUbJG9qOxhhjg7X/SCMD/esE+uP3XQ6h8sKyyfxM8Fh0KJpxb19pzT8JDutGl1Di7ohBbSHW7J8j0eXQZZOLwGahF70KdbJO0fXOGlIZjgWT6si4m61KGitk38BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LttOzh51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LttOzh51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF9FC4CEDD;
	Wed,  5 Feb 2025 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764543;
	bh=74sVX/GtghBVf9EB0y+vr/OKALmQgz8+jtCE18gdnvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LttOzh51hf9NiEzA4tfpozQQcXBWLgHcRaK/7XQbc7AD8Mb5/7+yIIBMz0E2upzCw
	 sfLzITsgNdsuteMZ0bZaxwVSqwn+SqMWjPB8EHlqLPhu42uUVq8I+DSb06/lnvNlNw
	 6nNNUjhmHz5UUj/YzPdZeaSfUuYkB1I8NqdFReYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 089/623] wifi: rtlwifi: fix init_sw_vars leak when probe fails
Date: Wed,  5 Feb 2025 14:37:11 +0100
Message-ID: <20250205134459.630572409@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 00260350aed80c002df270c805ca443ec9a719a6 ]

If ieee80211_register_hw fails, the memory allocated for the firmware will
not be released. Call deinit_sw_vars as the function that undoes the
allocationes done by init_sw_vars.

Fixes: cefe3dfdb9f5 ("rtl8192cu: Call ieee80211_register_hw from rtl_usb_probe")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-5-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index c27b116ccdff5..8ec687fab5721 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1037,6 +1037,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 
 error_init_vars:
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
+	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
 	rtl_deinit_core(hw);
 error_out2:
-- 
2.39.5



