Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060429;
	b=LLRJH2Pemw8ICokZcbilC9lgFu8kVALMMNXKMazk2bEbeQwxr1jZSWnL1XxqeuJ97SAK
	 SBoIvpouNf8gT4lmP5QIzIC5MoHlq8SXRzP4FEipNZCeWuFvbHUddr1PiuxmN+XLRwD8i
	 LSdvTWbvxA45sK9jw6/el7OB+JcUiiT9sg30IDXajFiHs0Rp/uuBpGCS7rsgl/lDpywZT
	 guuBBXSdRyNzFmNIag5wFHWSdr4E030Qmidv6i701Nl36DVcb1vIPEBLptti/3rZAwSRp
	 KAE9cjoqKzEksmkJ+Bjl3bTLLlxPYKqWViwcE/iEHmAw41d69I/9UqQBgmaD4RamS1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=99CjqbS/lrPzzVdbpXVQ8WjXU9CJu2szMi04PZdb6K4=;
	b=ZitvXB21sE8c9Asxv0j+PFcIgT9/ihrSbdBucKdVIhbCAq/TWKZg5JMdp1oH8T0kYKYk
	 qKlEgZIf/9BvOWywy4NtP4lqVg0g8kHE6a4deLtFhnMp9QjOM3014I+xehnvvbKVmmPhO
	 +ANjHqqmaiIIbzgEiLuSau7bNmSCR08BxrDyM1Jl3orUpNEkrfC5SAiaPg3RJT8V2MH5Q
	 /+sxcq1241OfOwORWKNPiPBSoW3H9Lmh16F9sX9c4XX7GL1/rO+5Chb3q9Xw2l4QEGZCl
	 LnV45xZWgkL6puWwzBWHXNKDyMUgIdXKLUshZwxG914O1ASi7BBDPvE4xfp9oRn4RAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXnJKb9S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B1A606A33D;
	Thu, 19 Nov 2026 03:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXnJKb9S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4D51F000C4;
	Thu, 19 Nov 2026 03:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060429;
	bh=99CjqbS/lrPzzVdbpXVQ8WjXU9CJu2szMi04PZdb6K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXnJKb9SjjXEcmWbQfalwjbuSQYzdWrHPUh1CwLNuEajplVAGtdZRsQTsrDJ4gLVT
	 2Eogw3hBFVT0DujmcHIyR60f+mE+ZXM5La+DO3aln4Vo8XA4PZD4I1riw3nbRDUyZ0
	 pS1lDweqGK16FC+zFaTYgv/sPt52haXxiLMpSYss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1155/1848] microblaze: CCF: fix refcount leak
Date: Wed, 18 Nov 2026 15:53:13 +0100
Message-ID: <20261118150008.084490485@linuxfoundation.org>
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

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit aeedf85beac51c7cd8f7bf4c918a0104dfdb8b78 ]

Every value returned from of_clk_get() is supposed to be cleaned up
via clk_put() once not needed anymore.

Fixes: c1120542b99a ("microblaze: Add support for CCF")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260526184105.18962-4-grandmaster@al2klimov.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/cpu/cpuinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
index cd9b4450763b0..32c508e85408a 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -133,6 +133,7 @@ void __init setup_cpuinfo_clk(void)
 		cpuinfo.cpu_clock_freq = fcpu(cpu, "timebase-frequency");
 	} else {
 		cpuinfo.cpu_clock_freq = clk_get_rate(clk);
+		clk_put(clk);
 	}
 
 	if (!cpuinfo.cpu_clock_freq) {
-- 
2.53.0



