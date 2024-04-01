Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F08EC129;
	Mon,  1 Apr 2024 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988644; cv=none; b=oeTMmIlHCrardHJR+6nYYlkFxS/JzJwByecPhuLw0NZIMT3F4ZB7LBqJ0Yar+J3gMGcVZKrjM6AsrRP4Y+HGhqSmX+kIzm9eifwtSVHdykiA6DutABzSoE+0brwQOzNtnzS7IlIoaXUbJzDqavoiaFgdyvfek/Wu1vrPWu0V80U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988644; c=relaxed/simple;
	bh=S6SP5mHOpAvVUo4+lvIm91dcBW+uUIsanHOlIvgWji8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfdFwicUV0oaOsP+qrXAFf8uYjEv1quMapvZo+SVEFRDhSeiMcUGGxutsEfcA00fAUmF5FRAdiGp2VvXksphjXn0MjlTDOYbW9+Y59JchkdFpoThQC4d8f/Z45UhJWvYhqt5UuBLF9S+wevZ3I1bTyXOmwdsx5eI8QZN7s75RHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTopp63L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTopp63L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19F9C433F1;
	Mon,  1 Apr 2024 16:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988644;
	bh=S6SP5mHOpAvVUo4+lvIm91dcBW+uUIsanHOlIvgWji8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTopp63L2mX43PoM9wqL7xQsunLygQAirEd8vMC5NqrwWYxgkuqsuOeRW3O7XslCa
	 YMYYNG/VgrZCLwKlqMfpdfFp0OYm3ftgBhFGS2J+iMBnx4P+S636/URwjjEJPxduFd
	 CKg1GDVCDwJ0HCNhpk6vw441JPlUM2hNqvrfsJ6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.7 246/432] usb: typec: tpcm: Fix PORT_RESET behavior for self powered devices
Date: Mon,  1 Apr 2024 17:43:53 +0200
Message-ID: <20240401152600.477281318@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Badhri Jagan Sridharan <badhri@google.com>

commit 197331b27ac890d0209232d5f669830cd00e8918 upstream.

While commit 69f89168b310 ("usb: typec: tpcm: Fix issues with power being
removed during reset") fixes the boot issues for bus powered devices such
as LibreTech Renegade Elite/Firefly, it trades off the CC pins NOT being
Hi-Zed during errory recovery (i.e PORT_RESET) for devices which are NOT
bus powered(a.k.a self powered). This change Hi-Zs the CC pins only for
self powered devices, thus preventing brown out for bus powered devices

Adhering to spec is gaining more importance due to the Common charger
initiative enforced by the European Union.

Quoting from the spec:
    4.5.2.2.2.1 ErrorRecovery State Requirements
    The port shall not drive VBUS or VCONN, and shall present a
    high-impedance to ground (above zOPEN) on its CC1 and CC2 pins.

Hi-Zing the CC pins is the inteded behavior for PORT_RESET.
CC pins are set to default state after tErrorRecovery in
PORT_RESET_WAIT_OFF.

    4.5.2.2.2.2 Exiting From ErrorRecovery State
    A Sink shall transition to Unattached.SNK after tErrorRecovery.
    A Source shall transition to Unattached.SRC after tErrorRecovery.

Fixes: 69f89168b310 ("usb: typec: tpcm: Fix issues with power being removed during reset")
Cc: stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Tested-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240228000512.746252-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4859,8 +4859,11 @@ static void run_state_machine(struct tcp
 		break;
 	case PORT_RESET:
 		tcpm_reset_port(port);
-		tcpm_set_cc(port, tcpm_default_state(port) == SNK_UNATTACHED ?
-			    TYPEC_CC_RD : tcpm_rp_cc(port));
+		if (port->self_powered)
+			tcpm_set_cc(port, TYPEC_CC_OPEN);
+		else
+			tcpm_set_cc(port, tcpm_default_state(port) == SNK_UNATTACHED ?
+				    TYPEC_CC_RD : tcpm_rp_cc(port));
 		tcpm_set_state(port, PORT_RESET_WAIT_OFF,
 			       PD_T_ERROR_RECOVERY);
 		break;


