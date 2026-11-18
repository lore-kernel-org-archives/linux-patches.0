Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040477;
	b=chf2dfO+brETWnD9Ma5QrfzDmcAWo0kMN1LJz+uNfqpmMH8TNU/UWf7SEmgre71/78GB
	 4Om+QoSz+EVK0fhOW2vEUuEKmTnpTbQZWhJIIFGDbBCj66hckihz0TTM4PaBL8eoGx8I+
	 FGhc17Doiiz5mX6XZu76HEJIjPdkdyCNT4Rv7SEWlzIPyZf8R8yTYMCvMjpBj7qON5kqc
	 //5Q2v+hEjZ/Iv7qLSN81LuyXpGd/JvFQufPTuO2dg6A9syhoc6ekEx8Y2wQwBqci/j6g
	 dYAR0ICqk7ZM7UM7aUVzaOjFfJhtclh+Veu9rS/oWnpmGzG3s672Dkj33W54NCA7c1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BTSGCsbNhj66fNYFZTAWo58oUVAaUPJ5bG9WRTBtGnE=;
	b=xRHgr0XX6+4UwnLbm6CBHx6qJLl/HfkRdVBCeJiSEzxsIsC7urCVDCQviXFLvfIGcmJv
	 gEh9+EFfjk+owgDXaemfExqIqQYFaqkj8/5zHaP7jiRoMREFTzeaOG8vvrul9evTqepha
	 drnfzsddlx6Fa8DankSi0u/qzxjRCjDUICcj6N1/Esg5UplYEtSGOMcQ+JSvbNDM367Me
	 NL0IXm6FCT6dFzdiTboUVcQKs8675b2yrZPNuqrzBXxdOMxFRzBNgmgnQ7w0kgpGlrWC0
	 7HKVbdO96McQoa0SOw/FFSEipManbbfPlazJ6kJf+z55PX/8yZaq6PCi9dF9IQ5yfJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRNWoMcx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB196606A31C;
	Wed, 18 Nov 2026 22:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRNWoMcx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A41E1F000C4;
	Wed, 18 Nov 2026 22:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040477;
	bh=BTSGCsbNhj66fNYFZTAWo58oUVAaUPJ5bG9WRTBtGnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRNWoMcx8aEha145uMd3BJexJ76RspGNrTRei+s1Xpr2n649ij1FugTyfzEfdm01F
	 +refy1TbF8BXJuBwqcR3tfy3kwvD//DfQ5anwCVUkMygc/oYaxujefIVlllbqucZMK
	 c4HfgVpWsEHHITWdssFz5FR5xwXPo6jGYD7CGAzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2471/3318] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Date: Wed, 18 Nov 2026 15:51:33 +0100
Message-ID: <20261118150435.544294783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit e95d076bc1fca7cc36fc8f2f0e9687f79fd314bd ]

The SDMA state reference and completion cover the software cleanup
tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
flush_worker. Queued instances can therefore access an SDMA engine after
per_sdma is released.

After the state machine has stopped, cancel err_halt_worker first
because it can publish the hardware cleanup tasklet. Then kill that
tasklet and drain the remaining flush work.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134148.977-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 969c5c3ab859e..1d4760ba1b48f 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1583,6 +1583,9 @@ void sdma_exit(struct hfi1_devdata *dd)
 		 * it is not running.
 		 */
 		sdma_finalput(&sde->state);
+		cancel_work_sync(&sde->err_halt_worker);
+		tasklet_kill(&sde->sdma_hw_clean_up_task);
+		cancel_work_sync(&sde->flush_worker);
 	}
 }
 
-- 
2.53.0



