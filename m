Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023067;
	b=40aIo7d9tLlI/OT4XIwE2fL4GmiG9b9a3TzZh1MRNyi49sUlM4QgIIMybF9lfjEKIBBv
	 lU6WL+nu8cbv8/gGml1lnS0PZDKkb63r3GlpybDQDBvsnI26K44BmktjygMRpKMkwg4iQ
	 DPMmqIHYBBU91lFCaiwJg5uS6FUTx2T5hQgydMJ2aquddZFWbshmEjeIo1+/5UMRBZ1+3
	 R9khGu4Cjy2PSP0j+VsgWwP7kRg9KwyO0cjKt0Zv3fSxY8dI502i4jpJDdFcGAV4oqmYY
	 fhyy5VOStASZANxuAW5ce3gldLj/u0BFZgwdY07igZQSSDBZ69Wojxo0kiicby3MREg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHyzvrzQkW0kSqiFC6Xjv0XvLsFcbqKpVObXeJZhIMw=;
	b=OxjVbd4XyX/VgzlXASA3dqltC7/8i/eGSePT1Bul8XQCY6kffMYHGWbzMtgKqFfF+nrn
	 70QUTlNu3yabSaQKgkUtyHOAoKE7lKGCSFEK7MMvj92PV5mtcYrwhU1qujwQsKB2ZDyUq
	 Cv6N7aiF77pecBWOFlStEYosboSlESyAS1n3aJxd2lcqew9jzkpQh5K4Imw/RXgiTMlhy
	 0eBfmuD62ujV+p2hOesi2CATt6sK2fKnh/ukEsyv9o/ybdffTvUQ2NY9rLJiVm0mrKlKY
	 B+eiZcqq3gsrfdoXZC5aqhC+wzrnQMkKzArd41q+bZeAkVcI+aU3C8ROLii30PtEjgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGObohbs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753F1606A31C;
	Wed, 18 Nov 2026 17:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGObohbs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF85A1F000C4;
	Wed, 18 Nov 2026 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023067;
	bh=ZHyzvrzQkW0kSqiFC6Xjv0XvLsFcbqKpVObXeJZhIMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGObohbsnYlJ+0QXiYbdkNIOBxkBBJh0QEhHsh7FNi2dI4NPrlkaTu3C4+S2T9X2O
	 BcU72srUBhekW+jI2FGqko+z6hogkPmFCj4S7fzNp9KfiZfDGqIuvXh6TLhWqb5LNi
	 b35yzQGVkC60tF1fv5zA5SALZUB93aTGK/BMZmOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0190/2151] microblaze: CCF: fix refcount leak
Date: Wed, 18 Nov 2026 15:32:05 +0100
Message-ID: <20261118150128.705282229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



