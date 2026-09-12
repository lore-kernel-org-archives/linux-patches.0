Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5886386559;
	Sat, 12 Sep 2026 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241791; cv=none; b=W/U3vLP0nbhDDCUuR/jXLokAIaQb1mKP96LS9se3Gn8OeoxJhz/3mluP+kb5oxiT8BX/yuMTluQPpWQ/j4Bp+MyEp0fSLxF5PTABsGCldmCP2nlUzYIlAQyaGu1ksBw3k3Ar6tpij9zy74G+sJ5VYqooJczDidwypywOAStDbK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241791; c=relaxed/simple;
	bh=YN++zgM/V0bscpXFA0W92ANvoxjqUSN94GROob/dnUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8j6eBuqZfpIS6gJpaCXXJcGhxrWRuS1Eslcn56FKw2LYfokC7S9TJkIuGkLLm7rZ4+TflGhdyRtBgGQhCCMlH/Kb8Q/vORAsF5NBIogao9DcZ87nu7nY65s7gqXRNVQQFJG+yuLLKiZJQV82ix0AjaTyuKKEF7sbjoPn4or9OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3jIVJD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3jIVJD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57F41F000FF;
	Sat, 12 Sep 2026 19:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241784;
	bh=V5I5d/PpwhkYoj1CkKfs4ZEq3Tx0Mdy+kO9a44C32nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3jIVJD4RhKM9c4FvC1wVadG4U5ftsENl98ZofNiKlL+h1jV4z2zwHH1dyV0eAYpq
	 zy7TntRUNtP1oAmXPooVhioOYFofrfv1xy64piDYivYevUogP4aLW4Y5pAlBXMIP8C
	 yiJ3McOu5zds8lqzePxsbehqmi8FCL0AtdW8ZQTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Denis Arefev <arefev@swemel.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/798] net/smc: fix potential panic dues to unprotected smc_llc_srv_add_link()
Date: Sat, 12 Sep 2026 08:57:16 +0200
Message-ID: <20260912065521.865691303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D. Wythe <alibuda@linux.alibaba.com>

commit e40b801b3603a8f90b46acbacdea3505c27f01c0 upstream.

There is a certain chance to trigger the following panic:

PID: 5900   TASK: ffff88c1c8af4100  CPU: 1   COMMAND: "kworker/1:48"
 #0 [ffff9456c1cc79a0] machine_kexec at ffffffff870665b7
 #1 [ffff9456c1cc79f0] __crash_kexec at ffffffff871b4c7a
 #2 [ffff9456c1cc7ab0] crash_kexec at ffffffff871b5b60
 #3 [ffff9456c1cc7ac0] oops_end at ffffffff87026ce7
 #4 [ffff9456c1cc7ae0] page_fault_oops at ffffffff87075715
 #5 [ffff9456c1cc7b58] exc_page_fault at ffffffff87ad0654
 #6 [ffff9456c1cc7b80] asm_exc_page_fault at ffffffff87c00b62
    [exception RIP: ib_alloc_mr+19]
    RIP: ffffffffc0c9cce3  RSP: ffff9456c1cc7c38  RFLAGS: 00010202
    RAX: 0000000000000000  RBX: 0000000000000002  RCX: 0000000000000004
    RDX: 0000000000000010  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff88c1ea281d00   R8: 000000020a34ffff   R9: ffff88c1350bbb20
    R10: 0000000000000000  R11: 0000000000000001  R12: 0000000000000000
    R13: 0000000000000010  R14: ffff88c1ab040a50  R15: ffff88c1ea281d00
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff9456c1cc7c60] smc_ib_get_memory_region at ffffffffc0aff6df [smc]
 #8 [ffff9456c1cc7c88] smcr_buf_map_link at ffffffffc0b0278c [smc]
 #9 [ffff9456c1cc7ce0] __smc_buf_create at ffffffffc0b03586 [smc]

The reason here is that when the server tries to create a second link,
smc_llc_srv_add_link() has no protection and may add a new link to
link group. This breaks the security environment protected by
llc_conf_mutex.

Fixes: 2d2209f20189 ("net/smc: first part of add link processing as SMC server")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Denis Arefev: adapted for 5.10: smc_llc_srv_add_link() has no
req_qentry argument here, as SMC-Rv2 REQ_ADD_LINK support is
not present in 5.10]
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9dabe758a31d..e76e71417a2c7 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1303,8 +1303,10 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 	smc_llc_link_active(link);
 	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
 
+	mutex_lock(&link->lgr->llc_conf_mutex);
 	/* initial contact - try to establish second link */
 	smc_llc_srv_add_link(link);
+	mutex_unlock(&link->lgr->llc_conf_mutex);
 	return 0;
 }
 
-- 
2.53.0



