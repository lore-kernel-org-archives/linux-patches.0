Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB1C238C21;
	Tue, 29 Apr 2025 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948017; cv=none; b=IGglMTUdM5hiw6a3T8yPaiMGT0tFSdYca4Z5JRzFeiVwPiveQJXCqfSdfifE6wjhVPwwN7hI1PmxWzOCuHwev4s6AmAHonBKAOlr9YCuD73ino/gaWIuZNPNotocsN0IcVt0FuOulsUpbTpvMs+RJ4o7L0mHRbE0watXurVCANg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948017; c=relaxed/simple;
	bh=YUryumPStlpTWPsP1tXHEvDnUlbq5dcmz5GPzrEVyHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5pTnmdlvIWxMmEkA4D3syPkJqT9Jt0nUC8//kTzbBpK2VAOdn2vYF0caB6LFAROWzIIU8deXNnCJPdS6hNxEye4+KlIqHAfeU1mwSjT1mGoSi6/qgWFqQY8CE2melSCeEwJRO3pzhDF3qZ0wxB0iLS9z1wykszGngz2n25NQjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3fPGWjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3fPGWjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD1EC4CEE3;
	Tue, 29 Apr 2025 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948017;
	bh=YUryumPStlpTWPsP1tXHEvDnUlbq5dcmz5GPzrEVyHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3fPGWjh4sv8VTmw3won+5vFXDsmLSZF07sQG8LN86yYOQff5g2NdQnneti0/LHR1
	 RyHAy7jlWU3vkde5rOEwelJcpBIHwD/5XsT8aMHch+Mwk6Woumy1+LthvvbN00mj54
	 KLrljRwDREezMSK/iNJIZwLpbu5i27zWKUmQEb08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.12 139/280] usb: chipidea: ci_hdrc_imx: fix usbmisc handling
Date: Tue, 29 Apr 2025 18:41:20 +0200
Message-ID: <20250429161120.814245417@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 4e28f79e3dffa52d327b46d1a78dac16efb5810b upstream.

usbmisc is an optional device property so it is totally valid for the
corresponding data->usbmisc_data to have a NULL value.

Check that before dereferencing the pointer.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: 74adad500346 ("usb: chipidea: ci_hdrc_imx: decrement device's refcount in .remove() and in the error path of .probe()")
Cc: stable <stable@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20250316102658.490340-2-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -534,7 +534,8 @@ disable_hsic_regulator:
 		cpu_latency_qos_remove_request(&data->pm_qos_req);
 	data->ci_pdev = NULL;
 err_put:
-	put_device(data->usbmisc_data->dev);
+	if (data->usbmisc_data)
+		put_device(data->usbmisc_data->dev);
 	return ret;
 }
 
@@ -559,7 +560,8 @@ static void ci_hdrc_imx_remove(struct pl
 		if (data->hsic_pad_regulator)
 			regulator_disable(data->hsic_pad_regulator);
 	}
-	put_device(data->usbmisc_data->dev);
+	if (data->usbmisc_data)
+		put_device(data->usbmisc_data->dev);
 }
 
 static void ci_hdrc_imx_shutdown(struct platform_device *pdev)


