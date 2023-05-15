Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2B9FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27348C433EF;
	Mon, 15 May 2023 17:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170425;
	bh=a1M1EWTg/Tj3W4kFPczX5O5Q5hj7pOo9ag4sxKlJT8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWEfzxQB/vFKhKixaDAqULDQHJ//xjHb94wGUQShGQk/5BJYftopkeLm5fPj5X45j
	 EdbdK/pYg9gC+WSczh8+9FiPlQnCrv8GoDWLKukkIAejAmgpgrhAZVeqPIdTet1/iH
	 wv5EQCoV9lfbxlXpWqyYZhIllSP4QcnC3SHBAWLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 127/239] platform/x86: thinkpad_acpi: Add profile force ability
Date: Mon, 15 May 2023 18:26:30 +0200
Message-Id: <20230515161725.509045307@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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

commit 1684878952929e20a864af5df7b498941c750f45 upstream.

There has been a lot of confusion around which platform profiles are
supported on various platforms and it would be useful to have a debug
method to be able to override the profile mode that is selected.

I don't expect this to be used in anything other than debugging in
conjunction with Lenovo engineers - but it does give a way to get a
system working whilst we wait for either FW fixes, or a driver fix
to land upstream, if something is wonky in the mode detection logic

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230505132523.214338-2-mpearson-lenovo@squebb.ca
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/thinkpad_acpi.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10322,6 +10322,7 @@ static atomic_t dytc_ignore_event = ATOM
 static DEFINE_MUTEX(dytc_mutex);
 static int dytc_capabilities;
 static bool dytc_mmc_get_available;
+static int profile_force;
 
 static int convert_dytc_to_profile(int funcmode, int dytcmode,
 		enum platform_profile_option *profile)
@@ -10584,6 +10585,21 @@ static int tpacpi_dytc_profile_init(stru
 	if (err)
 		return err;
 
+	/* Check if user wants to override the profile selection */
+	if (profile_force) {
+		switch (profile_force) {
+		case -1:
+			dytc_capabilities = 0;
+			break;
+		case 1:
+			dytc_capabilities = BIT(DYTC_FC_MMC);
+			break;
+		case 2:
+			dytc_capabilities = BIT(DYTC_FC_PSC);
+			break;
+		}
+		pr_debug("Profile selection forced: 0x%x\n", dytc_capabilities);
+	}
 	if (dytc_capabilities & BIT(DYTC_FC_MMC)) { /* MMC MODE */
 		pr_debug("MMC is supported\n");
 		/*
@@ -11645,6 +11661,9 @@ MODULE_PARM_DESC(uwb_state,
 		 "Initial state of the emulated UWB switch");
 #endif
 
+module_param(profile_force, int, 0444);
+MODULE_PARM_DESC(profile_force, "Force profile mode. -1=off, 1=MMC, 2=PSC");
+
 static void thinkpad_acpi_module_exit(void)
 {
 	struct ibm_struct *ibm, *itmp;


