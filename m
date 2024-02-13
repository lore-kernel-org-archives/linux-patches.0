Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0E660241;
	Tue, 13 Feb 2024 17:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845927; cv=none; b=BdUvoIK2uQO56uncNCTppI/fKeHXj7v/tq8GyH8Fm0cMRG4ILrdJKaW27GnRk6yaMdtiOAXi93pQDn8r2wPpglo2LjZBVJ06vVJz34In+nXBCLCSB+7bprkn6hLg/sh84A4WUD1BLSS8Q9xRYJstV2lxKVeD/h8/dBBAiRPj6to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845927; c=relaxed/simple;
	bh=IO6KuneD7vUOlV1tx1HOqNB+rLV/HYvI31TLFxZJAeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APMxQ7COWA/7u0woXVuL4KJbiFg4WhPXy1JOOetInsyNamhCi+/JuYHclg3PbisO0p92j4Uhy3tea/yksSwL/uQyiL9PWHREgVn+JGLNZFjpSXzmfW9ZfoXOIMNmjZedI6caRlAvVM5o4w7rS1ribX/fpTNKqU9ZQHOGKwrSQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgrwCL8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgrwCL8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F12AC43390;
	Tue, 13 Feb 2024 17:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845927;
	bh=IO6KuneD7vUOlV1tx1HOqNB+rLV/HYvI31TLFxZJAeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgrwCL8YjaB8o/rxIyRoD6YNd6rD54PXWuBfRI0Jny4yOfZ1vRp/pjYD9dd3EQ3pU
	 8HZUSW1NPWq4MTJo4GBjIGXHxVKM/hKWwGh4S96niiUtRlPtw5ABl41uAbaYqdLLnR
	 BofROm0NDFiWAEcjdWU2qbXxt1n9+gjRaLQl32zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.7 099/124] xhci: handle isoc Babble and Buffer Overrun events properly
Date: Tue, 13 Feb 2024 18:22:01 +0100
Message-ID: <20240213171856.622995429@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit 7c4650ded49e5b88929ecbbb631efb8b0838e811 upstream.

xHCI 4.9 explicitly forbids assuming that the xHC has released its
ownership of a multi-TRB TD when it reports an error on one of the
early TRBs. Yet the driver makes such assumption and releases the TD,
allowing the remaining TRBs to be freed or overwritten by new TDs.

The xHC should also report completion of the final TRB due to its IOC
flag being set by us, regardless of prior errors. This event cannot
be recognized if the TD has already been freed earlier, resulting in
"Transfer event TRB DMA ptr not part of current TD" error message.

Fix this by reusing the logic for processing isoc Transaction Errors.
This also handles hosts which fail to report the final completion.

Fix transfer length reporting on Babble errors. They may be caused by
device malfunction, no guarantee that the buffer has been filled.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240125152737.2983959-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2393,9 +2393,13 @@ static int process_isoc_td(struct xhci_h
 	case COMP_BANDWIDTH_OVERRUN_ERROR:
 		frame->status = -ECOMM;
 		break;
-	case COMP_ISOCH_BUFFER_OVERRUN:
 	case COMP_BABBLE_DETECTED_ERROR:
+		sum_trbs_for_length = true;
+		fallthrough;
+	case COMP_ISOCH_BUFFER_OVERRUN:
 		frame->status = -EOVERFLOW;
+		if (ep_trb != td->last_trb)
+			td->error_mid_td = true;
 		break;
 	case COMP_INCOMPATIBLE_DEVICE_ERROR:
 	case COMP_STALL_ERROR:


