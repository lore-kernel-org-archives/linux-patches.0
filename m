Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACF246A60E;
	Tue, 21 Jul 2026 19:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662289; cv=none; b=XdKu1jWgOx8NVsc1wZb3ZDE0R0XrOEey8AGigaI90ygmMOWgh0I4zB0zuimrleeoqpvcad1TrfAJzB5ZgXpB4qK4zZvy/L5dcmAO8x89B9zNwhfXP8Slxg9v+xQ2V43Ugugki/CwG8ey2JYJLLvz/6X4NzBE0I59lAAGgKSUQw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662289; c=relaxed/simple;
	bh=y3AymAmaOFUlrkbZqWG30wR7v4LIV1qWI3fN+Wr4lig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHN2nia/kli57aNAlWHhSZ9c2iz17YSXEM6dXq1uWQM+v2cu8IfF8t37I5m46yfCgr+RFHoWrFQb2UbU2mKfl1GB55+m53ivFY6vxRIFVd3ncF0fBR/sDAV/0S5FtMydWJLsTrKCHFDHr2AzaUAzTnp/TFNaATHVVujaaPmFsAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahDGZwMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahDGZwMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C195E1F00A3A;
	Tue, 21 Jul 2026 19:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662288;
	bh=ATgWBIWb2c33QFI5lsMHrolj50JADOpLK44sgXk2bM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahDGZwMpWL2nfTDRj2C0A3X+aGwWuVZprRzRJCrpF4UJEd1wvfgzneWQref3Y6+Rx
	 F08Y16vKwwnpehwNW9Bu8m/Uw5dj36c5zCCTT+eYBpAISogene9bjIKEsKnwrHJVGc
	 +0KoH3ukaiJcTpqt0mV4cdinh1Zybc0brtDE0zjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0388/1276] powerpc/powernv: fix preempt count leak in pnv_kexec_wait_secondaries_down
Date: Tue, 21 Jul 2026 17:13:51 +0200
Message-ID: <20260721152454.789429186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit 0ecd26e93e698c8327521910fc6296f5b84a4b92 ]

pnv_kexec_wait_secondaries_down() calls get_cpu() to obtain the current
CPU id but never calls the matching put_cpu(), leaking one
preempt_disable() nesting level on every invocation.

In practice the imbalance does not trigger a visible splat because the
kexec teardown path is a one-way trip: IRQs are already disabled, no
schedule() occurs after the leak, and default_machine_kexec() overwrites
preempt_count with HARDIRQ_OFFSET before jumping into kexec_sequence()
which never returns. However the bookkeeping is still wrong.

The function only needs the current CPU id, and this path runs with
interrupts disabled and the CPU pinned, so the preempt_disable()
side-effect of get_cpu() is unnecessary. Replace it with
raw_smp_processor_id().

Fixes: 298b34d7d578 ("powerpc/powernv: Fix kexec races going back to OPAL")
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260605082912.305100-3-aboorvad@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 4dbb47ddbdcc4b..06ed5e2aa26584 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -396,7 +396,8 @@ static void pnv_kexec_wait_secondaries_down(void)
 {
 	int my_cpu, i, notified = -1;
 
-	my_cpu = get_cpu();
+	/* Called with interrupts disabled, so the CPU is pinned. */
+	my_cpu = raw_smp_processor_id();
 
 	for_each_online_cpu(i) {
 		uint8_t status;
-- 
2.53.0



