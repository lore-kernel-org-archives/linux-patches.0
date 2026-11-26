Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704952;
	b=JlwwF8inr5hPkpUVHSkcQ0buHFxefrsT7vPdVjG1iS1d6q49x5yaVAnA3Z2VaJrv0CHH
	 92KACma1mNQYpS5RerYvDeTqjso1b64j0yQAqFT5cJ6CDLWeM2w4qCuEpRNiSjkCi2Hxq
	 BzA/rlM9p9jm2BJdNN6Dw+l2fcabp3J+ksxb7xKg89QB97vgPDduMPWu8hQSB+t7nPQN+
	 B3hYIvzADFtzgZFCmoTdTzyYQCB0yAHbp+1UI4WusFJm7k6yGa1FwcTIK4EcqmYqZHyO8
	 yfocCGfP+409pXPVAKyY/yYaK6kyUDBD6Iq5WiHMaSxiYwSJBXIo44FGFD2NiYjrlZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZjbuOUUQGOBtXN5imZdAPdEG4W60MooFUOrqJYGSv3g=;
	b=UFSPkKMPkutXfFomvmESsCZ6s0jFY02z03w5QBIIv6HFnCUTsoRv4ON9FmEnZnT3vDIq
	 jrsuwVL1mASWgaoA7HdXL1MIRkrdkg1znERRSs6SYaaDuWRzY/3Be0YuaM4pArkoOfAzI
	 Y8EsZiAx1tmyALIpGK/mC88Wbji7RffhBLYoUMm/NYO9YgCS3f0NoCKJMP8xmj8hguhPM
	 ibb6O5eJwhhfufo1QAa77S85tg1TKARNGbavyCnauZtYt9um+H2v9VU+qqlN0cvpjF08w
	 qqcp/3vR8vyERtoJ3vmRqyApD5+3zPocK6vmEAhK9nseHZVyff8eeGyEgWJnmXvOilA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UFEVMQIX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810C2606A686;
	Thu, 26 Nov 2026 14:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UFEVMQIX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11B81F000E1;
	Thu, 26 Nov 2026 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704952;
	bh=ZjbuOUUQGOBtXN5imZdAPdEG4W60MooFUOrqJYGSv3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFEVMQIXJYBZm5Uf7+XH3yFSi6cn5er43VPwKD1HRoiWlWqz4mXOJCAsWiAU2On73
	 oLMcs4Xy83jc6HIsBFMela7w96gQxL5+R6vgiswdWtFxkBphtzmLKwC3ZxaTl2vRM1
	 TIhBHPrXrg/T1AOOaAncJTfkq0HGWuIHWLT4BaAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Tony Lindgren <tony@atomide.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/319] ARM: OMAP2+: omap4-common: Fix refcount leak bug
Date: Thu, 26 Nov 2026 15:36:17 +0100
Message-ID: <20261126144006.950889306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

commit 7c32919a378782c95c72bc028b5c30dfe8c11f82 upstream.

In omap4_sram_init(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220628112939.160737-1-windhl@126.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap4-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 0b80f8bcd3047..1553d70546c1c 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -140,6 +140,7 @@ static int __init omap4_sram_init(void)
 			__func__);
 	else
 		sram_sync = (void *)gen_pool_alloc(sram_pool, PAGE_SIZE);
+	of_node_put(np);
 
 	return 0;
 }
-- 
2.53.0



