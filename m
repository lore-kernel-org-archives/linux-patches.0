Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7DB1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F44C433D2;
	Wed, 28 Dec 2022 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246334;
	bh=piS8tyGSI6BeipkkMuzxfgWTZq4RvjXEzat5xh+KRDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nw0XezXhIRMiGlMopwEfHws8xvM/WjUXUTl/AaHck3ZDa39fGRs93DJ+I/1Oif/je
	 7Dky1GQrGAk6p3frdkCOwSRzntOrL3FMPUiYogS9ZZU0qOLeLhadvIKCJu860K/LQ9
	 EhxwWnWPA05CvGl/mQSgTmRzF/P08BbzDZDKAAuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.0 1051/1073] regulator: core: fix deadlock on regulator enable
Date: Wed, 28 Dec 2022 15:43:59 +0100
Message-Id: <20221228144356.764690067@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit cb3543cff90a4448ed560ac86c98033ad5fecda9 upstream.

When updating the operating mode as part of regulator enable, the caller
has already locked the regulator tree and drms_uA_update() must not try
to do the same in order not to trigger a deadlock.

The lock inversion is reported by lockdep as:

  ======================================================
  WARNING: possible circular locking dependency detected
  6.1.0-next-20221215 #142 Not tainted
  ------------------------------------------------------
  udevd/154 is trying to acquire lock:
  ffffc11f123d7e50 (regulator_list_mutex){+.+.}-{3:3}, at: regulator_lock_dependent+0x54/0x280

  but task is already holding lock:
  ffff80000e4c36e8 (regulator_ww_class_acquire){+.+.}-{0:0}, at: regulator_enable+0x34/0x80

  which lock already depends on the new lock.

  ...

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(regulator_ww_class_acquire);
                                 lock(regulator_list_mutex);
                                 lock(regulator_ww_class_acquire);
    lock(regulator_list_mutex);

   *** DEADLOCK ***

just before probe of a Qualcomm UFS controller (occasionally) deadlocks
when enabling one of its regulators.

Fixes: 9243a195be7a ("regulator: core: Change voltage setting path")
Fixes: f8702f9e4aa7 ("regulator: core: Use ww_mutex for regulators locking")
Cc: stable@vger.kernel.org      # 5.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221215104646.19818-1-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -987,7 +987,7 @@ static int drms_uA_update(struct regulat
 		/* get input voltage */
 		input_uV = 0;
 		if (rdev->supply)
-			input_uV = regulator_get_voltage(rdev->supply);
+			input_uV = regulator_get_voltage_rdev(rdev->supply->rdev);
 		if (input_uV <= 0)
 			input_uV = rdev->constraints->input_uV;
 		if (input_uV <= 0) {


