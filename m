Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624634;
	b=Zybeg69SnqmqoaAILBC+s0X/7gV0q/XNz07DnLemxWcvM+Bz1FP6buUUFiwlIgEvkS6Y
	 hI0ICjnvdHJsHj0NIsSmBVfy/L2JJkdZHCpsRYHdpXOayqe4HG16ZIGNCIHJ4I5rc7Fvi
	 fb7sXOgTGTewHOUeQolcnzhza/jvHjT11oVr1rOO24pEwsgyrsH8TvaPZa/NwqzXmAAix
	 XsexOGJqdpdlpDl/yFvTPI2G8a0Ogt14nfhp+r88WrLthdEROwL3q16TTywtjS9RXrgbM
	 q1NYt6JeBq2eAvD4HvF9msmw5/2GIs83SvR1RiDs42txFXpbAVqYLmIdZWDNfgMdbjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OPDIR7GcI2GZtlc3lt7PlD3YM2NJvvag4PTT16ZfF48=;
	b=Vk33/rOKRd37ga56Ho3RmJ4FGy3t/kOi3eH4ypLaOnZf5ZnJGByTDZUdb6OxpNdPzmXx
	 73BlE+UjVrHtQqsK5gbcYISOZJ0nvW8hSHm6dXwKGzAzHizHMJUkjqQZOENK9rCacnw8Q
	 NdVBOQl0bFupqNGH/k2TNTlG1yySe8KgDjs2xSySGir9jefFrpkAO3vOLbasRyM8ukWZA
	 n4K5J2d+uCV+h9IXR0CvfBfQNUzV8gTOnHjfxy1g/L5hFi2eq1OmEX58C/2teqyyEr21e
	 5yeaTyI8wP0oJlfpD6HUbLpd6OZDBG9oz7QwfzrVqs/lNarJYXV9Uzz0r2nIfArg0wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O+SoE83y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A6606A33D;
	Wed, 25 Nov 2026 16:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O+SoE83y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1AD1F000D3;
	Wed, 25 Nov 2026 16:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624633;
	bh=OPDIR7GcI2GZtlc3lt7PlD3YM2NJvvag4PTT16ZfF48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+SoE83yG8TtIHIyq1OoAe5qJciKhgKMvH59DYNrtDp7zNlvTDtlZFYsvCpK9GVC+
	 p8I6GhCy0XyO/GGOm+lamAAoJcZEFDS5X9/d1fYJ8VdEMe86/eZqq3Oax9ofBqvSmj
	 yifDY5JQvLu7dS1rbae50T2d1y579tP5TXU7Ac6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/816] perf/x86/amd/uncore: Avoid context migration from non-owners
Date: Wed, 25 Nov 2026 15:30:04 +0100
Message-ID: <20261125143855.135095067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 0ae655bce1934857fa3e316ddcb4be38c30dbd38 ]

Each uncore context is owned by a single CPU that hosts all events for
the corresponding uncore domain and is advertised through the sysfs
cpumask attribute. When a CPU goes offline, the context is migrated to
an online sibling if the departing CPU is the owner.

Before commit d6389d3ccc13 ("perf/x86/amd/uncore: Refactor uncore
management"), uncore_down_prepare() checked whether the CPU going
offline owned the context. The check was lost when the function was
replaced by amd_uncore_ctx_move(). Hence, when a CPU that is not the
owner goes offline, ownership is always handed over to the first online
sibling in the uncore domain irrespective of whether another sibling
already owns it. This goes unnoticed as long as the owner is the
lowest-numbered online CPU in the domain, since the first online
sibling is then the owner itself. Once ownership has moved, that no
longer holds.

For example, consider an L3 domain spanning CPUs 8-15,136-143 and owned
by CPU 8.

  $ cat /sys/bus/event_source/devices/amd_l3/cpumask
  0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120

  $ echo 0 | sudo tee /sys/devices/system/cpu/cpu8/online
  $ cat /sys/bus/event_source/devices/amd_l3/cpumask
  0,9,16,24,32,40,48,56,64,72,80,88,96,104,112,120

  $ echo 1 | sudo tee /sys/devices/system/cpu/cpu8/online
  $ cat /sys/bus/event_source/devices/amd_l3/cpumask
  0,9,16,24,32,40,48,56,64,72,80,88,96,104,112,120

  $ echo 0 | sudo tee /sys/devices/system/cpu/cpu10/online
  $ cat /sys/bus/event_source/devices/amd_l3/cpumask
  0,8-9,16,24,32,40,48,56,64,72,80,88,96,104,112,120

Offlining CPU 8 correctly moves ownership to CPU 9 and onlining it
again leaves CPU 9 as the owner. However, offlining CPU 10 then makes
CPU 8 the owner while existing events remain on CPU 9. Both CPUs are
now advertised for the same domain, so tools that open an event on
every CPU in the cpumask count the domain twice, and the context gets
modified from two CPUs without any synchronization.

Restore the ownership check that was lost during the refactor.

Fixes: d6389d3ccc13 ("perf/x86/amd/uncore: Refactor uncore management")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/273135a6d33a40f442fb18e140a90689fae7cd32.1793614726.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 06c5e485fd6e0..78f7dbb8b181c 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -548,7 +548,7 @@ static void amd_uncore_ctx_move(struct amd_uncore *uncore, unsigned int cpu)
 	for (i = 0; i < uncore->num_pmus; i++) {
 		pmu = &uncore->pmus[i];
 		curr = *per_cpu_ptr(pmu->ctx, cpu);
-		if (!curr)
+		if (!curr || curr->cpu != cpu)
 			continue;
 
 		/* Migrate to a shared sibling if possible */
-- 
2.53.0



