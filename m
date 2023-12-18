Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858F4988C;
	Mon, 18 Dec 2023 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Zi+YO1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F8BC433C7;
	Mon, 18 Dec 2023 14:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908144;
	bh=qLEH8d4xFJQ4x1A754AyiuwNkXmyIqZH/756St9gz9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Zi+YO1Xfk331jMVlT4NOz00wsuYnEoH4acLn3pk6wi5R9MARiQvkW2qCN7PuUYDm
	 /g7cN8LlyizDmosFGPPpNvgBdqxh7UY0nxOasX7vNoGP1cHQ5VUUBo9YsrFv8ESzJ9
	 O9z72BNPpMUFAGVTWsr8vHl/Lmlmt/IBnD64imYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 070/166] ALSA: hda/tas2781: handle missing EFI calibration data
Date: Mon, 18 Dec 2023 14:50:36 +0100
Message-ID: <20231218135108.187493198@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

commit 33071422714a4c9587753b0ccc130ca59323bf42 upstream.

The code does not properly check whether the calibration variable is
available in the EFI. If it is not available, it causes a NULL pointer
dereference.

Check the return value of the first get_variable call also.

BUG: kernel NULL pointer dereference, address: 0000000000000000
Call Trace:
 <TASK>
 ? __die+0x23/0x70
 ? page_fault_oops+0x171/0x4e0
 ? srso_alias_return_thunk+0x5/0x7f
 ? schedule+0x5e/0xd0
 ? exc_page_fault+0x7f/0x180
 ? asm_exc_page_fault+0x26/0x30
 ? crc32_body+0x2c/0x120
 ? tas2781_save_calibration+0xe4/0x220 [snd_hda_scodec_tas2781_i2c]
 tasdev_fw_ready+0x1af/0x280 [snd_hda_scodec_tas2781_i2c]
 request_firmware_work_func+0x59/0xa0

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/f1f6583bda918f78556f67d522ca7b3b91cebbd5.1702251102.git.soyer@irl.hu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -455,9 +455,9 @@ static int tas2781_save_calibration(stru
 		status = efi.get_variable(efi_name, &efi_guid, &attr,
 			&tas_priv->cali_data.total_sz,
 			tas_priv->cali_data.data);
-		if (status != EFI_SUCCESS)
-			return -EINVAL;
 	}
+	if (status != EFI_SUCCESS)
+		return -EINVAL;
 
 	tmp_val = (unsigned int *)tas_priv->cali_data.data;
 


