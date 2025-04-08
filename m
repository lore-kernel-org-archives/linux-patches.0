Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DE326A0AA;
	Tue,  8 Apr 2025 12:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114089; cv=none; b=Rdkh6nuvOEcfj64CGKzfMjKD7r8NenhTfO0RmvpWSGNzvv4G+KNcW6Dr3m/lQkn5aZmC2GhVTKxUSM6r+4mrrukzyxq1aqPbdw27LHzyersyKIar2Kru6wQbXrj52vXX927P6dtzJUxymJ2KyOPK1diec9myusJYGOlFPE3oIzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114089; c=relaxed/simple;
	bh=ESV4J9EUcV12vSkjQUPfCZ0Nb3wdkhzc8Zy+wAZJ1wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSadTPICVy0g9jU7T1bHD7HOy3oElB870isJeQ8g60P2YTPtinIpH2qkeGK4g5ZD2slq/hycioXwMc9GX2HML5iH3pjjF4RFTuKS/BZkOdhzZFgIoET4rvsOBRrx/TWYFfw9TLg2tLndcO+ytpXqa6vug3x4wFJJpTwO+o0YTSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2I2WLkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2I2WLkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC28C4CEE5;
	Tue,  8 Apr 2025 12:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114089;
	bh=ESV4J9EUcV12vSkjQUPfCZ0Nb3wdkhzc8Zy+wAZJ1wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2I2WLkmtso9PziNCfe+nWq0YspObZwvWpw9x3iZAKOLWQ+Ghcltxgs7jnMbaDZVz
	 40z5NnGnWWcIqf3mPNMoMLhxmd/YOVCOcsKJMz5egKsLexNK80qQLYAb7HX1WhsXEI
	 MmTreT+FGOzHZ30dhIPSh9bVY3V4HpioDKU7WmW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/154] sched/deadline: Use online cpus for validating runtime
Date: Tue,  8 Apr 2025 12:51:13 +0200
Message-ID: <20250408104819.544130752@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ba3d7c223999e..023d52d2a0f10 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2513,7 +2513,7 @@ int sched_dl_global_validate(void)
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



