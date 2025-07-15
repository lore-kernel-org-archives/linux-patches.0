Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C921B2C327B;
	Tue, 15 Jul 2025 13:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585706; cv=none; b=fc8exUyitvNPQr4DSpuv3DwY/9Da0mwuoBhbNUES2f9SE6tuaz1cicjyVi2E0OW/smVu7RQzpkvDi2e7IHPMhaKHGDBmVwt5iGUirRLuBfkhlibM0OS69/etTXiW1f7NgkKzmi+8/5JMzO09BSTkzpV4nzPAfvbIy+9xVf8OeXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585706; c=relaxed/simple;
	bh=cdtII8mPTyjyR/+qiSjKhGxB7Rvm+CYI/2Q8oEvVj1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPUel+0kbwHbNpusjURXBhWn0ZmtvEJdZq7tScuFUDwK0F80UQM5eJXEPdBJPXYNVZF+dUDR7klx1GPt2Q1AlKu0CYG4rrcMifJxAgMTz1xWa5wsJxXzydU8TO+UhHORsngLbv70nKKCZq/TDZqXe/wKqwmISVr4QNqTHhX35Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTa1kpBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTa1kpBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D193C4CEE3;
	Tue, 15 Jul 2025 13:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585706;
	bh=cdtII8mPTyjyR/+qiSjKhGxB7Rvm+CYI/2Q8oEvVj1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTa1kpBFqUKi4iseBSyltLkZKmKnXDXoQMDCizgTFI00ax4xEm3/Rid/dz+5bIjuJ
	 06KZJFeTJxF9Xa0U4F9Ir3QK3kl1uuS6+3P58DHQ3CMTpOJZ4CFv+jdJ3fBEZk9o6Y
	 JRsL60InhxcHDXKt+5bFImUu1vuLpkmrq1IZV0XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamura Dai <kirinode0@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/163] ASoC: SOF: Intel: hda: Use devm_kstrdup() to avoid memleak.
Date: Tue, 15 Jul 2025 15:13:29 +0200
Message-ID: <20250715130814.491095808@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

From: Tamura Dai <kirinode0@gmail.com>

[ Upstream commit 6c038b58a2dc5a008c7e7a1297f5aaa4deaaaa7e ]

sof_pdata->tplg_filename can have address allocated by kstrdup()
and can be overwritten. Memory leak was detected with kmemleak:

unreferenced object 0xffff88812391ff60 (size 16):
  comm "kworker/4:1", pid 161, jiffies 4294802931
  hex dump (first 16 bytes):
    73 6f 66 2d 68 64 61 2d 67 65 6e 65 72 69 63 00  sof-hda-generic.
  backtrace (crc 4bf1675c):
    __kmalloc_node_track_caller_noprof+0x49c/0x6b0
    kstrdup+0x46/0xc0
    hda_machine_select.cold+0x1de/0x12cf [snd_sof_intel_hda_generic]
    sof_init_environment+0x16f/0xb50 [snd_sof]
    sof_probe_continue+0x45/0x7c0 [snd_sof]
    sof_probe_work+0x1e/0x40 [snd_sof]
    process_one_work+0x894/0x14b0
    worker_thread+0x5e5/0xfb0
    kthread+0x39d/0x760
    ret_from_fork+0x31/0x70
    ret_from_fork_asm+0x1a/0x30

Signed-off-by: Tamura Dai <kirinode0@gmail.com>
Link: https://patch.msgid.link/20250615235548.8591-1-kirinode0@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 9c8f79e55ec5d..624598c9e2df8 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1209,11 +1209,11 @@ static int check_tplg_quirk_mask(struct snd_soc_acpi_mach *mach)
 	return 0;
 }
 
-static char *remove_file_ext(const char *tplg_filename)
+static char *remove_file_ext(struct device *dev, const char *tplg_filename)
 {
 	char *filename, *tmp;
 
-	filename = kstrdup(tplg_filename, GFP_KERNEL);
+	filename = devm_kstrdup(dev, tplg_filename, GFP_KERNEL);
 	if (!filename)
 		return NULL;
 
@@ -1297,7 +1297,7 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 		 */
 		if (!sof_pdata->tplg_filename) {
 			/* remove file extension if it exists */
-			tplg_filename = remove_file_ext(mach->sof_tplg_filename);
+			tplg_filename = remove_file_ext(sdev->dev, mach->sof_tplg_filename);
 			if (!tplg_filename)
 				return NULL;
 
-- 
2.39.5



