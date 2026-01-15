Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F2349B0A;
	Thu, 15 Jan 2026 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496240; cv=none; b=WfYDcx7mcaPBBDx4tY+QG9NgbtWqTZFkGDwdmj/QFp8mAvU5isTaX8l8KdCMCoAtjyZ9itCv37zswM/UK0Os0FjQJm9YaXIYpHNajQGcSRPYggmydzK5OwX3Kyz2oCf37O5yGMCF4Ej1emVZAmh0dtpujQjFV+utUiMvsWYKMyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496240; c=relaxed/simple;
	bh=hZsQA2NC2CjZRWqmwNYU63leka68y9IwtNJ2JNXK15E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ir/ksiNHZqt5LgBES6TkyaMD4PUM0sPZ6S7QWjSeNAjxiXD9kFPx2ipVVG+XkMWg1zs0C43EMBH5Yl27zpZrTNzobVN2/lliOoD79CbrtVtbd7UTybqjHARKEaoi2WuypcV1RfQOCcNk2jwB0eltmgwhYDdAlqWP3crWWTird44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbWwadq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbWwadq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66331C116D0;
	Thu, 15 Jan 2026 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496239;
	bh=hZsQA2NC2CjZRWqmwNYU63leka68y9IwtNJ2JNXK15E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbWwadq1u8/zYEafxMkD8oVUXFQ4eKtz3B48WjwtkX2pf21Jnc8J5q/AMh265LaPr
	 NkIk2tzSTWnojuiuEKakU2dSzFvAZvMKytysgcNqZLcqbDbmqG26889ojyee+xPgO+
	 mtX9AltKmp31fDcC9ff9+6uyBaCoxLZv87hGP6wk=
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
Subject: [PATCH 6.18 126/181] idpf: fix memory leak in idpf_vport_rel()
Date: Thu, 15 Jan 2026 17:47:43 +0100
Message-ID: <20260115164206.864634019@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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
index a964e0f5891eb..04af10cfaa8cb 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1082,6 +1082,8 @@ static void idpf_vport_rel(struct idpf_vport *vport)
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



