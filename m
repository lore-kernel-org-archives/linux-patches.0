Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEE633CE
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EB7C433EF;
	Mon, 30 Jan 2023 14:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088415;
	bh=oe1vOrC3J2wIMZvCNfvW0PTVXGscd+F91npwP/L0YFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxiNA6lXDgaL0VCf0TKnkofJ8KxtdBWUzmveelDTayBmUasiSHSMY290oiEyITN9P
	 LOQEFIeAYmubegdaT9uQyJEQCwGQE51xey/QlfA054gntDA+CFKWXLdUjO/IsdXqmq
	 btWbTLRXp83Fpw0sb/YiX5ev6plvusXFouiq3nOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/143] firmware: arm_scmi: Harden shared memory access in fetch_response
Date: Mon, 30 Jan 2023 14:51:09 +0100
Message-Id: <20230130134307.393121517@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit ad78b81a1077f7d956952cd8bdfe1e61504e3eb8 ]

A misbheaving SCMI platform firmware could reply with out-of-spec messages,
shorter than the mimimum size comprising a header and a status field.

Harden shmem_fetch_response to properly truncate such a bad messages.

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222183823.518856-3-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/shmem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/shmem.c b/drivers/firmware/arm_scmi/shmem.c
index 0e3eaea5d852..415ef7df8fc3 100644
--- a/drivers/firmware/arm_scmi/shmem.c
+++ b/drivers/firmware/arm_scmi/shmem.c
@@ -58,10 +58,11 @@ u32 shmem_read_header(struct scmi_shared_mem __iomem *shmem)
 void shmem_fetch_response(struct scmi_shared_mem __iomem *shmem,
 			  struct scmi_xfer *xfer)
 {
+	size_t len = ioread32(&shmem->length);
+
 	xfer->hdr.status = ioread32(shmem->msg_payload);
 	/* Skip the length of header and status in shmem area i.e 8 bytes */
-	xfer->rx.len = min_t(size_t, xfer->rx.len,
-			     ioread32(&shmem->length) - 8);
+	xfer->rx.len = min_t(size_t, xfer->rx.len, len > 8 ? len - 8 : 0);
 
 	/* Take a copy to the rx buffer.. */
 	memcpy_fromio(xfer->rx.buf, shmem->msg_payload + 4, xfer->rx.len);
-- 
2.39.0



