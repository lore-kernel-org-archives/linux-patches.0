Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AAF134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F123C4339B;
	Mon, 12 Jun 2023 10:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566727;
	bh=yE6ZNkwiUyFipHu7AolJCJtUyVtwGLYZAofLAYPkzHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvnuxRRvRxoCyAh/ZqiqUBnq0T0XA03BcS4WPwo8wX7ZGm3LwAVExgaFbJRyVNVga
	 gueTJtaWnyoDpsnSJhWl0LNMPsrqttBxwG27EcP8iemsTdBYknVXYFUN1N5XFsiWmR
	 5Gz/b+I/dh6Y9RFlL48eGnudOo0FFDABC6ScYj6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 001/160] spi: mt65xx: make sure operations completed before unloading
Date: Mon, 12 Jun 2023 12:25:33 +0200
Message-ID: <20230612101715.190812770@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 4be47a5d59cbc9396a6ffd327913eb4c8d67a32f ]

When unloading the spi-mt65xx kernel module during an ongoing spi-mem
operation the kernel will Oops shortly after unloading the module.
This is because wait_for_completion_timeout was still running and
returning into the no longer loaded module:

Internal error: Oops: 0000000096000005 [#1] SMP
Modules linked in: [many, but spi-mt65xx is no longer there]
CPU: 0 PID: 2578 Comm: block Tainted: G        W  O       6.3.0-next-20230428+ #0
Hardware name: Bananapi BPI-R3 (DT)
pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __lock_acquire+0x18c/0x20e8
lr : __lock_acquire+0x9b8/0x20e8
sp : ffffffc009ec3400
x29: ffffffc009ec3400 x28: 0000000000000001 x27: 0000000000000004
x26: ffffff80082888c8 x25: 0000000000000000 x24: 0000000000000000
x23: ffffffc009609da8 x22: ffffff8008288000 x21: ffffff8008288968
x20: 00000000000003c2 x19: ffffff8008be7990 x18: 00000000000002af
x17: 0000000000000000 x16: 0000000000000000 x15: ffffffc008d78970
x14: 000000000000080d x13: 00000000000002af x12: 00000000ffffffea
x11: 00000000ffffefff x10: ffffffc008dd0970 x9 : ffffffc008d78918
x8 : 0000000000017fe8 x7 : 0000000000000001 x6 : 0000000000000000
x5 : ffffff807fb53910 x4 : 0000000000000000 x3 : 0000000000000027
x2 : 0000000000000027 x1 : 0000000000000000 x0 : 00000000000c03c2
Call trace:
 __lock_acquire+0x18c/0x20e8
 lock_acquire+0x100/0x2a4
 _raw_spin_lock_irq+0x58/0x74
 __wait_for_common+0xe0/0x1b4
 wait_for_completion_timeout+0x1c/0x24
 0xffffffc000acc8a4 <--- used to be mtk_spi_transfer_wait
 spi_mem_exec_op+0x390/0x3ec
 spi_mem_no_dirmap_read+0x6c/0x88
 spi_mem_dirmap_read+0xcc/0x12c
 spinand_read_page+0xf8/0x1dc
 spinand_mtd_read+0x1b4/0x2fc
 mtd_read_oob_std+0x58/0x7c
 mtd_read_oob+0x8c/0x148
 mtd_read+0x50/0x6c
 ...

Prevent this by completing in mtk_spi_remove if needed.

Fixes: 9f763fd20da7 ("spi: mediatek: add spi memory support for ipm design")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/ZFAF6pJxMu1z6k4w@makrotopia.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 9eab6c20dbc56..6e95efb50acbc 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1275,6 +1275,9 @@ static int mtk_spi_remove(struct platform_device *pdev)
 	struct mtk_spi *mdata = spi_master_get_devdata(master);
 	int ret;
 
+	if (mdata->use_spimem && !completion_done(&mdata->spimem_done))
+		complete(&mdata->spimem_done);
+
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
-- 
2.39.2



