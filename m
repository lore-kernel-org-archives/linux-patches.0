Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7355A28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC0AC433D2;
	Mon, 30 Jan 2023 14:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087535;
	bh=YFK/b+7myc/0PDNOYngnQdT2BqxT8hrms6XLvbdM5Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWl2K9R6FqzDcFw98b6W8GWs/ZQutPBe418eShqfZroR3YPpJqzP/iHC6Dazb2ldU
	 W5lX43cLOXlMSqWtDnT9+j9CYBYlLCf9akLOtovmZHJy1sXeGWgJeidCvdDr2ItLlZ
	 EHPdQoFNBA9uIxt0/hTQOBphd4jJ0Anh6056Rx/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 233/313] platform/x86: thinkpad_acpi: Fix profile modes on Intel platforms
Date: Mon, 30 Jan 2023 14:51:08 +0100
Message-Id: <20230130134347.562592630@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

commit 1bc5d819f0b9784043ea08570e1b21107aa35739 upstream.

My last commit to fix profile mode displays on AMD platforms caused
an issue on Intel platforms - sorry!

In it I was reading the current functional mode (MMC, PSC, AMT) from
the BIOS but didn't account for the fact that on some of our Intel
platforms I use a different API which returns just the profile and not
the functional mode.

This commit fixes it so that on Intel platforms it knows the functional
mode is always MMC.

I also fixed a potential problem that a platform may try to set the mode
for both MMC and PSC - which was incorrect.

Tested on X1 Carbon 9 (Intel) and Z13 (AMD).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216963
Fixes: fde5f74ccfc7 ("platform/x86: thinkpad_acpi: Fix profile mode display in AMT mode")
Cc: stable@vger.kernel.org
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230124153623.145188-1-mpearson-lenovo@squebb.ca
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/thinkpad_acpi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10500,8 +10500,7 @@ static int dytc_profile_set(struct platf
 			if (err)
 				goto unlock;
 		}
-	}
-	if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
+	} else if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
 		err = dytc_command(DYTC_SET_COMMAND(DYTC_FUNCTION_PSC, perfmode, 1), &output);
 		if (err)
 			goto unlock;
@@ -10529,14 +10528,16 @@ static void dytc_profile_refresh(void)
 			err = dytc_command(DYTC_CMD_MMC_GET, &output);
 		else
 			err = dytc_cql_command(DYTC_CMD_GET, &output);
-	} else if (dytc_capabilities & BIT(DYTC_FC_PSC))
+		funcmode = DYTC_FUNCTION_MMC;
+	} else if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
 		err = dytc_command(DYTC_CMD_GET, &output);
-
+		/* Check if we are PSC mode, or have AMT enabled */
+		funcmode = (output >> DYTC_GET_FUNCTION_BIT) & 0xF;
+	}
 	mutex_unlock(&dytc_mutex);
 	if (err)
 		return;
 
-	funcmode = (output >> DYTC_GET_FUNCTION_BIT) & 0xF;
 	perfmode = (output >> DYTC_GET_MODE_BIT) & 0xF;
 	convert_dytc_to_profile(funcmode, perfmode, &profile);
 	if (profile != dytc_current_profile) {


