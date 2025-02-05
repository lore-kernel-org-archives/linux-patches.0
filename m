Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0CDDF59;
	Wed,  5 Feb 2025 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767178; cv=none; b=QZxylw30R8UTv/an4gADHxrBSdznwxPdCmPCL86wk1FlCPWDfqYYwEXZtsBLTXe7e4t8zfvZzFPEcdlvk9AeHrr2NrRcViiE1AfxmFkPE9sOE7CmQFHMxTxLjB4cbgv0jvSm5xh9jh5Ab4oJeN1oDyIm+tlnqFwBmbaBqpFu058=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767178; c=relaxed/simple;
	bh=NV5aNkm8PMORBYPCaVCaS/FVbvjrMdPMaNZS1SiPFrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEo+DrD/yapMCbDiDgXhQ1B9xBCvjhnYThEOg//sR+tjMAhFiVFO5aC3Tj5YOrXbpxHcw9PsI5ez+kQ/0vnr9FyMw+1DW2rw8rijCPl+sOkryzblzNtKI0LX5r3PENWzvMy+1NP5I1eDWbhCyH8GBO4lWoPZHv3cEfnDOGi1p1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gC6dUhie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gC6dUhie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880E1C4CED1;
	Wed,  5 Feb 2025 14:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767178;
	bh=NV5aNkm8PMORBYPCaVCaS/FVbvjrMdPMaNZS1SiPFrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gC6dUhieqxeTQ8TuY9xb30Ok0eaGhOCCWdHx81WLGvfGxS4pPUUxomT8aRcjhsvsS
	 1qGQlkTO+dKAUlX+3L1uW8j8hkmKh11l/0X6q/leRS1PrXJtwNexpUeTjy9ARVHU9s
	 TZAkyeXi3ve3lW8hOuji0dWTJB3Y3es3otgGNoS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 394/590] i3c: dw: Fix use-after-free in dw_i3c_master driver due to race condition
Date: Wed,  5 Feb 2025 14:42:29 +0100
Message-ID: <20250205134510.339770083@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit b75439c945b94dd8a2b645355bdb56f948052601 ]

In dw_i3c_common_probe, &master->hj_work is bound with
dw_i3c_hj_work. And dw_i3c_master_irq_handler can call
dw_i3c_master_irq_handle_ibis function to start the work.

If we remove the module which will call dw_i3c_common_remove to
make cleanup, it will free master->base through i3c_master_unregister
while the work mentioned above will be used. The sequence of operations
that may lead to a UAF bug is as follows:

CPU0                                      CPU1

                                     | dw_i3c_hj_work
dw_i3c_common_remove                 |
i3c_master_unregister(&master->base) |
device_unregister(&master->dev)      |
device_release                       |
//free master->base                  |
                                     | i3c_master_do_daa(&master->base)
                                     | //use master->base

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in dw_i3c_common_remove.

Fixes: 1dd728f5d4d4 ("i3c: master: Add driver for Synopsys DesignWare IP")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Acked-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Link: https://lore.kernel.org/r/bfc49c9527be5b513e7ceafeba314ca40a5be4bc.1732703537.git.xiaopei01@kylinos.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 8d694672c1104..dbcd3984f2578 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1624,6 +1624,7 @@ EXPORT_SYMBOL_GPL(dw_i3c_common_probe);
 
 void dw_i3c_common_remove(struct dw_i3c_master *master)
 {
+	cancel_work_sync(&master->hj_work);
 	i3c_master_unregister(&master->base);
 
 	pm_runtime_disable(master->dev);
-- 
2.39.5



