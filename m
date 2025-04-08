Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0131B26A0FC;
	Tue,  8 Apr 2025 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110156; cv=none; b=SuVl2FgfDhZ77Z+7mSjDrjFvas1GwgXAYV1hfUzbJ+jOeD8DG0SXIWonH2foT4YxHhw5R8tERztLJd1lJFCsjmpIW0b4xo2xpSWSc27cY85sH6pszdrzPuMypQ+oS5E/XpL82kodPRyXow092qyFOeRauTjgEVTxeCJQY2Xd/dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110156; c=relaxed/simple;
	bh=MRUfpW10ffd5CfsNGE4SwQIYJ16i9EN2VK+2Pqjpf5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kokv7svtiiOagGmaE9uByR0FO7IfzYFo7QsPTGqQA4shBfvMx5dqwGiqU+pPf+G0GJOVxcpOFPBsFC5sS62AcyyjUubXFWuIQJF+0mpPEIR3tgonse1hcPZ2p+WkI6U4MosUOKt2BcbtrIee39h+C3WAoziNnWJ9Vb6KB3N0lBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c67XSLP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c67XSLP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858D1C4CEE5;
	Tue,  8 Apr 2025 11:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110155;
	bh=MRUfpW10ffd5CfsNGE4SwQIYJ16i9EN2VK+2Pqjpf5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c67XSLP99w45WGng0FcXOn6GxqQxc97k4ERt23Idqv5NJSWCjp4nYsClVhteIE8Og
	 tY5FIxVg26sLNnQHUoLnQnWjsKzJ2Avv8/Vgaifz0A2gho16rik/Jm+Uq8BPa66Yd6
	 r1ZwgzQYokHREnsCGJL7uCGyiT3Bn1ZFgc2F6YQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/227] sched/deadline: Use online cpus for validating runtime
Date: Tue,  8 Apr 2025 12:49:26 +0200
Message-ID: <20250408104825.943002322@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shrikanth Hegde <sshegde@linux.ibm.com>

[ Upstream commit 14672f059d83f591afb2ee1fff56858efe055e5a ]

The ftrace selftest reported a failure because writing -1 to
sched_rt_runtime_us returns -EBUSY. This happens when the possible
CPUs are different from active CPUs.

Active CPUs are part of one root domain, while remaining CPUs are part
of def_root_domain. Since active cpumask is being used, this results in
cpus=0 when a non active CPUs is used in the loop.

Fix it by looping over the online CPUs instead for validating the
bandwidth calculations.

Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20250306052954.452005-2-sshegde@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d91295d3059f7..6548bd90c5c3a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2577,7 +2577,7 @@ int sched_dl_global_validate(void)
 	 * cycling on root_domains... Discussion on different/better
 	 * solutions is welcome!
 	 */
-	for_each_possible_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		rcu_read_lock_sched();
 		dl_b = dl_bw_of(cpu);
 		cpus = dl_bw_cpus(cpu);
-- 
2.39.5



