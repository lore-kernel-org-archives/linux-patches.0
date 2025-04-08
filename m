Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C7B2638B8;
	Tue,  8 Apr 2025 12:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115051; cv=none; b=YCEOG2K9Rk8omsqBjbj7vq0mq/N122zdrH3NL2YnJvskI4Y6i1ez8Z6f+oQ/W/uETlWGqPVjMs/AHutyxZLNdqk3ZLAX/AJmhisMewF1cFzjzkmN3jdOmNSI1Sb4YWTyfFd+w+FFnN8uJiqKTRsQ6FVZ4hBlq9mTRz0iNXBFe+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115051; c=relaxed/simple;
	bh=SdUReQwx8uwbLB8QEJUlCD93XGD1XpAZPTbIldlsq+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bC7WOgcCh7ZfFjh/Il2d0l8OINg0UCEfYwg/iUJq+2IblJNyczIHoaTbkfiqFIoN7YXsS6BNig0w7StA7Siynp99xtgg0qjCN6/4iVuWWpwa8VifreGVDwgi6rCHReiSKION7sc0Xdj9ZFFLgU9NwIhv4QyXk/Zafs7P5CFh+1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFAHMzqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFAHMzqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E4AC4CEE5;
	Tue,  8 Apr 2025 12:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115051;
	bh=SdUReQwx8uwbLB8QEJUlCD93XGD1XpAZPTbIldlsq+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFAHMzqtfTXRVVFBVBWAULYEbGBkirezybBO3uVnR+Dl+1kISyRO3co415nDblHMF
	 u0tZkFgWwlM7d77s1I3+vWp3U4ou5Xo+8hueNUQwbAjrG/372FmyOrgU0YS+icmefG
	 FgvHaRUu0DyCk1sqK+lQflBD7d5MDTWomptvb0F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 330/499] sched/deadline: Use online cpus for validating runtime
Date: Tue,  8 Apr 2025 12:49:02 +0200
Message-ID: <20250408104859.456009663@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index d94f2ed6d1f46..cae0df561aea8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3168,7 +3168,7 @@ int sched_dl_global_validate(void)
 	 * value smaller than the currently allocated bandwidth in
 	 * any of the root_domains.
 	 */
-	for_each_possible_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		rcu_read_lock_sched();
 
 		if (dl_bw_visited(cpu, gen))
-- 
2.39.5



