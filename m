Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621731;
	b=nUaH8nJJ8JgSUKvXLJh2ryGr7czGQGbByrvkXE4QAX47zSPN8SxH8w8QK4mv6xUnuaRa
	 OD2R6yH1bNUiujykgkQmcMo59OhcLKnp2ZQQxpS7OUalm6nFhH1NeUu32Y40d9j2jlyVn
	 RJixVF+G9lrnpuNy2qUGCGmDQMrPE32+Lkfvb7tqfR+jZf2O65+Dxac18xPaf0utgms0A
	 1IUpJe61cssA30akt9wDDCb+U7YK48mGLSg04fMeGPrGJ/OQGtKjzyyFvXZvRvxcMUiw9
	 oPSAYLvjawba9j6lCqTgmcJS+lwWNvEEubuft4C+iCzccsF6BrdZioMpLLH6xoBF0hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FHLW/jMLvAE+Li626qLCNFEs6Fc2bdpYlmczMikz9ic=;
	b=e628FJeI+ERv9yKZ4lnJQuc4/adUF6zGG0ZGof43Pr6S1WAXUxRC0wYf10CadtS9Okd4
	 AlbUIFk/hxjVMX1o/EiRW4+rZ/GBvHLshQLvMPrfGw1XoBAl4gtJXgj0Q96ij3m4Yxa73
	 3rXoZxxWP+rLHIOH5AuovspI5q1TOPhBjENVBZgxM1sXptPNjJJE1CjmFDiwLAIzwnQsS
	 Xy2CcE+t3mb2at2d6IoFHVBKgLK2zIVHzmv+lrt7Q/nM5QAwRzrk0qBXAuC9uhgWibFC2
	 CyhZXGp/anfjL7pINeqE502ceo61AJQiKIQsscXrS2qrsU2iceB5ye8TIzhlNG2P+kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhuo4S9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5404606A682;
	Wed, 25 Nov 2026 15:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhuo4S9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AA21F00A00;
	Wed, 25 Nov 2026 15:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621731;
	bh=FHLW/jMLvAE+Li626qLCNFEs6Fc2bdpYlmczMikz9ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhuo4S9VrQpwqt7riUxr3GRnByXL5c3v/opbdth3epw+zc17qNtj7v0AoC+wNwE67
	 Gy4JLYgRZS7Eo2amz0MOlXhLsJAkM4c3T99UM9mp98YuQ5K/xOaB78rWmHe0g6786s
	 ykvV3XBqYcEcPZGx9Fo1zgBgJWTJu5IW+19Hj8L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 320/990] perf/x86/amd/uncore: Avoid context migration from non-owners
Date: Wed, 25 Nov 2026 15:28:07 +0100
Message-ID: <20261125143829.584978915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index c960481222727..8714e4b36ff31 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -609,7 +609,7 @@ static void amd_uncore_ctx_move(struct amd_uncore *uncore, unsigned int cpu)
 	for (i = 0; i < uncore->num_pmus; i++) {
 		pmu = &uncore->pmus[i];
 		curr = *per_cpu_ptr(pmu->ctx, cpu);
-		if (!curr)
+		if (!curr || curr->cpu != cpu)
 			continue;
 
 		/* Migrate to a shared sibling if possible */
-- 
2.53.0



