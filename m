Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73DE168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAEEC433D2;
	Mon,  8 May 2023 11:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544890;
	bh=pDdmsu5ZjSXezq895JcYOi7Dqz1tJtBcR0O+CujJIUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tuq0F8gkrMMk3E5zqdm3cE7Eqk1kDP/RusYVKUXITiO585KnWsZiXMsmN4UkqRa9f
	 esS90UoMdGiKQuNgPtIHUszOlg9KWkyLQLOox1Sf6sBSsDJgvZsFiwvTZ/xOyZd2ih
	 CFIbTvonPeiU+GEFcO5ez14h5PwREECIz64nvDTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Binderman <dcb314@hotmail.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 557/694] selftests/powerpc/pmu: Fix sample field check in the mmcra_thresh_marked_sample_test
Date: Mon,  8 May 2023 11:46:32 +0200
Message-Id: <20230508094452.692856379@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 8a32341cf04ba05974931b4664683c2c9fb84e56 ]

The testcase verifies the setting of different fields in Monitor Mode
Control Register A (MMCRA). In the current code, EV_CODE_EXTRACT macro
is used to extract the "sample" field, which then needs to be further
processed to fetch rand_samp_elig and rand_samp_mode bits. But the
current code is not passing valid sample field to EV_CODE_EXTRACT
macro. Patch addresses this by fixing the input for EV_CODE_EXTRACT.

Fixes: 29cf373c5766 ("selftests/powerpc/pmu: Add interface test for mmcra register fields")
Reported-by: David Binderman <dcb314@hotmail.com>
Link: https://lore.kernel.org/r/DB6P189MB0568CF002762C6C43AF6DF169CA89@DB6P189MB0568.EURP189.PROD.OUTLOOK.COM
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230301170918.69176-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pmu/sampling_tests/mmcra_thresh_marked_sample_test.c      | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/powerpc/pmu/sampling_tests/mmcra_thresh_marked_sample_test.c b/tools/testing/selftests/powerpc/pmu/sampling_tests/mmcra_thresh_marked_sample_test.c
index 022cc1655eb52..75527876ad3c1 100644
--- a/tools/testing/selftests/powerpc/pmu/sampling_tests/mmcra_thresh_marked_sample_test.c
+++ b/tools/testing/selftests/powerpc/pmu/sampling_tests/mmcra_thresh_marked_sample_test.c
@@ -63,9 +63,9 @@ static int mmcra_thresh_marked_sample(void)
 			get_mmcra_thd_stop(get_reg_value(intr_regs, "MMCRA"), 4));
 	FAIL_IF(EV_CODE_EXTRACT(event.attr.config, marked) !=
 			get_mmcra_marked(get_reg_value(intr_regs, "MMCRA"), 4));
-	FAIL_IF(EV_CODE_EXTRACT(event.attr.config, sample >> 2) !=
+	FAIL_IF((EV_CODE_EXTRACT(event.attr.config, sample) >> 2) !=
 			get_mmcra_rand_samp_elig(get_reg_value(intr_regs, "MMCRA"), 4));
-	FAIL_IF(EV_CODE_EXTRACT(event.attr.config, sample & 0x3) !=
+	FAIL_IF((EV_CODE_EXTRACT(event.attr.config, sample) & 0x3) !=
 			get_mmcra_sample_mode(get_reg_value(intr_regs, "MMCRA"), 4));
 	FAIL_IF(EV_CODE_EXTRACT(event.attr.config, sm) !=
 			get_mmcra_sm(get_reg_value(intr_regs, "MMCRA"), 4));
-- 
2.39.2



