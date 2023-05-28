Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4A3611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C93FC433EF;
	Sun, 28 May 2023 19:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303289;
	bh=7SXIzSWVYxaLylOXikH04ra0zYAkWZiQ6XffNPjBdNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNGrORXugHAECImAj+VnfYvG2sbgRqkcRIvSJPdg+2rW41AR7/VGh5kx1GVtigrQH
	 YUDClanDutTKLgOYj+TSngjkLRZPJomAoAiDFClLUAhsFRvKihG6wqn+M0dhAZQnAr
	 Inw9idxNEyHC718kLVXGrvlTHESUc8vRf7sjLg2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 19/69] parisc: Allow to reboot machine after system halt
Date: Sun, 28 May 2023 20:11:39 +0100
Message-Id: <20230528190829.063886261@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 2028315cf59bb899a5ac7e87dc48ecb8fac7ac24 upstream.

In case a machine can't power-off itself on system shutdown,
allow the user to reboot it by pressing the RETURN key.

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/process.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -120,13 +120,18 @@ void machine_power_off(void)
 	/* It seems we have no way to power the system off via
 	 * software. The user has to press the button himself. */
 
-	printk(KERN_EMERG "System shut down completed.\n"
-	       "Please power this system off now.");
+	printk("Power off or press RETURN to reboot.\n");
 
 	/* prevent soft lockup/stalled CPU messages for endless loop. */
 	rcu_sysrq_start();
 	lockup_detector_soft_poweroff();
-	for (;;);
+	while (1) {
+		/* reboot if user presses RETURN key */
+		if (pdc_iodc_getc() == 13) {
+			printk("Rebooting...\n");
+			machine_restart(NULL);
+		}
+	}
 }
 
 void (*pm_power_off)(void);


