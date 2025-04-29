Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0D6243371;
	Tue, 29 Apr 2025 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946117; cv=none; b=ooAZhpr39gN71LGGNSS4eReKWo8hAcPiQGmfv8oNSGHmHMEj20kutC3teLqwPRiz8VMjoLSYeTjBg7T7utfVNdoUIXEvqqyI1MBJoy1DPJFJRgfniCu2KeOVnFMCXPeE1Jf5/w1UjCz5vyCJKar5PoALr/+APT0ZIr6nlZOPVh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946117; c=relaxed/simple;
	bh=6v2zDcFKcU8VuP2mM2d7BL29Cp8qHqH9tURyzs4TA98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQ5ckrzAUoUu/l7jjcYUkkUcmcEr8QwToUnxXKgWU5umhIKhKBDN8PUvt2FKu4mVGb5HHybhZnvuuLf5chzneeLD5U6SUPRKvg+Fl7CkRlZCUVINqIsTcZlm3duR+/jjK2iS/8K6UfZIaDlNVNBELEPkWBBP3aaeFAfdJ8XgVeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgU0u9Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgU0u9Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47289C4CEE3;
	Tue, 29 Apr 2025 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946116;
	bh=6v2zDcFKcU8VuP2mM2d7BL29Cp8qHqH9tURyzs4TA98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgU0u9CokTmH8uuRej5mqd1NCL9KzozC8jN5FtG1wml7EDdL2DtPMbla1+n9xAWlV
	 E5Q3QYCVBGHGDjpFuT7QEBOTI0aQ4KQJF/3TJfglADpcDpX+wXwP1H9gaPdZtRm+VZ
	 tfI8NjslfVUK5b5gMnJ5KFK2cHYwmsXsXytpMYvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.14 161/311] usb: chipidea: ci_hdrc_imx: fix usbmisc handling
Date: Tue, 29 Apr 2025 18:39:58 +0200
Message-ID: <20250429161127.637492249@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


