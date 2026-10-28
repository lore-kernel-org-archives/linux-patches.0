Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211493;
	b=lAkklKPBbFa6lBDDSIRrqL65APUEV/wAPy4CE7zoQQx+Q5S/uQ1ezO4myfC8b70YcVcF
	 byMIppMPq8bsnDYv7l0aYuGT41NH7f9WSGbPqoDiVHzWoQuQPnZK9s6vjdpq/tpQs+Sxr
	 bjXmC0wd2dqLIpZky4+NEtePUmqdrjXqRBBGLCK36neUwq6jc/lNa2kQVepiVj1sIz3kK
	 SJfNskWp1Mic5SvxKFOx5tYgfSLy9wpaqrebxRWSzb93brw9qXiq5/wuBusWZkrEv+uWp
	 TUsEXojANjJ5/FYDmf2IfNIkZXr5CsEQmX/Ppukt+nLcgNntH0W09wk+Cdi1HW6rZWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/wK4o37fOCaLnumvOJau3NJy2MSK3FVx12F2WnCqQG4=;
	b=0Pe4G7p8PZRizJWM5ZfImQfIuJkQ97YpR/VdP5vN6G3qmDZjshknCtmhX8cBLvp4RVG9
	 59XuH4qRN4karsQmi1aRg8bl1LF05vFnyREBnGifjG/Bk4HvO+bCmdKur6HCepvc8MMOF
	 d26ELMYi1tcDr4ULO6qRDwjuCqxGCS9fxWPs+XDvXj4zKHWzjTdKr97EGhg7/k5gXIUu8
	 V3pkWRFx7eWacV/xK3gNBlKnv2of63cyb0WB0I0P/IcErHeRmDNw/kWvFSTbnprrm4pPf
	 /TY7hkkPOcLoFFF39c/9sTKNIxjuF2NWgp5/Tbuih8XBFA3qyPwTAajBD4mocAydCIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Of4ETpne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2C2606A321;
	Wed, 28 Oct 2026 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Of4ETpne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B561F01825;
	Wed, 28 Oct 2026 18:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211493;
	bh=/wK4o37fOCaLnumvOJau3NJy2MSK3FVx12F2WnCqQG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Of4ETpne73m/9I5bVSyd6rs6BMyJWgHNZJrXMjtlOEw8OTFceI3J/G58zQeVKxVLT
	 Anw+Vkhps/1t2h8ZHTdjlQ8nbQ/+n3BtokqAb/lD+qiG6h8go/0rMO2ZBwC1dyBvgN
	 48zZuorfDYxIQk7yWmijhA+Mk31zY1T6210x54QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 396/571] nvmet: use the local P2P device on metadata allocation failure
Date: Wed, 28 Oct 2026 17:59:03 +0100
Message-ID: <20261028170017.409191920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 4aa9c0f377a4de5e8fddce76b34ee4529639a1ff ]

nvmet_req_alloc_p2pmem_sgls() assigns req->p2p_dev only after the data
and metadata SGL allocations succeed. If the data allocation succeeds
but the metadata allocation fails, out_free_sg passes req->p2p_dev to
pci_p2pmem_free_sgl() before that assignment has taken place.

Pass the local p2p_dev argument instead, so cleanup uses the same PCI
device as the successful data allocation.

Fixes: bcd9a0797d73 ("nvmet: fix freeing unallocated p2pmem")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 0483a85850ea0..34e7b86c7d0f9 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1041,7 +1041,7 @@ static int nvmet_req_alloc_p2pmem_sgls(struct pci_dev *p2p_dev,
 
 	return 0;
 out_free_sg:
-	pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
+	pci_p2pmem_free_sgl(p2p_dev, req->sg);
 out_err:
 	return -ENOMEM;
 }
-- 
2.53.0



