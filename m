Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA2527ECC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2lFA0uP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B3CC433C7;
	Mon, 16 Oct 2023 14:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467625;
	bh=VFwuL8zT5tEkmKuoyJvylk+i1s9v0mdH+WqJ5q+MytQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2lFA0uPfIMPD2nSWMKCcjJ3W/Cm6okGTQKVWYiUliMegJLqlGtO8i33UmMXo9EeU
	 hpbc47T2kLd2knBsVFVia5bT0rbtk/PfhzHm4Ttftl+wNWBspqWvYmCZYk7G1BIWb+
	 7EhwRMXxjW8vAIUBrA7rwrEECzBLQuJ6GRheVbtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.5 029/191] ALSA: hda: cs35l41: Cleanup and fix double free in firmware request
Date: Mon, 16 Oct 2023 10:40:14 +0200
Message-ID: <20231016084016.080498062@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

commit 5d542b850d40cb08a38ad4bb2a944dbf1b7b0683 upstream.

There is an unlikely but possible double free when loading firmware,
and a missing free calls if a firmware is successfully requested but
the coefficient file request fails, leading to the fallback firmware
request occurring without clearing the previously loaded firmware.

Fixes: cd40dad2ca91 ("ALSA: hda: cs35l41: Ensure firmware/tuning pairs are always loaded")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202309291331.0JUUQnPT-lkp@intel.com/
Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231003142138.180108-1-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/cs35l41_hda.c |  115 ++++++++++++++++++++++++++++++--------------
 1 file changed, 79 insertions(+), 36 deletions(-)

--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -178,10 +178,14 @@ static int cs35l41_request_firmware_file
 					    cs35l41->speaker_id, "wmfw");
 	if (!ret) {
 		/* try cirrus/part-dspN-fwtype-sub<-spkidN><-ampname>.bin */
-		return cs35l41_request_firmware_file(cs35l41, coeff_firmware, coeff_filename,
-						     CS35L41_FIRMWARE_ROOT,
-						     cs35l41->acpi_subsystem_id, cs35l41->amp_name,
-						     cs35l41->speaker_id, "bin");
+		ret = cs35l41_request_firmware_file(cs35l41, coeff_firmware, coeff_filename,
+						    CS35L41_FIRMWARE_ROOT,
+						    cs35l41->acpi_subsystem_id, cs35l41->amp_name,
+						    cs35l41->speaker_id, "bin");
+		if (ret)
+			goto coeff_err;
+
+		return 0;
 	}
 
 	/* try cirrus/part-dspN-fwtype-sub<-ampname>.wmfw */
@@ -190,10 +194,14 @@ static int cs35l41_request_firmware_file
 					    cs35l41->amp_name, -1, "wmfw");
 	if (!ret) {
 		/* try cirrus/part-dspN-fwtype-sub<-spkidN><-ampname>.bin */
-		return cs35l41_request_firmware_file(cs35l41, coeff_firmware, coeff_filename,
-						     CS35L41_FIRMWARE_ROOT,
-						     cs35l41->acpi_subsystem_id, cs35l41->amp_name,
-						     cs35l41->speaker_id, "bin");
+		ret = cs35l41_request_firmware_file(cs35l41, coeff_firmware, coeff_filename,
+						    CS35L41_FIRMWARE_ROOT,
+						    cs35l41->acpi_subsystem_id, cs35l41->amp_name,
+						    cs35l41->speaker_id, "bin");
+		if (ret)
+			goto coeff_err;
+
+		return 0;
 	}
 
 	/* try cirrus/part-dspN-fwtype-sub<-spkidN>.wmfw */
@@ -208,10 +216,14 @@ static int cs35l41_request_firmware_file
 						    cs35l41->amp_name, cs35l41->speaker_id, "bin");
 		if (ret)
 			/* try cirrus/part-dspN-fwtype-sub<-spkidN>.bin */
-			return cs35l41_request_firmware_file(cs35l41, coeff_firmware,
-							     coeff_filename, CS35L41_FIRMWARE_ROOT,
-							     cs35l41->acpi_subsystem_id, NULL,
-							     cs35l41->speaker_id, "bin");
+			ret = cs35l41_request_firmware_file(cs35l41, coeff_firmware,
+							    coeff_filename, CS35L41_FIRMWARE_ROOT,
+							    cs35l41->acpi_subsystem_id, NULL,
+							    cs35l41->speaker_id, "bin");
+		if (ret)
+			goto coeff_err;
+
+		return 0;
 	}
 
 	/* try cirrus/part-dspN-fwtype-sub.wmfw */
@@ -226,13 +238,51 @@ static int cs35l41_request_firmware_file
 						    cs35l41->speaker_id, "bin");
 		if (ret)
 			/* try cirrus/part-dspN-fwtype-sub<-spkidN>.bin */
-			return cs35l41_request_firmware_file(cs35l41, coeff_firmware,
-							     coeff_filename, CS35L41_FIRMWARE_ROOT,
-							     cs35l41->acpi_subsystem_id, NULL,
-							     cs35l41->speaker_id, "bin");
+			ret = cs35l41_request_firmware_file(cs35l41, coeff_firmware,
+							    coeff_filename, CS35L41_FIRMWARE_ROOT,
+							    cs35l41->acpi_subsystem_id, NULL,
+							    cs35l41->speaker_id, "bin");
+		if (ret)
+			goto coeff_err;
 	}
 
 	return ret;
+coeff_err:
+	release_firmware(*wmfw_firmware);
+	kfree(*wmfw_filename);
+	return ret;
+}
+
+static int cs35l41_fallback_firmware_file(struct cs35l41_hda *cs35l41,
+					  const struct firmware **wmfw_firmware,
+					  char **wmfw_filename,
+					  const struct firmware **coeff_firmware,
+					  char **coeff_filename)
+{
+	int ret;
+
+	/* Handle fallback */
+	dev_warn(cs35l41->dev, "Falling back to default firmware.\n");
+
+	/* fallback try cirrus/part-dspN-fwtype.wmfw */
+	ret = cs35l41_request_firmware_file(cs35l41, wmfw_firmware, wmfw_filename,
+					    CS35L41_FIRMWARE_ROOT, NULL, NULL, -1, "wmfw");
+	if (ret)
+		goto err;
+
+	/* fallback try cirrus/part-dspN-fwtype.bin */
+	ret = cs35l41_request_firmware_file(cs35l41, coeff_firmware, coeff_filename,
+					    CS35L41_FIRMWARE_ROOT, NULL, NULL, -1, "bin");
+	if (ret) {
+		release_firmware(*wmfw_firmware);
+		kfree(*wmfw_filename);
+		goto err;
+	}
+	return 0;
+
+err:
+	dev_warn(cs35l41->dev, "Unable to find firmware and tuning\n");
+	return ret;
 }
 
 static int cs35l41_request_firmware_files(struct cs35l41_hda *cs35l41,
@@ -247,7 +297,6 @@ static int cs35l41_request_firmware_file
 		ret = cs35l41_request_firmware_files_spkid(cs35l41, wmfw_firmware, wmfw_filename,
 							   coeff_firmware, coeff_filename);
 		goto out;
-
 	}
 
 	/* try cirrus/part-dspN-fwtype-sub<-ampname>.wmfw */
@@ -260,6 +309,9 @@ static int cs35l41_request_firmware_file
 						    CS35L41_FIRMWARE_ROOT,
 						    cs35l41->acpi_subsystem_id, cs35l41->amp_name,
 						    -1, "bin");
+		if (ret)
+			goto coeff_err;
+
 		goto out;
 	}
 
@@ -279,32 +331,23 @@ static int cs35l41_request_firmware_file
 							    CS35L41_FIRMWARE_ROOT,
 							    cs35l41->acpi_subsystem_id, NULL, -1,
 							    "bin");
+		if (ret)
+			goto coeff_err;
 	}
 
 out:
-	if (!ret)
-		return 0;
+	if (ret)
+		/* if all attempts at finding firmware fail, try fallback */
+		goto fallback;
 
-	/* Handle fallback */
-	dev_warn(cs35l41->dev, "Falling back to default firmware.\n");
+	return 0;
 
+coeff_err:
 	release_firmware(*wmfw_firmware);
 	kfree(*wmfw_filename);
-
-	/* fallback try cirrus/part-dspN-fwtype.wmfw */
-	ret = cs35l41_request_firmware_file(cs35l41, wmfw_firmware, wmfw_filename,
-					    CS35L41_FIRMWARE_ROOT, NULL, NULL, -1, "wmfw");
-	if (!ret)
-		/* fallback try cirrus/part-dspN-fwtype.bin */
-		ret = cs35l41_request_firmware_file(cs35l41, coeff_firmware, coeff_filename,
-						    CS35L41_FIRMWARE_ROOT, NULL, NULL, -1, "bin");
-
-	if (ret) {
-		release_firmware(*wmfw_firmware);
-		kfree(*wmfw_filename);
-		dev_warn(cs35l41->dev, "Unable to find firmware and tuning\n");
-	}
-	return ret;
+fallback:
+	return cs35l41_fallback_firmware_file(cs35l41, wmfw_firmware, wmfw_filename,
+					      coeff_firmware, coeff_filename);
 }
 
 #if IS_ENABLED(CONFIG_EFI)


