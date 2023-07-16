Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA8E8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6863C433C8;
	Sun, 16 Jul 2023 20:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540291;
	bh=XtbKHEAoAVXkwuBWG+umUjmsPP5dvgobbhM4IXT/Ctg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1Srw5GhR0Yhwt+SqC8XC2B2UvPCZGdlIZyTcazCh4E0utld0/Q50xPWLVGcUq7Y6
	 mvwfVBRoNH9g3zndW7MRrk/m+CsEW3Orm+69erJb2ETTsx7x2bPpbJozM0RkEzqWhw
	 zboommMQUi/CPZ3rJ5HRxcgmSV2w+YbYzrzxt4F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 310/591] platform/x86: thinkpad_acpi: Fix lkp-tests warnings for platform profiles
Date: Sun, 16 Jul 2023 21:47:29 +0200
Message-ID: <20230716194931.911852237@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit f999e23ce66c1555d7b653fba171a88ecee53704 ]

Fix issues identified in dytc_profile_refresh identified by lkp-tests.
drivers/platform/x86/thinkpad_acpi.c:10538
	dytc_profile_refresh() error: uninitialized symbol 'funcmode'.
drivers/platform/x86/thinkpad_acpi.c:10531
	dytc_profile_refresh() error: uninitialized symbol 'output'.
drivers/platform/x86/thinkpad_acpi.c:10537
	dytc_profile_refresh() error: uninitialized symbol 'output'.

These issues should not lead to real problems in the field as the refresh
function should only be called if MMC or PSC mode enabled. But good to fix.

Thanks to Dan Carpenter and the lkp-tests project for flagging these.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202306011202.1hbgLRD4-lkp@intel.com/
Fixes: 1bc5d819f0b9 ("platform/x86: thinkpad_acpi: Fix profile modes on Intel platforms")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230606151804.8819-1-mpearson-lenovo@squebb.ca
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 5b2c8dd2861b7..e7ece2738de94 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10528,8 +10528,8 @@ static int dytc_profile_set(struct platform_profile_handler *pprof,
 static void dytc_profile_refresh(void)
 {
 	enum platform_profile_option profile;
-	int output, err = 0;
-	int perfmode, funcmode;
+	int output = 0, err = 0;
+	int perfmode, funcmode = 0;
 
 	mutex_lock(&dytc_mutex);
 	if (dytc_capabilities & BIT(DYTC_FC_MMC)) {
@@ -10542,6 +10542,8 @@ static void dytc_profile_refresh(void)
 		err = dytc_command(DYTC_CMD_GET, &output);
 		/* Check if we are PSC mode, or have AMT enabled */
 		funcmode = (output >> DYTC_GET_FUNCTION_BIT) & 0xF;
+	} else { /* Unknown profile mode */
+		err = -ENODEV;
 	}
 	mutex_unlock(&dytc_mutex);
 	if (err)
-- 
2.39.2



