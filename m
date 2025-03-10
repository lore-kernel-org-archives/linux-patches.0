Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2539B17A2E8;
	Mon, 10 Mar 2025 18:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629739; cv=none; b=A5bkA8qusJsTIRXuIIMWT69k4KbUts2+c596XjFgDkbn3BnSA8xKjfRQ8dQq7aJizdWkXUjfApNXuGHUdHRXfnaHFnlO+20NGfFuA/rqVDlcHT08kgmd5lZ6kwOQx4hFMr+ny1Sw7EFb1MdWkX2nYtlilqI0SbTJ8DL4GxfAxic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629739; c=relaxed/simple;
	bh=xzbTxzI5ClxzWdDFXkgR3mZjExNgC+9F/Km81sEjLjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uigaOD+ZkDS1HQ9A/rKRnjMU3o/rCDF0JPckBLhZ2YuieBX/Sk+zMLcESN96tH80KG+cz8Z5i7QOoJogJe0GH0tP7LGm0p7vsiNlBx1wiQAaAW56iRRA/1VODibSGEBpyuAKrSqn4zw4kB/oi9fPBWOpe9Piz57v07IEI7IjwIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lf6/xAc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lf6/xAc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E58C4CEE5;
	Mon, 10 Mar 2025 18:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629739;
	bh=xzbTxzI5ClxzWdDFXkgR3mZjExNgC+9F/Km81sEjLjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lf6/xAc85tuKFZQtVfbPS2HZx5o44lGJ+vMh664GA7Sy1HbtomXnWNDPfAyou/tax
	 BM3hjOuTQIfboIbqrNuRBVk0QAmKXaIM2vi/7XN408Z+HuHWfLL0ajV620YUMujqmI
	 cMfyXrUHPFLw777jdUc1cahGQEdLjgR8ID0euwCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 389/620] clocksource: Replace cpumask_weight() with cpumask_empty()
Date: Mon, 10 Mar 2025 18:03:55 +0100
Message-ID: <20250310170600.951382918@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit 8afbcaf8690dac19ebf570a4e4fef9c59c75bf8e ]

clocksource_verify_percpu() calls cpumask_weight() to check if any bit of a
given cpumask is set.

This can be done more efficiently with cpumask_empty() because
cpumask_empty() stops traversing the cpumask as soon as it finds first set
bit, while cpumask_weight() counts all bits unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220210224933.379149-24-yury.norov@gmail.com
Stable-dep-of: 6bb05a33337b ("clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5aa8eec89e781..ee7e8d0dc182f 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -344,7 +344,7 @@ void clocksource_verify_percpu(struct clocksource *cs)
 	cpus_read_lock();
 	preempt_disable();
 	clocksource_verify_choose_cpus();
-	if (cpumask_weight(&cpus_chosen) == 0) {
+	if (cpumask_empty(&cpus_chosen)) {
 		preempt_enable();
 		cpus_read_unlock();
 		pr_warn("Not enough CPUs to check clocksource '%s'.\n", cs->name);
-- 
2.39.5



