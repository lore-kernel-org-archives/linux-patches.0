Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061584;
	b=yQtpFtjfcl82Ql9i0IPgj1OVoJ7xjoS3q6KApQ9JzbmuDtuGGf1rKgYoNkL/doILVH3q
	 i1XTllfC9fgmKJjNDJI+FFQBPl4ExiXf5WSTrxUaSG3fmRQHTiCYYj1kds9Ta/XJz1aEf
	 e6gHC2AaLb5paXLZyNDfA+sp++KMIRIMg67vM2SAImXHb27UNS9BfsxCZoKqyRLJaQil1
	 gKvmjpIau5DN33KPWs8XEDaws541EXRu5qQkrOxL72Maq0AC6nayZeah/GqxkN9AxKAI2
	 SUn3gQ4vRpXj6J8Qzzu4LcTFLqNv7EUoE0kyXDbiQy2B5GNKC87B2AVkXVpIbWY0/bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Vj1IXcbbF9uxvpdIBR6EQ39l3uQLXIqsRBf387CTfQ=;
	b=EJm6UONKWInjZCaLXBYyB7h4DJtnzBx9oETq2u9V94583m0PmMeMdj+ZV4OLaFFzza/T
	 6gvqHWiPyLQNA5vweOLLBFNG5JUEYXRadPwnTiiS5NHPOptaxlPVcRq1C4YNantGvf1gY
	 +1LtREPkOCQ4G1VQ86dOSAdbsleZ5TUXgLVeoaquTGnNlX7+brHPStzdbSePrnzpHPN6t
	 8QjHsPhkIo1LW70YcJkZd2HQz5CkEXgabnxBiIxnHKkpcotz8IvTbMTp7YTH9Qay4eTX5
	 R6UNDN+xhBGlpcieowsogixSZ5mpPWGQed/qMfUVpZVv64/6MQTvNCbWAlhiZPoZfjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iuvi5jPp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7A7606A32F;
	Thu, 19 Nov 2026 04:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iuvi5jPp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D461F000C4;
	Thu, 19 Nov 2026 04:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061584;
	bh=6Vj1IXcbbF9uxvpdIBR6EQ39l3uQLXIqsRBf387CTfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iuvi5jPplH/89GFN3+be3FkceONHYYuuP+strx3KrfuqDn9dyROaKEAC7TA7nBqmv
	 4GY1ZbG3ymPtGK/RTh5J1po5Ot6XGwQRnp4hy5Yy4Ukjbmz73LSxNDodzQfKAWaWRU
	 SIGMQ+j8IulPR/pRO5tLad065i4/OY7CyEZsFWjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1606/1848] s390/uprobes: Fix off-by-one bug in emulated PER handling
Date: Wed, 18 Nov 2026 16:00:44 +0100
Message-ID: <20261118150026.787994695@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 2ba01cf7b2598571486425a0605f1434909b532d ]

The uprobes code emulates some instructions, and with that also
PER storage-alteration handling, in case a debugger is attached.

The PER storage-alteration handling contains an off-by-one bug, which
may lead to PER traps which should not happen. Adjust the comparison
in sim_stor_event() to fix that.

Fixes: 8d1a2427d8fc ("s390/uprobes: fix user space PER events")
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uprobes.c b/arch/s390/kernel/uprobes.c
index 5007fac01bb5e..6fce1b1bef86e 100644
--- a/arch/s390/kernel/uprobes.c
+++ b/arch/s390/kernel/uprobes.c
@@ -253,7 +253,7 @@ static void sim_stor_event(struct pt_regs *regs, void *addr, int len)
 		return;
 	if (!(current->thread.per_user.control & PER_EVENT_STORE))
 		return;
-	if ((void *)current->thread.per_user.start > (addr + len))
+	if ((void *)current->thread.per_user.start > (addr + len - 1))
 		return;
 	if ((void *)current->thread.per_user.end < addr)
 		return;
-- 
2.53.0



