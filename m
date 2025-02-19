Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFF81CEAC2;
	Wed, 19 Feb 2025 08:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954343; cv=none; b=OTtSf7LydUWAIRO7vN95SXYtNJVWOgkD022ABiIIe0u6egrpdsBWBSJBt5xd+nrz0w0qFgZNukB/oemF8dbn7c2SmicVBcI1iDOJRtH+V7fCUCFWa0iK2p87Kxb+Jm90cG1+RmFXG6sb/sbbJgPQYPIDTT/KrbUDfj9qRlEJwAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954343; c=relaxed/simple;
	bh=KhSo7gpXm4DumFlTb1rzrj07PUayXMGLYC9nifg0CaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7k6rpcuzOGivz6TuPVXawj37hrPz8kIrXpBthLP1ewC2FNS0KIjfLjuyUnBku48v+4G1JbjdIVKWIX/ZJCeIC5O5oIY/Z153wWo5+mPrqSJGnB4zqXdbfk/qNJq9tzoHbgAgeLrzP3xK/XsJ6h87nAC8x7YI6BlZ4avBGHBX+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6y3BejW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6y3BejW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E328EC4CED1;
	Wed, 19 Feb 2025 08:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954343;
	bh=KhSo7gpXm4DumFlTb1rzrj07PUayXMGLYC9nifg0CaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6y3BejWUlpLpVfqO56u8WyAl7dHB3NcfAv44VIq8yHQyrvnAgDUD0fnA1F9Gfnwd
	 yAH6sjgF1Y0sbs0tzbk4SOD7eM9uJY9MZhNbCVhkw8EoEgmFcPCyeHj4HpaYoK1PCQ
	 dJ4ymeP+j6lyePRCIJk95GkDpK3yof3dVLjXXlqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.13 143/274] usb: cdc-acm: Fix handling of oversized fragments
Date: Wed, 19 Feb 2025 09:26:37 +0100
Message-ID: <20250219082615.198753062@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 12e712964f41d05ae034989892de445781c46730 upstream.

If we receive an initial fragment of size 8 bytes which specifies a wLength
of 1 byte (so the reassembled message is supposed to be 9 bytes long), and
we then receive a second fragment of size 9 bytes (which is not supposed to
happen), we currently wrongly bypass the fragment reassembly code but still
pass the pointer to the acm->notification_buffer to
acm_process_notification().

Make this less wrong by always going through fragment reassembly when we
expect more fragments.

Before this patch, receiving an overlong fragment could lead to `newctrl`
in acm_process_notification() being uninitialized data (instead of data
coming from the device).

Cc: stable <stable@kernel.org>
Fixes: ea2583529cd1 ("cdc-acm: reassemble fragmented notifications")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -416,7 +416,7 @@ static void acm_ctrl_irq(struct urb *urb
 	expected_size = sizeof(struct usb_cdc_notification) +
 					le16_to_cpu(dr->wLength);
 
-	if (current_size < expected_size) {
+	if (acm->nb_index != 0 || current_size < expected_size) {
 		/* notification is transmitted fragmented, reassemble */
 		if (acm->nb_size < expected_size) {
 			u8 *new_buffer;


