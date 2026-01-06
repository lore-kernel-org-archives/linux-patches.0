Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0AB2749D5;
	Tue,  6 Jan 2026 17:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721597; cv=none; b=HDXHVbg2zmSEkVKJfJPXZx7QuNQNtl9aIVM5VrnfHK2/8wOdwyayRy1gcrqOmwmH/1aleALp3LxToqbUOGHFencdV3XzpdRn3Rpnf7msTYho3zkU1Kd+CLek63t+c+AgU+C/amyDNRvnfitx0nEwU/fYsG3Wh8WcjAEarDvc8zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721597; c=relaxed/simple;
	bh=J4QeRzuXO3Vwn9QO+opyhfZPGybutp7jYZ3s3cR8tyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNt4mdfNUcuMuH7z48dGir9qmgnigZCXN2zAi+7V78L1GwcesmoyHdpsZLtxDF+ET3frPYFHEukccnchtvBiGG7rIOR1gEGJfW5LlgKwLCNSP+1ouCHexEZkNHaLVYJyjnSR4CgdN8v2wimpamiY6EU94XJRcoWJjB+so2P1kBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFe5s0t/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFe5s0t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A575C116C6;
	Tue,  6 Jan 2026 17:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721596;
	bh=J4QeRzuXO3Vwn9QO+opyhfZPGybutp7jYZ3s3cR8tyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFe5s0t/v1Iydk/7b7y6Y8TEy3iofBHdNwuP9goDw1tMvPOR9YAM3+BJh10URpTA7
	 tQjtHCvd9H8g6AA/LIgGl1OHR9AQCO89Z7F+QzGdabzfiP/ln3aaBTZ+ionkJ1peDV
	 S6ayFIlRJKs1FqzZyYj5qYblCrJdaOVgf8FYZ1AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Liang Jie <liangjie@lixiang.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/312] sched_ext: fix uninitialized ret on alloc_percpu() failure
Date: Tue,  6 Jan 2026 18:01:30 +0100
Message-ID: <20260106170548.441766288@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit b0101ccb5b4641885f30fecc352ef891ed06e083 ]

Smatch reported:

  kernel/sched/ext.c:5332 scx_alloc_and_add_sched() warn: passing zero to 'ERR_PTR'

In scx_alloc_and_add_sched(), the alloc_percpu() failure path jumps to
err_free_gdsqs without initializing @ret. That can lead to returning
ERR_PTR(0), which violates the ERR_PTR() convention and confuses
callers.

Set @ret to -ENOMEM before jumping to the error path when
alloc_percpu() fails.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202512141601.yAXDAeA9-lkp@intel.com/
Reported-by: Dan Carpenter <error27@gmail.com>
Fixes: c201ea1578d3 ("sched_ext: Move event_stats_cpu into scx_sched")
Signed-off-by: Liang Jie <liangjie@lixiang.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 6139263afd59..31eda2a56920 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4508,8 +4508,10 @@ static struct scx_sched *scx_alloc_and_add_sched(struct sched_ext_ops *ops)
 	}
 
 	sch->pcpu = alloc_percpu(struct scx_sched_pcpu);
-	if (!sch->pcpu)
+	if (!sch->pcpu) {
+		ret = -ENOMEM;
 		goto err_free_gdsqs;
+	}
 
 	sch->helper = kthread_run_worker(0, "sched_ext_helper");
 	if (IS_ERR(sch->helper)) {
-- 
2.51.0



