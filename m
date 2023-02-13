Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF9B8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656FCC4339C;
	Mon, 13 Feb 2023 14:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300372;
	bh=cgN4FUtTnMBOtUTgQGZGPfC0mYZKLT4eTdGUnxc+xkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X78BkyZe9smGceasZlMGr4JgE4F9C+QjBPM9bugvPPJcfx+0ees7opAar5+Jrwy7o
	 Y3Hj6ZN4SVJXaKyJalR+f54BcSWMiM5rhXkpVMa3ewqQD2Ywg/0lnuyP1GBvTSidBO
	 OYjF7DbudMeCqISeQPN0jptzH3C9w2jOzztETPdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diana Zigterman <dzigterman@chromium.org>,
	Prashant Malani <pmalani@chromium.org>
Subject: [PATCH 5.15 54/67] usb: typec: altmodes/displayport: Fix probe pin assign check
Date: Mon, 13 Feb 2023 15:49:35 +0100
Message-Id: <20230213144734.955734567@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prashant Malani <pmalani@chromium.org>

commit 54e5c00a4eb0a4c663445b245f641bbfab142430 upstream.

While checking Pin Assignments of the port and partner during probe, we
don't take into account whether the peripheral is a plug or receptacle.

This manifests itself in a mode entry failure on certain docks and
dongles with captive cables. For instance, the Startech.com Type-C to DP
dongle (Model #CDP2DP) advertises its DP VDO as 0x405. This would fail
the Pin Assignment compatibility check, despite it supporting
Pin Assignment C as a UFP.

Update the check to use the correct DP Pin Assign macros that
take the peripheral's receptacle bit into account.

Fixes: c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles")
Cc: stable@vger.kernel.org
Reported-by: Diana Zigterman <dzigterman@chromium.org>
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Link: https://lore.kernel.org/r/20230208205318.131385-1-pmalani@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -533,10 +533,10 @@ int dp_altmode_probe(struct typec_altmod
 	/* FIXME: Port can only be DFP_U. */
 
 	/* Make sure we have compatiple pin configurations */
-	if (!(DP_CAP_DFP_D_PIN_ASSIGN(port->vdo) &
-	      DP_CAP_UFP_D_PIN_ASSIGN(alt->vdo)) &&
-	    !(DP_CAP_UFP_D_PIN_ASSIGN(port->vdo) &
-	      DP_CAP_DFP_D_PIN_ASSIGN(alt->vdo)))
+	if (!(DP_CAP_PIN_ASSIGN_DFP_D(port->vdo) &
+	      DP_CAP_PIN_ASSIGN_UFP_D(alt->vdo)) &&
+	    !(DP_CAP_PIN_ASSIGN_UFP_D(port->vdo) &
+	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo)))
 		return -ENODEV;
 
 	ret = sysfs_create_group(&alt->dev.kobj, &dp_altmode_group);


