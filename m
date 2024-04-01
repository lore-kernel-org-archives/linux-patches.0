Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C51C129;
	Mon,  1 Apr 2024 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988648; cv=none; b=PCI8pIFD7ea3laTmfqPYb5MVCbK+rC7cuWaFl0K/UqywB2aO4HRp6ybWtPdYAOlRBdhE3TsABY/TABz4X9F/exIvxFkLo8EfK/v+HNRXZeRIHNZvxCqRuO1IUSpe1WYbToRu5jl46JP+YwntG2NxsTcvoTbHfh4O0OStc9S6hOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988648; c=relaxed/simple;
	bh=J8lN1RWai3rEFGlsv/J/21gMvC3p3Bv3ygrtyp4Vzas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/ezZJ1NnZK/tzWCoJ9pe2WjOpV2OunixTRce7lXE0Cr3g6SD3SB8IVtCFhUozzMgU0K6xH7URejJuDl5wNCyU/rmCd/3V1t0pskDIxRvMA7GnVpDnSRmFwYrEK0FonG1cPiewbgZlZzQcuACPpKrukKyiNh7zH+7Gu8i9EfIHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEA3Ta2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEA3Ta2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65403C433F1;
	Mon,  1 Apr 2024 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988647;
	bh=J8lN1RWai3rEFGlsv/J/21gMvC3p3Bv3ygrtyp4Vzas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEA3Ta2ELoz87sKk98uW/UMIaGQtKGw/AoMnIn1MNM66aJuukKnC20p08Y0qhUWIF
	 e35YZa98K6w8eW7gPhkWXXQkeyoQw++Y4oIAeCGjie+RMVf9NPYKolJVxE74dtuyQa
	 Gwn1WhDNaVA1azyOPDDF9TWQHWQmIz2CcR+B0nlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olliver Schinagl <oliver@schinagl.nl>,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.7 247/432] thunderbolt: Fix NULL pointer dereference in tb_port_update_credits()
Date: Mon,  1 Apr 2024 17:43:54 +0200
Message-ID: <20240401152600.507108778@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit d3d17e23d1a0d1f959b4fa55b35f1802d9c584fa upstream.

Olliver reported that his system crashes when plugging in Thunderbolt 1
device:

 BUG: kernel NULL pointer dereference, address: 0000000000000020
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 RIP: 0010:tb_port_do_update_credits+0x1b/0x130 [thunderbolt]
 Call Trace:
  <TASK>
  ? __die+0x23/0x70
  ? page_fault_oops+0x171/0x4e0
  ? exc_page_fault+0x7f/0x180
  ? asm_exc_page_fault+0x26/0x30
  ? tb_port_do_update_credits+0x1b/0x130
  ? tb_switch_update_link_attributes+0x83/0xd0
  tb_switch_add+0x7a2/0xfe0
  tb_scan_port+0x236/0x6f0
  tb_handle_hotplug+0x6db/0x900
  process_one_work+0x171/0x340
  worker_thread+0x27b/0x3a0
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xe5/0x120
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x31/0x50
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1b/0x30
  </TASK>

This is due the fact that some Thunderbolt 1 devices only have one lane
adapter. Fix this by checking for the lane 1 before we read its credits.

Reported-by: Olliver Schinagl <oliver@schinagl.nl>
Closes: https://lore.kernel.org/linux-usb/c24c7882-6254-4e68-8f22-f3e8f65dc84f@schinagl.nl/
Fixes: 81af2952e606 ("thunderbolt: Add support for asymmetric link")
Cc: stable@vger.kernel.org
Cc: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1265,6 +1265,9 @@ int tb_port_update_credits(struct tb_por
 	ret = tb_port_do_update_credits(port);
 	if (ret)
 		return ret;
+
+	if (!port->dual_link_port)
+		return 0;
 	return tb_port_do_update_credits(port->dual_link_port);
 }
 


