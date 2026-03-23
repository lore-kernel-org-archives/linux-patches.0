Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830003AB295;
	Mon, 23 Mar 2026 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275509; cv=none; b=Sqo6xJwraW3FGUPC43tBUjCufETXsU0+1wFdphbnD1lDoHQkLwWSRm29UP8NkLa4sofbDGF5VVjd4x7JdvwDBWAxbSmzOlSeveQZ/PCDf04corXHK1cmK62a65+HJDqp1uH2ObMf1wJetk1HVltxaxU3jWLlZ0yS1gO4Ulgccno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275509; c=relaxed/simple;
	bh=fzDAmJO1YGr9oYEU+gfUcVTK5Ke+byR5+gf2RddLtCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyDnZecj0afM6sFVlrVBpfJnRPjqBoNlUC0LsIg3hTTMPtkLVFIRxTin/1POXNnNZ2GcBLY+btZcdmhF1wbZJlT1pRRi9EzS8WuFtRLTNS0yGdCf6KQ+k5S80ADxit1Id79f/LaB+Hp25r3Ytgho/NxWaMs8V1WBTjhHnQmugd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JApXxOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JApXxOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24F0C2BC9E;
	Mon, 23 Mar 2026 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275509;
	bh=fzDAmJO1YGr9oYEU+gfUcVTK5Ke+byR5+gf2RddLtCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JApXxOiX6g5yc8jznxCwXvyWFJsuWh41wzfJuTl8aOGuaJT8LAHfXIE7CBLZuwlB
	 JlSKYefQ2hg0AzQ8NXE9fPuW6msSjE+njoHCqzuOZBsRW413228JNvFjTxHKVRrOVH
	 JVaH1ns8Y4kT7mktpiWDELizQVcWVxI5nIkqp7Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Vahnenko <vahnenko2003@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 100/460] USB: ezcap401 needs USB_QUIRK_NO_BOS to function on 10gbs usb speed
Date: Mon, 23 Mar 2026 14:41:36 +0100
Message-ID: <20260323134529.110053023@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vyacheslav Vahnenko <vahnenko2003@gmail.com>

commit d0d9b1f4f5391e6a00cee81d73ed2e8f98446d5f upstream.

Add USB_QUIRK_NO_BOS for ezcap401 capture card, without it dmesg will show
"unable to get BOS descriptor or descriptor too short" and "unable to
read config index 0 descriptor/start: -71" errors and device will not
able to work at full speed at 10gbs

Signed-off-by: Vyacheslav Vahnenko <vahnenko2003@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260313123638.20481-1-vahnenko2003@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -585,6 +585,9 @@ static const struct usb_device_id usb_qu
 	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
 	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* ezcap401 - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x32ed, 0x0401), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 


