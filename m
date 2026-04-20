Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5848A33EAF9;
	Mon, 20 Apr 2026 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701054; cv=none; b=DUuVSLIOinfl0hAsoa5FESA6iXMn2Uhf6XUUZnaSj2FcJSlvwECG0qeW7+Ij/b7x/gBOvRkFX9UC0nzO9VOhYUs5rVQA/i56j1uZiW3idGvUrUaaHj8P2zSb6AILhfg6G9UEbOLdKg8JDUmBLcrB3MMLJIfI+mk+yWHvjRRHYrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701054; c=relaxed/simple;
	bh=X+GEsOws126odAYru3I+HT1uaV8GQunFQPJ0+5SXEZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NciQz+wgHR7HFxD7TIPCJFDBAA974lG/76j+c6P7nXurFjUK0dpUAUyOq5woFuZvTx8/WWToY/RE21yBx7dMEDW7Q2nyHflixHXp/fdF/nHD9I0OVTEbbI0nGzYi276Gi01HnkjQdXT15+YqXsFgxiF3Bdfwy0C9WWASLm90SM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvO/qrT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvO/qrT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E077BC2BCB4;
	Mon, 20 Apr 2026 16:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701054;
	bh=X+GEsOws126odAYru3I+HT1uaV8GQunFQPJ0+5SXEZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvO/qrT8XeBxAB4iiPTINQ6pFqqS9xREL+MLkEo9VfVqTXgCy2XrTcJA+qiyyJLvX
	 8b9yVfrWU9SppUioNyedjXY28VbwZUocJeL6gC6qq2PBXHe9lanvtG0SuNF96I02/T
	 TfxZ5gTyLXDO1enS18XLuuxiqni3uy40k4LpiMU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 163/198] PCI: endpoint: pci-epf-vntb: Stop cmd_handler work in epf_ntb_epc_cleanup
Date: Mon, 20 Apr 2026 17:42:22 +0200
Message-ID: <20260420153941.481344727@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit d799984233a50abd2667a7d17a9a710a3f10ebe2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -836,6 +836,7 @@ err_config_interrupt:
  */
 static void epf_ntb_epc_cleanup(struct epf_ntb *ntb)
 {
+	disable_delayed_work_sync(&ntb->cmd_handler);
 	epf_ntb_mw_bar_clear(ntb, ntb->num_mws);
 	epf_ntb_db_bar_clear(ntb);
 	epf_ntb_config_sspad_bar_clear(ntb);


