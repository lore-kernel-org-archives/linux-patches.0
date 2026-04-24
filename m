Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE23419A288;
	Fri, 24 Apr 2026 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037952; cv=none; b=GuuE+mTc+rmKNNd83XEEHbxlqa8bmLS8DTItPYRGaJRyR0jXT08WNpsk30jF0v48E/P0Cl0vOyNk+yVbpo/XU4HZi/REue5r4gOq4dBBruBaReqqwR5geqxChbQbKIwydzEUeuplThcZRaV5gOZLN07iuwulVaPMfF0zVC11UE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037952; c=relaxed/simple;
	bh=05YhkXgY3jh6VdFmobzNFIIir2ICzxA8au+zXRNhczc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUa3Smq/DDx/8bVvzh+dgcx9TV0gHxcFaiVk4qF3IK8YttpRQCkjqixgAyM+RvM42AGfxc5B0n/vBmIeo9J1+MuBkEW4LMhVgsbZdD92jhnyC/i6WEIW4Ke1UYNRjUOQW27ZHciLhELwtxvFoEHSJdOFZTJFg1ZP9PzQHTDmbow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qB/Q2sD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qB/Q2sD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB0CC19425;
	Fri, 24 Apr 2026 13:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037952;
	bh=05YhkXgY3jh6VdFmobzNFIIir2ICzxA8au+zXRNhczc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qB/Q2sD1+qvRRm1WACc5EJvX8atXty8qui2pZssKgf7BX97fiklgf/FZGwjofuUj5
	 Mz1u/ZXjqAcYIulZodxpX5p4CFkTDG/WzQeeYAvUuDoQKTo/bSbITbT38YaWkNEPq5
	 Mkwt3/KhU8z0Bb3LSx2ZyEspDo6g4Op23xXzXiI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/166] PCI: endpoint: pci-epf-vntb: Stop cmd_handler work in epf_ntb_epc_cleanup
Date: Fri, 24 Apr 2026 15:30:48 +0200
Message-ID: <20260424132600.936800589@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit d799984233a50abd2667a7d17a9a710a3f10ebe2 ]

Disable the delayed work before clearing BAR mappings and doorbells to
avoid running the handler after resources have been torn down.

  Unable to handle kernel paging request at virtual address ffff800083f46004
  [...]
  Internal error: Oops: 0000000096000007 [#1]  SMP
  [...]
  Call trace:
   epf_ntb_cmd_handler+0x54/0x200 [pci_epf_vntb] (P)
   process_one_work+0x154/0x3b0
   worker_thread+0x2c8/0x400
   kthread+0x148/0x210
   ret_from_fork+0x10/0x20

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260226084142.2226875-4-den@valinux.co.jp
[ replaced disable_delayed_work_sync() with cancel_delayed_work_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -798,6 +798,7 @@ err_config_interrupt:
  */
 static void epf_ntb_epc_cleanup(struct epf_ntb *ntb)
 {
+	cancel_delayed_work_sync(&ntb->cmd_handler);
 	epf_ntb_mw_bar_clear(ntb, ntb->num_mws);
 	epf_ntb_db_bar_clear(ntb);
 	epf_ntb_config_sspad_bar_clear(ntb);


