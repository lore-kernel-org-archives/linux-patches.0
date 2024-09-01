Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F531C68C;
	Sun,  1 Sep 2024 16:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208592; cv=none; b=T7V6bhTCbXErmKNP/KrDRTZFyD4b+X/2LZQigM2pmsK2I/HiHgfRf+GaiF/AFQUMpzSruMsjnhj9r3WUuzo1Hkwl0rHz9DkF0iMvjM3aetkGnGEg0IGQqewCTfEPs2vDL+B+3uMG+Es4cpDQtO4PHdT842e/34IuaeJb5L2Zgdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208592; c=relaxed/simple;
	bh=iCsNp11O8E9n3XSH3INrz9Dwz6b0MNELipy/NfU6USc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQ8gyDTIjfHzusMjjN68YHJCjStiAiowtyFAR0SHQM19QuwabzjuPYunFxND/gC5O7M1Gt0YQ0QDnmqV3HzQH2JAVwivC2e3jQFQur8xAZPPJkgWBgODiByQEC03TGPhAWTc4EtLVmu3nO1+yrywW8mJWwh/LBopJSustdQk4+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPNr0bxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPNr0bxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C19C4CEC3;
	Sun,  1 Sep 2024 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208592;
	bh=iCsNp11O8E9n3XSH3INrz9Dwz6b0MNELipy/NfU6USc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPNr0bxNsmliRNQSrB8C4oQ6MFKL3+qQFTfoVgy+uPPXfWf49EL7TFKPFtGkqUOnm
	 /qYF+J4ZeJYXQ6wPP3eVNVSu4fwsw+YYOlSajD2Hw5aAsSHhZVjBTzOwXmfJQv0gGX
	 2F5/ym0ytIBxYTErZY+erl4wLJ+jXLGV59SBFmls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 088/149] pktgen: use cpus_read_lock() in pg_net_init()
Date: Sun,  1 Sep 2024 18:16:39 +0200
Message-ID: <20240901160820.775794142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 979b581e4c69257acab1af415ddad6b2d78a2fa5 ]

I have seen the WARN_ON(smp_processor_id() != cpu) firing
in pktgen_thread_worker() during tests.

We must use cpus_read_lock()/cpus_read_unlock()
around the for_each_online_cpu(cpu) loop.

While we are at it use WARN_ON_ONCE() to avoid a possible syslog flood.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240821175339.1191779-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index ea55a758a475a..197a50ef8e2e1 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3654,7 +3654,7 @@ static int pktgen_thread_worker(void *arg)
 	struct pktgen_dev *pkt_dev = NULL;
 	int cpu = t->cpu;
 
-	WARN_ON(smp_processor_id() != cpu);
+	WARN_ON_ONCE(smp_processor_id() != cpu);
 
 	init_waitqueue_head(&t->queue);
 	complete(&t->start_done);
@@ -3989,6 +3989,7 @@ static int __net_init pg_net_init(struct net *net)
 		goto remove;
 	}
 
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
 		int err;
 
@@ -3997,6 +3998,7 @@ static int __net_init pg_net_init(struct net *net)
 			pr_warn("Cannot create thread for cpu %d (%d)\n",
 				   cpu, err);
 	}
+	cpus_read_unlock();
 
 	if (list_empty(&pn->pktgen_threads)) {
 		pr_err("Initialization failed for all threads\n");
-- 
2.43.0



