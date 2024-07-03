Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5A21990C0;
	Wed,  3 Jul 2024 10:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003677; cv=none; b=Xkued3HVp+H4AZBqxfbbdJvXaAio8Bt5nTpw6GEnPIP8g/40ATfjyM/pvIxLcTNy1YlcB7oJ18bX3NLjr1W5/Lh6SEoGcZbJyxitL6gt8bC8u7UtjE+y1aaNcWfxX1e9CAY/52qbA6bbtqEHX7N7qN1YhAgRcTDLmEVP6R++5TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003677; c=relaxed/simple;
	bh=1aRS70xYiQXbfS6bv0hST/WOaD6Q1dp6Efo+g4g3moM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=folhtHMuWBiNutsUxe4cb/wSMS7u4yrsRhGlX4VJbpVmFa8eEFAuKH/vgF3qaDViCGu9nOgWU5YUlKoskfrWmGmTugXtyU1lkaILPsDg20fWUpWQy62KMHsGjH8kVsCkY9dcDBV1yTGA7Eg66xm9tHQvDxXWsr8HjLAyTtwOytA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nj4vsIgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nj4vsIgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5616AC2BD10;
	Wed,  3 Jul 2024 10:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003676;
	bh=1aRS70xYiQXbfS6bv0hST/WOaD6Q1dp6Efo+g4g3moM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nj4vsIghyHsoZHY3PVOZiBlRDV4+RS7x8mfJsKoHTKVqbB6SR2w+ytnwYOCXEZk/K
	 109mJWfLGnyB8663rn2bAp+da/iN6eHWjgNTeOx4hXJuW+PJOhf7wVXZh0o14QPjzT
	 JxyDT7iuikVHxVYdB0Cr51Exo3T67XHWQgUeUNxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/139] scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory
Date: Wed,  3 Jul 2024 12:39:52 +0200
Message-ID: <20240703102834.027330689@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4254dfeda82f20844299dca6c38cbffcfd499f41 ]

There is a potential out-of-bounds access when using test_bit() on a single
word. The test_bit() and set_bit() functions operate on long values, and
when testing or setting a single word, they can exceed the word
boundary. KASAN detects this issue and produces a dump:

	 BUG: KASAN: slab-out-of-bounds in _scsih_add_device.constprop.0 (./arch/x86/include/asm/bitops.h:60 ./include/asm-generic/bitops/instrumented-atomic.h:29 drivers/scsi/mpt3sas/mpt3sas_scsih.c:7331) mpt3sas

	 Write of size 8 at addr ffff8881d26e3c60 by task kworker/u1536:2/2965

For full log, please look at [1].

Make the allocation at least the size of sizeof(unsigned long) so that
set_bit() and test_bit() have sufficient room for read/write operations
without overwriting unallocated memory.

[1] Link: https://lore.kernel.org/all/ZkNcALr3W3KGYYJG@gmail.com/

Fixes: c696f7b83ede ("scsi: mpt3sas: Implement device_remove_in_progress check in IOCTL path")
Cc: stable@vger.kernel.org
Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20240605085530.499432-1-leitao@debian.org
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 54faddb637c46..b4495023edb71 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6612,6 +6612,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->pd_handles_sz = (ioc->facts.MaxDevHandle / 8);
 	if (ioc->facts.MaxDevHandle % 8)
 		ioc->pd_handles_sz++;
+	/*
+	 * pd_handles_sz should have, at least, the minimal room for
+	 * set_bit()/test_bit(), otherwise out-of-memory touch may occur.
+	 */
+	ioc->pd_handles_sz = ALIGN(ioc->pd_handles_sz, sizeof(unsigned long));
+
 	ioc->pd_handles = kzalloc(ioc->pd_handles_sz,
 	    GFP_KERNEL);
 	if (!ioc->pd_handles) {
@@ -6629,6 +6635,13 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->pend_os_device_add_sz = (ioc->facts.MaxDevHandle / 8);
 	if (ioc->facts.MaxDevHandle % 8)
 		ioc->pend_os_device_add_sz++;
+
+	/*
+	 * pend_os_device_add_sz should have, at least, the minimal room for
+	 * set_bit()/test_bit(), otherwise out-of-memory may occur.
+	 */
+	ioc->pend_os_device_add_sz = ALIGN(ioc->pend_os_device_add_sz,
+					   sizeof(unsigned long));
 	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
 	    GFP_KERNEL);
 	if (!ioc->pend_os_device_add) {
@@ -6911,6 +6924,12 @@ _base_check_ioc_facts_changes(struct MPT3SAS_ADAPTER *ioc)
 		if (ioc->facts.MaxDevHandle % 8)
 			pd_handles_sz++;
 
+		/*
+		 * pd_handles should have, at least, the minimal room for
+		 * set_bit()/test_bit(), otherwise out-of-memory touch may
+		 * occur.
+		 */
+		pd_handles_sz = ALIGN(pd_handles_sz, sizeof(unsigned long));
 		pd_handles = krealloc(ioc->pd_handles, pd_handles_sz,
 		    GFP_KERNEL);
 		if (!pd_handles) {
-- 
2.43.0



