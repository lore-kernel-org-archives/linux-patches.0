Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7684D26B0A5;
	Thu, 13 Feb 2025 15:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459776; cv=none; b=ZCYh8lsWWGSjzGFf/KesyGdI9f1VxQOLfLk2d7qKG6sQoPgipFE6SeEk4oKjBgQa4rhLuQg+2/ggqxn9W098kxYFxtcCqERN70ZmkR9Sft2hdTkkAEPHPvG0GOMAb4VTz6Ur+ZDnUcnWBkrZu2kFl6nUEdUHyG/hQL2uyg/Pdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459776; c=relaxed/simple;
	bh=KCNko6eA4Tz5wfJE9hg5Ocazp955M5LJanL6o2FBJ1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1CEqBEHfeDk9Veijf0VvARFXwdXD//h7kvBFLjKar/q2C3N8oEAZ5L1q60tD2ob++CJIdiIbnaMplsAIPYae1MhO7NJLkyRPymxu9tcgu2jds2uNjFOh5NQqq5PgJ3heSfDBgvjjNSyvUgHq4svPeVGUXlpbGhAQ9mC69jb+a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgR5OlDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgR5OlDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4B9C4CED1;
	Thu, 13 Feb 2025 15:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459776;
	bh=KCNko6eA4Tz5wfJE9hg5Ocazp955M5LJanL6o2FBJ1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgR5OlDOcvWxeRmolst+QRtrk7j9C63Uo0gxkMLaPCUscnBA1dAHneNaeNTd/0Eaq
	 0oo9NTg3aV64CfFz5QPAyt3dshPD4qp/Sr9/TXluwikUznkFtlaFFZmOuvt8iSaBsD
	 wtB8+BO4eVLazBIWIf3YWEnDcnQo9WR9x78usxIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genes Lists <lists@sapience.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 361/443] media: intel/ipu6: remove cpu latency qos request on error
Date: Thu, 13 Feb 2025 15:28:46 +0100
Message-ID: <20250213142454.542717722@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

commit facb541ff0805314e0b56e508f7d3cbd07af513c upstream.

Fix cpu latency qos list corruption like below. It happens when
we do not remove cpu latency request on error path and free
corresponding memory.

[   30.634378] l7 kernel: list_add corruption. prev->next should be next (ffffffff9645e960), but was 0000000100100001. (prev=ffff8e9e877e20a8).
[   30.634388] l7 kernel: WARNING: CPU: 2 PID: 2008 at lib/list_debug.c:32 __list_add_valid_or_report+0x83/0xa0
<snip>
[   30.634640] l7 kernel: Call Trace:
[   30.634650] l7 kernel:  <TASK>
[   30.634659] l7 kernel:  ? __list_add_valid_or_report+0x83/0xa0
[   30.634669] l7 kernel:  ? __warn.cold+0x93/0xf6
[   30.634678] l7 kernel:  ? __list_add_valid_or_report+0x83/0xa0
[   30.634690] l7 kernel:  ? report_bug+0xff/0x140
[   30.634702] l7 kernel:  ? handle_bug+0x58/0x90
[   30.634712] l7 kernel:  ? exc_invalid_op+0x17/0x70
[   30.634723] l7 kernel:  ? asm_exc_invalid_op+0x1a/0x20
[   30.634733] l7 kernel:  ? __list_add_valid_or_report+0x83/0xa0
[   30.634742] l7 kernel:  plist_add+0xdd/0x140
[   30.634754] l7 kernel:  pm_qos_update_target+0xa0/0x1f0
[   30.634764] l7 kernel:  cpu_latency_qos_update_request+0x61/0xc0
[   30.634773] l7 kernel:  intel_dp_aux_xfer+0x4c7/0x6e0 [i915 1f824655ed04687c2b0d23dbce759fa785f6d033]

Reported-by: Genes Lists <lists@sapience.com>
Closes: https://lore.kernel.org/linux-media/c0e94be466b367f1a3cfdc3cb7b1a4f47e5953ae.camel@sapience.com/
Fixes: f50c4ca0a820 ("media: intel/ipu6: add the main input system driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/intel/ipu6/ipu6-isys.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys.c
@@ -1133,6 +1133,7 @@ static int isys_probe(struct auxiliary_d
 free_fw_msg_bufs:
 	free_fw_msg_bufs(isys);
 out_remove_pkg_dir_shared_buffer:
+	cpu_latency_qos_remove_request(&isys->pm_qos);
 	if (!isp->secure_mode)
 		ipu6_cpd_free_pkg_dir(adev);
 remove_shared_buffer:


