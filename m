Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F25D1D07BC;
	Wed,  2 Oct 2024 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880688; cv=none; b=scnftVkuwgJbHZjr6VmCeSmXD2M8Jv3eI9Blf5zy5rhJ3kbyGlPDe11MbNCwXnimAaCRE6GeGiT8lhxOfTlq9SCg/iqVsK8bQ5ycBNrJ4e/pOq0gUsJf6rAXcE46C0MpkMmapasXdIKSJd2vKAkkJo+npmtFqLVdfe85++FnLI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880688; c=relaxed/simple;
	bh=s5UsBfM5efp/hoz54atfg7o19ozHT8xjpHp4otF7i2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYQ97RmgCaxQoYVl3cLeWjnziKYjepkejg9cgdwZCWIC+Zvb4B/qdNbneHWjTUexMjPMug6fnhshR+IisaFVjRuTcEnDnk5Fi1gGaokwK/KzuKsGmP9Yw5nI9EMxbaB3vsuSloBFHXKQLmBf/3sGwxMNU3vemKVJmzObk02z8Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0urnBR7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0urnBR7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC4AC4CEE0;
	Wed,  2 Oct 2024 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880688;
	bh=s5UsBfM5efp/hoz54atfg7o19ozHT8xjpHp4otF7i2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0urnBR7xRNV/DNZVsG4JZZS7wbNheGasEP2DFADaHzUT3zjpzQZXy9L3cATGVBGjj
	 3GasXq//XhQbi0ozdFZtyn4noySsqmqjYNbOPg0rP4VgczAQBDKPMlJoehgptgvnT3
	 mZNlMwbJQUC5mIWV0sATLKKMi/mTG41ZGRlLkkz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olliver Schinagl <oliver@schinagl.nl>,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 537/538] thunderbolt: Fix NULL pointer dereference in tb_port_update_credits()
Date: Wed,  2 Oct 2024 15:02:56 +0200
Message-ID: <20241002125813.639964727@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
@@ -1271,6 +1271,9 @@ int tb_port_update_credits(struct tb_por
 	ret = tb_port_do_update_credits(port);
 	if (ret)
 		return ret;
+
+	if (!port->dual_link_port)
+		return 0;
 	return tb_port_do_update_credits(port->dual_link_port);
 }
 


