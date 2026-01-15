Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C162C028F;
	Thu, 15 Jan 2026 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496623; cv=none; b=QpD7U2ZramVPrAGlTYaMVk8QVEPOveTheTlc3Tdpt1C2cnH5v4JCugSeG96mDFkFxwOAQ/2bI9PFqe/zU6FLusgcK7bMvAxBuZ/rzAuU9uDfNg3IpA6aM6ufh652zTrRkvfuxI5IgyU9vAK8RJwtpEtzdQ0mUbIuJay1rAc0/bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496623; c=relaxed/simple;
	bh=ncroNg3cxGDY2JtcOv/nvgEK415YzPrZz0AhjRWv34k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ED6C4HrPb7tZ5KKwFHm3ES4T3fwGMmBUxayGQ5PDhWw2L8TVvZtJ0wmIR/aLSxVelDwHCiagOhyQPzUskRw64cUOYr4lzaLBHY7by1mQoclIxpScS73ukbuHPtCnV2TyTa7tsLLRHfVQTf/DL9c46Mx6t504Rrx4tvay1fEYUFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyiZKvtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyiZKvtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E026AC116D0;
	Thu, 15 Jan 2026 17:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496623;
	bh=ncroNg3cxGDY2JtcOv/nvgEK415YzPrZz0AhjRWv34k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyiZKvtVE4gbVNNrDXeYtyW9OJ3+o0BDmtbPr9aEycV3hrK2L5w/gd4avRLQLS/8k
	 mrnSUVmkuQ22DTaKWjdrVG5VuFXerEaMretxkWQMr3XuVN9Vd5uojFRmY0SmBfa3Bk
	 xAu/UjPODeog3WiMcgY+An8gPfaykju3OynbpaTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/119] idpf: fix memory leak in idpf_vport_rel()
Date: Thu, 15 Jan 2026 17:48:13 +0100
Message-ID: <20260115164154.767371937@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit f6242b354605faff263ca45882b148200915a3f6 ]

Free vport->rx_ptype_lkup in idpf_vport_rel() to avoid leaking memory
during a reset. Reported by kmemleak:

unreferenced object 0xff450acac838a000 (size 4096):
  comm "kworker/u258:5", pid 7732, jiffies 4296830044
  hex dump (first 32 bytes):
    00 00 00 00 00 10 00 00 00 10 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00  ................
  backtrace (crc 3da81902):
    __kmalloc_cache_noprof+0x469/0x7a0
    idpf_send_get_rx_ptype_msg+0x90/0x570 [idpf]
    idpf_init_task+0x1ec/0x8d0 [idpf]
    process_one_work+0x226/0x6d0
    worker_thread+0x19e/0x340
    kthread+0x10f/0x250
    ret_from_fork+0x251/0x2b0
    ret_from_fork_asm+0x1a/0x30

Fixes: 0fe45467a104 ("idpf: add create vport and netdev configuration")
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 568b57cb2298e..a0677b3277839 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -968,6 +968,8 @@ static void idpf_vport_rel(struct idpf_vport *vport)
 		kfree(adapter->vport_config[idx]->req_qs_chunks);
 		adapter->vport_config[idx]->req_qs_chunks = NULL;
 	}
+	kfree(vport->rx_ptype_lkup);
+	vport->rx_ptype_lkup = NULL;
 	kfree(vport);
 	adapter->num_alloc_vports--;
 }
-- 
2.51.0



