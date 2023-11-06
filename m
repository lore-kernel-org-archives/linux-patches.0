Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E759D200BA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4dwKZOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6465FC433C8;
	Mon,  6 Nov 2023 13:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276562;
	bh=5P2xTagrHak8loe2MCy7J8A3FLnxolTd8zb+9zL4ewY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4dwKZOHWqiTkldNDkHxscsL1aP2e/+lJzXOM5LfmoxQGLfOxBL5JDg9pyOpPUAa2
	 4NQRGAZBY6CmD2MgmT6MfY5qMoK40HrPH1q6hSwHHiif3L45SpzeRmI47uwyLoTfSH
	 1pekIDhoZCDq2R+ThA063jFYpomLqCwATM3fGPsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Zary <linux@zary.sk>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 14/88] ata: pata_parport: fit3: implement IDE command set registers
Date: Mon,  6 Nov 2023 14:03:08 +0100
Message-ID: <20231106130306.321619580@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Zary <linux@zary.sk>

[ Upstream commit 0c1e81d0b5ebd5813536dd5fcf5966ad043f37dc ]

fit3 protocol driver does not support accessing IDE control registers
(device control/altstatus). The DOS driver does not use these registers
either (as observed from DOSEMU trace). But the HW seems to be capable
of accessing these registers - I simply tried bit 3 and it works!

The control register is required to properly reset ATAPI devices or
they will be detected only once (after a power cycle).

Tested with EXP Computer CD-865 with MC-1285B EPP cable and
TransDisk 3000.

Signed-off-by: Ondrej Zary <linux@zary.sk>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_parport/fit3.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/pata_parport/fit3.c b/drivers/ata/pata_parport/fit3.c
index bad7aa920cdca..d2b81cf2e16d2 100644
--- a/drivers/ata/pata_parport/fit3.c
+++ b/drivers/ata/pata_parport/fit3.c
@@ -9,11 +9,6 @@
  *
  * The TD-2000 and certain older devices use a different protocol.
  * Try the fit2 protocol module with them.
- *
- * NB:  The FIT adapters do not appear to support the control
- * registers.  So, we map ALT_STATUS to STATUS and NO-OP writes
- * to the device control register - this means that IDE reset
- * will not work on these devices.
  */
 
 #include <linux/module.h>
@@ -37,8 +32,7 @@
 
 static void fit3_write_regr(struct pi_adapter *pi, int cont, int regr, int val)
 {
-	if (cont == 1)
-		return;
+	regr += cont << 3;
 
 	switch (pi->mode) {
 	case 0:
@@ -59,11 +53,7 @@ static int fit3_read_regr(struct pi_adapter *pi, int cont, int regr)
 {
 	int  a, b;
 
-	if (cont) {
-		if (regr != 6)
-			return 0xff;
-		regr = 7;
-	}
+	regr += cont << 3;
 
 	switch (pi->mode) {
 	case 0:
-- 
2.42.0



