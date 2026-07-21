Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37DE3D9027;
	Tue, 21 Jul 2026 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653379; cv=none; b=SeuBgsM7BQL3bGmnVaFbSSWbwZlMrHyuB4VvziiZ6Yj8fv+xNHPzDLM54kEmaBD6dLADky0M/ZSjn9syPpSzetHCL9fjmiPrVpTG0hy//cRcO8zNiUGM7wLoYDnw9ttJWaP3XZxRaybVwIvAF96FYIZv+gwSqgIFU+APbuiYaF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653379; c=relaxed/simple;
	bh=tdblJTldlGiYlJSSBIfha1EJc06efayv8gAby0+T9TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Om3IetwfGnRQho61yvvSyBS7hTqrDJTyU9rtBZEmyURloEsvbOMO+aIyaAt2EtpmguPXvAnbjcPtQCIKQUwU//orNOqW0Nx9fH3/6qaVoHn6tzHbGHB4cpGRymrqD3CadwE/K5JeRu8GMXkbwXCTF7sK5506+NWBAKatrxCCx8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sy9P9n+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sy9P9n+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2085B1F000E9;
	Tue, 21 Jul 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653377;
	bh=HQX7gfEeCL79VouM7PSlaMjORZv07OEMmqLM8qQ+DQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sy9P9n+WA1q94SxCBPkvb72+pp4TzQhDtd83pPARM5DZInndWk5n0137OSajJu1Hg
	 B3oSinxApbab/ePPbSlFldbIJTvpSDDixhJ2F3tddwiTqQEV+MItUs7XUlYxA0L5e7
	 yaWSwsher//kyTYsTepoiW9jZbI5ISDdmkL9gh7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1305/2077] ALSA: FCP: Fix NULL pointer dereference in interface lookup
Date: Tue, 21 Jul 2026 17:16:18 +0200
Message-ID: <20260721152623.598339085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit e1e31e0ec8a609e17fd2e86b77bc00d9cbb24d7c ]

A malformed USB device can provide a vendor-specific interface without
any endpoint descriptors. fcp_find_fc_interface() currently selects the
first vendor-specific interface and reads endpoint 0 from it, without
checking whether the interface actually has any endpoints.

When bNumEndpoints is zero, no endpoint array is allocated for the parsed
alternate setting, so get_endpoint(..., 0) yields an invalid endpoint
descriptor pointer. Dereferencing it through usb_endpoint_num() then
triggers a NULL pointer dereference.

Skip vendor-specific interfaces that do not have any endpoints.

Fixes: 46757a3e7d50 ("ALSA: FCP: Add Focusrite Control Protocol driver")
Reported-by: Jiaming Zhang <r772577952@gmail.com>
Closes: https://lore.kernel.org/lkml/CANypQFb1EHj0xX8bA1WxSOSK-5xca6ZNKzOQcp12=s=puY7VFw@mail.gmail.com/
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Link: https://patch.msgid.link/20260625134933.425785-1-r772577952@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/fcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/fcp.c b/sound/usb/fcp.c
index 0fc4d063c48a58..c45dbe4d453280 100644
--- a/sound/usb/fcp.c
+++ b/sound/usb/fcp.c
@@ -1083,6 +1083,8 @@ static int fcp_find_fc_interface(struct usb_mixer_interface *mixer)
 
 		if (desc->bInterfaceClass != 255)
 			continue;
+		if (desc->bNumEndpoints < 1)
+			continue;
 
 		epd = get_endpoint(intf->altsetting, 0);
 		private->bInterfaceNumber = desc->bInterfaceNumber;
-- 
2.53.0



