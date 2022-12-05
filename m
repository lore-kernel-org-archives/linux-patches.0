Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3321B15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93C0C433D6;
	Mon,  5 Dec 2022 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269084;
	bh=6USEt5q+PYRxMT7sL9GpHFmTqM97lOjmpeoCAbl/kUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qivgWPBx7WmA1c+yJSJpxHZSIrlEDTd6iFL5ZG+GpB8aQbOcG1Fyz7S5LCj1ns+cB
	 PZwZ6GTiN8v4E5Ejr1f0bZgYD8Wfygs4t79O0MXynja2lqK43PIlYJ2FPv/tyBKx4O
	 YeVwBEaBeLNm2KeZztuvnnXd51BL9OKFUc8dBNas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Dabros <jsd@semihalf.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 119/120] char: tpm: Protect tpm_pm_suspend with locks
Date: Mon,  5 Dec 2022 20:10:59 +0100
Message-Id: <20221205190810.088606151@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Dabros <jsd@semihalf.com>

commit 23393c6461422df5bf8084a086ada9a7e17dc2ba upstream.

Currently tpm transactions are executed unconditionally in
tpm_pm_suspend() function, which may lead to races with other tpm
accessors in the system.

Specifically, the hw_random tpm driver makes use of tpm_get_random(),
and this function is called in a loop from a kthread, which means it's
not frozen alongside userspace, and so can race with the work done
during system suspend:

  tpm tpm0: tpm_transmit: tpm_recv: error -52
  tpm tpm0: invalid TPM_STS.x 0xff, dumping stack for forensics
  CPU: 0 PID: 1 Comm: init Not tainted 6.1.0-rc5+ #135
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-20220807_005459-localhost 04/01/2014
  Call Trace:
   tpm_tis_status.cold+0x19/0x20
   tpm_transmit+0x13b/0x390
   tpm_transmit_cmd+0x20/0x80
   tpm1_pm_suspend+0xa6/0x110
   tpm_pm_suspend+0x53/0x80
   __pnp_bus_suspend+0x35/0xe0
   __device_suspend+0x10f/0x350

Fix this by calling tpm_try_get_ops(), which itself is a wrapper around
tpm_chip_start(), but takes the appropriate mutex.

Signed-off-by: Jan Dabros <jsd@semihalf.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/all/c5ba47ef-393f-1fba-30bd-1230d1b4b592@suse.cz/
Cc: stable@vger.kernel.org
Fixes: e891db1a18bf ("tpm: turn on TPM on suspend for TPM 1.x")
[Jason: reworked commit message, added metadata]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-interface.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -401,13 +401,14 @@ int tpm_pm_suspend(struct device *dev)
 	    !pm_suspend_via_firmware())
 		goto suspended;
 
-	if (!tpm_chip_start(chip)) {
+	rc = tpm_try_get_ops(chip);
+	if (!rc) {
 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
 			tpm2_shutdown(chip, TPM2_SU_STATE);
 		else
 			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
 
-		tpm_chip_stop(chip);
+		tpm_put_ops(chip);
 	}
 
 suspended:


