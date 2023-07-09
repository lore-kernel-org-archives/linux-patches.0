Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF174522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D409EC433CB;
	Sun,  9 Jul 2023 11:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902428;
	bh=l1oOy5CzvbbUJu5sbUyetYlv8L5ugZrV9CmR1R/u12g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zs33CoLfAVsVocjTWywlOAAt4po91mZcECOUUF0Hl++U812mTibDaWGBlzbs6F6n8
	 FTfpfK+oCjeRbzhAouEDZAulDGQdye7Cu5rcd5diLUyFQ4QSKnqQXbEYp9vF3LFbnP
	 OjjMqBPu5MIUnnV4zbXMM4VwQE7oZWiwALi1A3kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 373/431] platform/x86: thinkpad_acpi: Fix lkp-tests warnings for platform profiles
Date: Sun,  9 Jul 2023 13:15:21 +0200
Message-ID: <20230709111459.906514841@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index e40cbe81b12c1..97c6ec12d0829 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10524,8 +10524,8 @@ static int dytc_profile_set(struct platform_profile_handler *pprof,
 static void dytc_profile_refresh(void)
 {
 	enum platform_profile_option profile;
-	int output, err = 0;
-	int perfmode, funcmode;
+	int output = 0, err = 0;
+	int perfmode, funcmode = 0;
 
 	mutex_lock(&dytc_mutex);
 	if (dytc_capabilities & BIT(DYTC_FC_MMC)) {
@@ -10538,6 +10538,8 @@ static void dytc_profile_refresh(void)
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



