Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057554;
	b=iAaNV8J5GKUs7kY9z7LoUiXKu7eUe4ov2OWgfvnu5uC49hRF342qvuFrQBxAaR/EiBma
	 lea/Tm7zoQPt6mtG60+ezwRIzbHekV9wsybgvNsQXmdws/iwft7b+IlUwTF8rqlYq7cKs
	 Z6AWKRwAukNNB7dnO2dlh6hhe3BcdHNur5Uxm09z//S68eNaWL6YqOKuHVk1jpM944m+q
	 0hnveKf+Lqao4shhhlBT9foBDWWOSkoQIrIBdcS5mKV7vl65sMZxnr+ID1kPVgBfu31Ni
	 MZadEenadRHxVAK0d/UvfzdjT+ULdrPPX0rvcWTQaSEuVI8AQST0x6vWgBAEFcrqlsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PbxkhJUMAX8Er1g1Q7Jn2PNLLA7TdyOkbH7ZUsI8YsI=;
	b=z9PAPp65sNsSzKZf4hu38RPoyg0l4dpjELl+ao+A2qpgWsIgN71ReyWr58CVsQesiq6d
	 4SFFLJpmRLpcUjupsCRWwoGjYBs/vudN2AyYem64DxRy9GA8CJIMAVek3TWyy5QVEsdet
	 Mg79wz52Gp28FVfSxVp13ZKjBDEldH1MXr+L0m19MLncjIgu7/HEEOJYDO6ZkWNQ9stzF
	 islroFXWHhw0AyZ7Tz/qx8zyqAcPwWcJwRwhToThHPpiK1JJqrSsLRLS7i7EklnC1o2/W
	 WBjnnTOV50yhDRDSyDpyd7lqea2Lh0AVniseOsnpIkdiCGQTlfz0Bnr6HaMcH6a20Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhtPifKi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F160A2603;
	Thu, 19 Nov 2026 03:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhtPifKi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8461F000C5;
	Thu, 19 Nov 2026 03:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057554;
	bh=PbxkhJUMAX8Er1g1Q7Jn2PNLLA7TdyOkbH7ZUsI8YsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhtPifKiDc2lNqw6hWS0pHKVfORVHPf4XcZxnpcia3TosLleyopYxfLAG4UBwDf0I
	 AhBdavMOboXsD0Fy8Ya4+6sh4grQYWFgvQgbv1676r7O4KAGUxKVI9HEJcSa2swCMd
	 fvGCMaJGVryRBZYjpsuwZ9KzR9h2TehcW1KtyHsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Shi <coshi036@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0170/1848] nvme: ratelimit the completion-path messages driven by device data
Date: Wed, 18 Nov 2026 15:36:48 +0100
Message-ID: <20261118145918.718100968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Shi <coshi036@gmail.com>

[ Upstream commit c05c86681170e381e24498257db3a879deb1ae89 ]

nvme_find_rq() and nvme_handle_cqe() print an unratelimited message for
every completion queue entry whose command id does not resolve to an
in-flight request.  Both are reached from the completion interrupt path
(nvme_irq() -> nvme_poll_cq() -> nvme_handle_cqe()) and the decision to
print is made entirely from device-supplied data, so a controller that
posts a stream of bogus command ids drives unbounded printk from hard
interrupt context.

This is not hypothetical.  A single boot under an emulated controller
that posts invalid completions produced 846 "could not locate request
for tag 0x0", 846 "invalid id 0 completed on queue 2" and 123 "genctr
mismatch" lines.  Once the tag set has been torn down every subsequent
completion resolves to nothing, so the print rate is bounded only by how
fast the device can post entries.

Ratelimit the three messages.  The information they carry is diagnostic
and repeats, so the suppression count printed by the ratelimit helpers
is enough to tell that the condition persists.  This matches how the
other device-driven error prints in the driver are already handled, for
example the status messages in nvme_log_error() and
nvme_log_err_passthru().

nvme_find_rq() lives in nvme.h and is shared by pci, tcp, rdma, apple and
target-loop, so all transports are covered.

Found by FuzzNvme.

Signed-off-by: Chao Shi <coshi036@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/nvme.h | 6 +++---
 drivers/nvme/host/pci.c  | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 8dfa293ccedf1..886688c02875b 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -515,12 +515,12 @@ static inline struct request *nvme_find_rq(struct blk_mq_tags *tags,
 
 	rq = blk_mq_tag_to_rq(tags, tag);
 	if (unlikely(!rq)) {
-		pr_err("could not locate request for tag %#x\n",
-			tag);
+		pr_err_ratelimited("could not locate request for tag %#x\n",
+				   tag);
 		return NULL;
 	}
 	if (unlikely(nvme_genctr_mask(nvme_req(rq)->genctr) != genctr)) {
-		dev_err(nvme_req(rq)->ctrl->device,
+		dev_err_ratelimited(nvme_req(rq)->ctrl->device,
 			"request %#x genctr mismatch (got %#x expected %#x)\n",
 			tag, genctr, nvme_genctr_mask(nvme_req(rq)->genctr));
 		return NULL;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 03df42e613f0f..1349234639eb5 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1008,9 +1008,9 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 
 	req = nvme_find_rq(nvme_queue_tagset(nvmeq), command_id);
 	if (unlikely(!req)) {
-		dev_warn(nvmeq->dev->ctrl.device,
-			"invalid id %d completed on queue %d\n",
-			command_id, le16_to_cpu(cqe->sq_id));
+		dev_warn_ratelimited(nvmeq->dev->ctrl.device,
+				     "invalid id %d completed on queue %d\n",
+				     command_id, le16_to_cpu(cqe->sq_id));
 		return;
 	}
 
-- 
2.53.0



