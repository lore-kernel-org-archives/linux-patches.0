Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1738E262BE;
	Mon, 27 May 2024 19:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838186; cv=none; b=lcNrpV41U8zwPdAKuARIKVlregpccovEmC7E7NwY5l8R4G0n4MqUuC+hQOSZo7mJREpavZH7VTupFdJ95GKO+5YgT6G7OwUk6aTpv1upvgufyjs93LZ1kRf6DfHNAqFZ2fna7Z9BMkSby/aR0J5cM+jDWpNpP3e8fCTzfSEN+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838186; c=relaxed/simple;
	bh=d9jnZm61igChmA3pdKAfmG9qgkOz+P9McELYtcnOwlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhTCLBOcxwPVuoy4WNJ+rYtPHp7sWCaBb4GZVFHSJLDFJ8lQ9DNZ8UbTfjed73BSwqv/wL4kjfSPd5M4Ihj1IplJiL0VjyHWbBd9uu2AJ97qn33A6pD8WVk1OnOMT5TqqmbL7hZNEZAJRIz2UXFoj1wYPrhvgnfkzAbEOxz1GMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxEV8KrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxEV8KrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D03C2BBFC;
	Mon, 27 May 2024 19:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838185;
	bh=d9jnZm61igChmA3pdKAfmG9qgkOz+P9McELYtcnOwlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxEV8KrUtUhiJIw7Gbz6WOozqzjDpTgJBq5UKZquSmi+Ff1/2GXFGE+y3z6+lLxb0
	 4gycCL8+Tguvd5voHvWTq58DHDq+160wpjKCqTovhFNVl7dZx7JC7E1hvxlh/Ov6Pk
	 Pwa/461f785aY5ck6uV/+1jiqwfUT+6yuGIbHK5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Colledge <joel.colledge@linbit.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 298/493] dm-delay: fix hung task introduced by kthread mode
Date: Mon, 27 May 2024 20:55:00 +0200
Message-ID: <20240527185640.052240267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Colledge <joel.colledge@linbit.com>

[ Upstream commit d14646f23300a5fc85be867bafdc0702c2002789 ]

If the worker thread is not woken due to a bio, then it is not woken at
all. This causes the hung task check to trigger. This occurs, for
instance, when no bios are submitted. Also when a delay of 0 is
configured, delay_bio() returns without waking the worker.

Prevent the hung task check from triggering by creating the thread with
kthread_run() instead of using kthread_create() directly.

Fixes: 70bbeb29fab0 ("dm delay: for short delays, use kthread instead of timers and wq")
Signed-off-by: Joel Colledge <joel.colledge@linbit.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-delay.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index eec0daa4b227a..4ba12d5369949 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -269,8 +269,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		 * In case of small requested delays, use kthread instead of
 		 * timers and workqueue to achieve better latency.
 		 */
-		dc->worker = kthread_create(&flush_worker_fn, dc,
-					    "dm-delay-flush-worker");
+		dc->worker = kthread_run(&flush_worker_fn, dc, "dm-delay-flush-worker");
 		if (IS_ERR(dc->worker)) {
 			ret = PTR_ERR(dc->worker);
 			dc->worker = NULL;
-- 
2.43.0



