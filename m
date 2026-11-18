Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021244;
	b=1GghM46KTpYsLALVHCtK/ayMujHGfvNvN8ZaeZyihI2lQi6OEb89n5Y4Vx65GPcmSBWp
	 A7GQ/XyvzqeLvHV+YeWIvgwUoRNeR9kJUpmwwKTpc2Qk/9lRwuSX8E0TiMQw7jVxb/3Pn
	 WqN7UEI3ELiu6e6/+DTopXjUD+h8D1pqoNixIxslBQCkz+MD4HJ3ClD25T7c+FJMbNubA
	 KBjr+j4DzGfGffh5WzCcJegUsJ8Yy2ySdNJaBWTeUTdIPJ5b4cx4zdr3TAYQeuCH4TX5z
	 WyCdPD9NQmGvA4FoUeeUglkxVPz2JM6+AU5V5M/9EK1eFyf1wClWhiscjumJNV/vGAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6fiYI4a5jWtJbJBX9A9eB7JB9NeOCqdMFa3Yx3+yX0s=;
	b=3SlVB/RyDlFoEnlbECdEtImwwtmJQL8xEZkGR8HxO+BZbWlpilqttEE9pG0kJN265WgF
	 SLYWx3lm7jit23Ns3PyWtOglcL2cijqF/tepivTBe3vfIlH7lputePQxx6mbT4TDoF7xB
	 S+beYOZBV7HD6bnM1O87W/QPm958mt607mhheX84uZphtFkOEGEAmq439YoGRpCU4maf6
	 QGIth+sV6U0Wk0BP32M7oaPFCcEgUvuPPMkpUh9uVeR0PX6W49zkgYrLVLkxhIbQgI/Y/
	 u+n1cBJcpxvgKFTFgL8Xy51JGhiRcGiv4Uei7jjgkuKVpyg7xTAAWTcMsDFA6uygqZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVH4RtBu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F28606A333;
	Wed, 18 Nov 2026 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVH4RtBu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268C81F000C4;
	Wed, 18 Nov 2026 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021244;
	bh=6fiYI4a5jWtJbJBX9A9eB7JB9NeOCqdMFa3Yx3+yX0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVH4RtBubL3D6SvFNgxmgg4bBbTPkI6axYoG8ueZFlTTkdWrj6UOCWwjVwK5lSPcc
	 w2Fa3iox6mEoiNg4iEJB36C0yeIBvs2jYiVEmtck628g2kv5AgPpoQlvxVE0bpYmZy
	 gB5rgsza1jACS83HEjjio3brmBae+Rl2HXeDQsWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2239/2651] sched/mmcid: Fix affinity-triggered switch back to per-task mode
Date: Wed, 18 Nov 2026 15:57:59 +0100
Message-ID: <20261118150406.093673342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 7dbc307b6c72a5412e3f4e9fa2e0e926925fc5d6 ]

MM CID switches to per-CPU ownership when the number of users of an mm
exceeds the maximum number of CIDs. When the affinity union grows, the
per-CPU threshold is recalculated and the MM can switch back to per-task
ownership through deferred work.

mm_cid_calc_pcpu_thrs() incorrectly uses min(nr_cpus_allowed, users) to
calculate that switch-back threshold.  This makes pcpu_thrs no larger than
users, so the users < pcpu_thrs check in mm_update_cpus_allowed() can never
succeed.

For example, with three users restricted to two CPUs, the MM enters per-CPU
mode. On an eight-CPU system, widening the affinity union to all eight CPUs
should produce a threshold of four, but the old calculation produces three
and returns early. The MM therefore remains in per-CPU mode even though the
widened CPU set makes per-task ownership preferable.

Calculate pcpu_thrs from nr_cpus_allowed directly. The users bound in
__mm_update_max_cids() still controls when per-CPU mode is entered, so this
does not change the threshold calculated when switching from per-task to
per-CPU ownership.

Tested with an x86_64 QEMU reproducer using three users, an initial two-CPU
affinity, and an eight-CPU affinity expansion. The baseline does not invoke
mm_cid_work_fn() after the affinity expansion. The fixed kernel invokes the
deferred work once and completes the switch back to per-task mode.

Fixes: fbd0e71dc370 ("sched/mmcid: Provide CID ownership mode fixup functions")
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260915155953.2856524-1-sh_def@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 025ed33aa5600..0ba69c11a3f52 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10864,11 +10864,10 @@ static void __mm_update_max_cids(struct mm_mm_cid *mc)
 
 static inline unsigned int mm_cid_calc_pcpu_thrs(struct mm_mm_cid *mc)
 {
-	unsigned int opt_cids;
+	unsigned int nr_cpus = mc->nr_cpus_allowed;
 
-	opt_cids = min(mc->nr_cpus_allowed, mc->users);
 	/* Has to be at least 1 because 0 indicates PCPU mode off */
-	return max(min(opt_cids - opt_cids / 4, num_possible_cpus() / 2), 1);
+	return max(min(nr_cpus - nr_cpus / 4, num_possible_cpus() / 2), 1);
 }
 
 static bool mm_update_max_cids(struct mm_struct *mm)
-- 
2.53.0



