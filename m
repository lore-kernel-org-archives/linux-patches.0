Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73159367;
	Tue, 27 May 2025 17:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366062; cv=none; b=IZGRgYd0nMR4Qp7tHaMml66z/mEbHvd6GRD/fMsu6b9MC8/1akeoWgcCfx4bMrQV3c9EOrNmHG+yaSxAE8cZAV/hLLZc0UfyQiefo2hqVm1umXbOP5eCuaHduRBAaykfGQmt0zY4xyxprHClKqClQKWPgUd5JKw6svkf6TKblz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366062; c=relaxed/simple;
	bh=lpD5+ohnLSHVWvhu8g3C/I1utG8hpMM/Wg9GOkBCzB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RB1QK6XCoYhOdR4GQk5uI6/FNH68823kFh8bbQU74I/0TNjYuFNI/wUv29laQwiRpJA6r7DsKCC9Y1lC1L/hGxTvaXTr3IXoFDDnX7PRQ7ICG5UxvmJinWBFcu+JbotIwx0lvKRg3cbpLKfv39DU1hEe7iXuNfKqEAFw1Na/j34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgQcm6Er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgQcm6Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D358DC4CEE9;
	Tue, 27 May 2025 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366062;
	bh=lpD5+ohnLSHVWvhu8g3C/I1utG8hpMM/Wg9GOkBCzB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgQcm6EruHG/iFIZzJkjEn4VHhSs8Dv9kxa3IXZpPdoQrW2i2Ztul1wMYN+4ljnAL
	 uhDGYy99BhszMjFJkKsfnLQYbbouU61qIPHAdjMU5wuOnykPg8r0tm9Nh5wbwQe3iH
	 dDjRCyMbc/MG+0bp/l9YAANnjosQVkdk7ojEVuwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Tavian Barnes <tavianator@tavianator.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 548/626] ASoC: SOF: Intel: hda: Fix UAF when reloading module
Date: Tue, 27 May 2025 18:27:21 +0200
Message-ID: <20250527162507.248834195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tavian Barnes <tavianator@tavianator.com>

[ Upstream commit 7dd7f39fce0022b386ef1ea5ffef92ecc7dfc6af ]

hda_generic_machine_select() appends -idisp to the tplg filename by
allocating a new string with devm_kasprintf(), then stores the string
right back into the global variable snd_soc_acpi_intel_hda_machines.
When the module is unloaded, this memory is freed, resulting in a global
variable pointing to freed memory.  Reloading the module then triggers
a use-after-free:

BUG: KFENCE: use-after-free read in string+0x48/0xe0

Use-after-free read at 0x00000000967e0109 (in kfence-#99):
 string+0x48/0xe0
 vsnprintf+0x329/0x6e0
 devm_kvasprintf+0x54/0xb0
 devm_kasprintf+0x58/0x80
 hda_machine_select.cold+0x198/0x17a2 [snd_sof_intel_hda_generic]
 sof_probe_work+0x7f/0x600 [snd_sof]
 process_one_work+0x17b/0x330
 worker_thread+0x2ce/0x3f0
 kthread+0xcf/0x100
 ret_from_fork+0x31/0x50
 ret_from_fork_asm+0x1a/0x30

kfence-#99: 0x00000000198a940f-0x00000000ace47d9d, size=64, cache=kmalloc-64

allocated by task 333 on cpu 8 at 17.798069s (130.453553s ago):
 devm_kmalloc+0x52/0x120
 devm_kvasprintf+0x66/0xb0
 devm_kasprintf+0x58/0x80
 hda_machine_select.cold+0x198/0x17a2 [snd_sof_intel_hda_generic]
 sof_probe_work+0x7f/0x600 [snd_sof]
 process_one_work+0x17b/0x330
 worker_thread+0x2ce/0x3f0
 kthread+0xcf/0x100
 ret_from_fork+0x31/0x50
 ret_from_fork_asm+0x1a/0x30

freed by task 1543 on cpu 4 at 141.586686s (6.665010s ago):
 release_nodes+0x43/0xb0
 devres_release_all+0x90/0xf0
 device_unbind_cleanup+0xe/0x70
 device_release_driver_internal+0x1c1/0x200
 driver_detach+0x48/0x90
 bus_remove_driver+0x6d/0xf0
 pci_unregister_driver+0x42/0xb0
 __do_sys_delete_module+0x1d1/0x310
 do_syscall_64+0x82/0x190
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fix it by copying the match array with devm_kmemdup_array() before we
modify it.

Fixes: 5458411d7594 ("ASoC: SOF: Intel: hda: refactoring topology name fixup for HDA mach")
Suggested-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Tavian Barnes <tavianator@tavianator.com>
Link: https://patch.msgid.link/570b15570b274520a0d9052f4e0f064a29c950ef.1747229716.git.tavianator@tavianator.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index c924a998d6f90..9c8f79e55ec5d 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1007,7 +1007,21 @@ static void hda_generic_machine_select(struct snd_sof_dev *sdev,
 		if (!*mach && codec_num <= 2) {
 			bool tplg_fixup = false;
 
-			hda_mach = snd_soc_acpi_intel_hda_machines;
+			/*
+			 * make a local copy of the match array since we might
+			 * be modifying it
+			 */
+			hda_mach = devm_kmemdup_array(sdev->dev,
+					snd_soc_acpi_intel_hda_machines,
+					2, /* we have one entry + sentinel in the array */
+					sizeof(snd_soc_acpi_intel_hda_machines[0]),
+					GFP_KERNEL);
+			if (!hda_mach) {
+				dev_err(bus->dev,
+					"%s: failed to duplicate the HDA match table\n",
+					__func__);
+				return;
+			}
 
 			dev_info(bus->dev, "using HDA machine driver %s now\n",
 				 hda_mach->drv_name);
-- 
2.39.5



