Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDFD253334;
	Tue, 29 Apr 2025 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950560; cv=none; b=eLLBBkruMUYvs1ydan2Lwxr43UDlQ/6UOvrk5hl6PzlpEQA+rXKun8WucysDMeTBw88z3r+2d2vvGc87K+WEGXW8RUA3gXjWUeYpjH+ehFXh8eoI1eAFw7u9lJmM/IWIJp/gdB+/kp8OdvlYu98nl89kk4JW2o3kAkcn0TSBJb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950560; c=relaxed/simple;
	bh=9s97nk9xkGmE1XntfOI9YU1Tw4soyRdHsoDixMwCGYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCLr7or5ibfqFfqI18+UWSPI95cz+A0BD9ASTlbk15Ht9k+ytTdRRyZYpXn0NOh9mYBHjJhs1q9aN+gVTI/GXZM85Fwow+3qgltpvxHnBmrWLwlRojXDRQeiRl9eMdB9/HM3cmO5+xDHWBfqNCwxd6PM7tcm96AACZxIB0bNMgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDTiiUFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDTiiUFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6690C4CEE9;
	Tue, 29 Apr 2025 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950560;
	bh=9s97nk9xkGmE1XntfOI9YU1Tw4soyRdHsoDixMwCGYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDTiiUFZyWbNMmDkZdQD9FUiafRed//mk23Og2pZCsPHtatQtsAE1Dcvyo/OX4U4a
	 j6SjQ2vISYdKHdK519NNWp1FmTVGB+2DjweAnJTsI2EIyWXbBc6vVeNRwVJlub2Pms
	 GuQrA6Mmq8I23VlDqZexvfKdO2CRuyi/gQQJ8gos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 104/204] usb: chipidea: ci_hdrc_imx: fix usbmisc handling
Date: Tue, 29 Apr 2025 18:43:12 +0200
Message-ID: <20250429161103.684483042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -520,7 +520,8 @@ disable_hsic_regulator:
 		cpu_latency_qos_remove_request(&data->pm_qos_req);
 	data->ci_pdev = NULL;
 err_put:
-	put_device(data->usbmisc_data->dev);
+	if (data->usbmisc_data)
+		put_device(data->usbmisc_data->dev);
 	return ret;
 }
 
@@ -544,7 +545,8 @@ static void ci_hdrc_imx_remove(struct pl
 		if (data->hsic_pad_regulator)
 			regulator_disable(data->hsic_pad_regulator);
 	}
-	put_device(data->usbmisc_data->dev);
+	if (data->usbmisc_data)
+		put_device(data->usbmisc_data->dev);
 }
 
 static void ci_hdrc_imx_shutdown(struct platform_device *pdev)


