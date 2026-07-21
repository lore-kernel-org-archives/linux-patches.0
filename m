Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDC044AB68;
	Tue, 21 Jul 2026 21:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669204; cv=none; b=gbk3+FZy8ehOVqx/mF8rF/fu5bxmD91hzU/CXMxl1p1T92WOxk6W662dzwAvs3pozaQof/2PtnmD8ULa/QCwkAc2uiLffheUpS/+jnFtJeObB1NdjHrsjnopdMo4m9ptEv6RWtcDBKFmD9e9n2EwMjxUN8ry/BGMlNi7YIkZMbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669204; c=relaxed/simple;
	bh=DyI2Jl+PJWzHMSd4lcNnpK0AxmmIAo/CjqdXgQJuYfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWANJ7v+Tvyz5BK3+0nspwy30udurcOn0grDVEL17H/kptnaae468FOFeQosmYGc23AzMqzJ3E5NXme+0uhtIWhM+5wQqwJEdILvLDGRyUaikwmot2MKrW2L81Xl0Lta275Qa1t3j62x9sTN8zxruhGj+0AvEZaPNcCsBU3bGAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQCvU+F4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQCvU+F4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E071F000E9;
	Tue, 21 Jul 2026 21:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669203;
	bh=990zs0XmQ7GX44lHJ1/cRR9ShDsJ6AVEFE9xo+dQMz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQCvU+F4R0r1FTvN+IR1v/rTsr4iTSa9KyxsqkWO3XAl5I0Y/2yK2YeXcbKWq7zKt
	 D9IDnB3FNwDoKp+KrJNYu5fELoOmw+Ren0yfAHh75aBNRwfx7Yo2CL6TMk0Y9flQ/u
	 JLLfp30Ehif87I5qiMs5XUTM9Jvj4HckfRNKJfi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0464/1067] powerpc/powernv: fix preempt count leak in pnv_kexec_wait_secondaries_down
Date: Tue, 21 Jul 2026 17:17:45 +0200
Message-ID: <20260721152434.997094309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 61ab2d38ff4be9..8d71e7d3a1122b 100644
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



