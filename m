Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC3F173339;
	Wed,  3 Jul 2024 11:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005532; cv=none; b=Wz2s4suk/ClBTfRHWzq81M2OWEgmBxXV4ZpaZsAorUCpe8WWDwoAN54cQ+DVC1qLTkn8OQsMjOMbr0l3fCZ8LyWc/e0NFKcPGJXF6Af11K+skM4ERxRVvp6iM/zECixCqvbDKZi42BWYB5/6iRyq9jy4kxykEYS5qpTYzH+c2OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005532; c=relaxed/simple;
	bh=uM4gdNwzHgdADHzAZzu4BxdvwjdHgIPNjlHfSNU+tik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkFUVX6fLlmqag+cjUd5jwTAmAeOeo6OqLA5HzHSacMUi3TUaD9Y2PKH2klPWvrv0i3lutexglf8CmGOtq+UNgcZTSEZ52MW1iHXddZYO0+EDmqFfdWd2IDuE09uRAzGiIO10okNMQgCNuQcWUlk1uYX1o+lAq4/3NrBkUQnZ4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0lWmpxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0lWmpxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C175C2BD10;
	Wed,  3 Jul 2024 11:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005532;
	bh=uM4gdNwzHgdADHzAZzu4BxdvwjdHgIPNjlHfSNU+tik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0lWmpxEmOvhJYqe7XJbVR9mPs7YI84s4OuZlSpkpxNJI/8OHCStjBbtx16/OC/l7
	 /WX2KbXGN3k4EGFN8d1IQwfN3T8KELr6MrCWR0Ux/7ROvUU+SieGrWINkU2t72xxCP
	 G/Go6k2Orb2UChdVeepTXWAJ1aCjv6qewduEcO1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 082/356] scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory
Date: Wed,  3 Jul 2024 12:36:58 +0200
Message-ID: <20240703102916.205342535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8337,6 +8337,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPT
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
@@ -8354,6 +8360,13 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPT
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
@@ -8645,6 +8658,12 @@ _base_check_ioc_facts_changes(struct MPT
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


