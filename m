Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670D6147C7B;
	Wed, 19 Jun 2024 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803896; cv=none; b=bDatKRZrKuxvMwY4YkMX7ceLMBIGrlBkGjK9rX6UJeCn5QOlTvfhcb25dKKqOhLn7cfv7Kuq/Mz8FQGutM1I13sjYRxtezXpyfpRSmyF0o3WCWoU8eWeI9d9EJ3iGMexCEMteSWrAyyKaw5TtuyNDBEa88wI6W0vPGNzjYjnlic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803896; c=relaxed/simple;
	bh=HhZ6BhqYtdOoP1wpiIhHGhjt2c2fC5hs68t9EGVBMmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6M8k+CPVRQobBOGBEUD+i1oA59TsaiAVnScxs2kJvtcbpiUmRUrS4qMXCp9bSlmE3e/3QN3wC5NO6iUaG8ydtyw8uCVZvJSaJ9ke8WnGusMp9+XhK1d2kWydYpHCkkcmLoG6cO+J+1GDfkfAJujive5w/r9497KVRcT5ELOCxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRq8c771; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRq8c771"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1618C2BBFC;
	Wed, 19 Jun 2024 13:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803896;
	bh=HhZ6BhqYtdOoP1wpiIhHGhjt2c2fC5hs68t9EGVBMmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRq8c771VAnvfd0GtXal35ZvGlnDW6m4DGq5DqS9ZqMffywfdr7uxL+C6wlVxdn9A
	 iUeo3Sp/9fh1+8BH8e8K70e5zo8PmUa05P1CLN9ENSEZelV/S5anunzlOf+fX/Q+VT
	 2KXi1t+IZxu21G52C6g5IS22EgSdqrzpn5pmt17c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 099/217] scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory
Date: Wed, 19 Jun 2024 14:55:42 +0200
Message-ID: <20240619125600.509735630@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 4254dfeda82f20844299dca6c38cbffcfd499f41 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8497,6 +8497,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPT
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
@@ -8514,6 +8520,13 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPT
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
@@ -8805,6 +8818,12 @@ _base_check_ioc_facts_changes(struct MPT
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


