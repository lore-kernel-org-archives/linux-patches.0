Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039247;
	b=iv4RGfhNBAcHxQ+gM2l8feVKzGtgPEYMPyy5qB+ou72H81wpUHesKnS/LYvc4b+VIxXw
	 YfYFsDl1YyiSsPF8XzORJFttwpBRTG5ebdEn5UB0PjklHC568OOzYto8EArukjwwCWHt9
	 81SxOJEO85qXx9mY1+1L3b3myrThS6SwLvd7lyzdxDUBA5gcfZmBq2OCfK+R33WvsB72B
	 c9MUDn9qXHZKE36i+s5toT0TriJmNWwE5FvKJ9SluIY6fw27+45Gw/baXkrVho9vfczXT
	 GzUyqK7rRERv8YDy60ZKYo/aMBg/0Q7oKHaakDNL4Es1HcST6ybLBzA2TkVNsBkXGPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WGqGGDBCaP2cYLgcORUfri083cOXDBs1xq2jMYKkWeo=;
	b=3t1bw7XVS/VQ4MrM0izkFlY9wum2bswK6or9AJYwqAZSs1fw/uMJA703HdFrVOjDx9SC
	 qX/cD9aT60j0UbmHAy7oTQHTw+Jlh33BPFYO8x7kJcoxIUJWzaZbfMp21DUosOhROihEK
	 A/Uz6NaSD9hejJUU+sQz6BVDziQlQJT3UqONbikzPFtiRl0fbEpWO/kDsHfJ0ysgrMt7j
	 4WZOzpPj/YaC5+gqc5hQRXHg2ixuQdFP9Nq4miENiPVvA8vHiYs07JUNzMlJhDjOte9Dh
	 d5fvpNr75VELFSBGhBKsErLrTiDeKb/K1UcCzZ7EmuL9N55EQlOcKEtq/9pEdzbGl7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1BX1djy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF49606A320;
	Wed, 18 Nov 2026 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1BX1djy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A848F1F000C5;
	Wed, 18 Nov 2026 22:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039247;
	bh=WGqGGDBCaP2cYLgcORUfri083cOXDBs1xq2jMYKkWeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1BX1djyvOJbsQ1Op8R3XT+wlFCJ238Ky9zdKoSWZzIlYDDc+hk6wEge8JgZRTQpx
	 WHck3/1IAL2OK8MhZ0YyzxorewZGWqiYRX6FB4yEEiVKUZ6gnIxnxkXnfIO9NWEXYd
	 jmj4f0ZQcW7Ccy3ouozi35raHzcJkJolWjLaKGrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2032/3318] microblaze: CCF: fix refcount leak
Date: Wed, 18 Nov 2026 15:44:14 +0100
Message-ID: <20261118150423.003247856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



