Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E35D1F76C9;
	Tue,  3 Dec 2024 15:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240318; cv=none; b=YUa9iR0Ix5b2AvFrm/bVSTGB8YgP+QND5M5QeWepJ3QnjhFaqA1Abq8ll2JtqrGsY9SfozcuzNEPVZzsJH07O1CcSGr45jOYJapsL9GkzKY2kpUkhnWmsf9Dt1FeWCGRkTDZ+o2Zt46wozunWSuRx5Fov3F4agO4IcBA1p/rWHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240318; c=relaxed/simple;
	bh=0m7ZTfkiLfmOL0Vw/1+UNCJJmj4Jv4KTwXoXkICWgEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHSlxdjZ74yHWTnLacRSEajeDmSqHh8C6fhd0e9/SN+kmtruDJZCMXtOZOQweEDvCzXmkxccpm5f9wxnjX7kl9qjApJzoNSqBzw9SrHkFjhnmM3bBqWYIIlK7KOJYzGDEHPHU0FtfmoS/ij5mzu+EL9qoXWXprvs+aCApt9A6IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qq1rI4fe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qq1rI4fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9C0C4CECF;
	Tue,  3 Dec 2024 15:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240318;
	bh=0m7ZTfkiLfmOL0Vw/1+UNCJJmj4Jv4KTwXoXkICWgEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qq1rI4fehfL5FhtvER69EgqV8DsUpENCV5mu2tL9/b+PlxNzWSdEo5NzHQ7uIb5or
	 yYzTD6TbCBa49ZdR4Lv6JaKXfPw4QlTxn1iopQt8yqPf1Qlt2a3eWzLH+SKnNiZM2c
	 jIB/6rC5gaJDuvQRALWB+cJQoqsZ2Sh0IkwlIVVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/826] clocksource/drivers/timer-ti-dm: Fix child node refcount handling
Date: Tue,  3 Dec 2024 15:37:04 +0100
Message-ID: <20241203144747.515928414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit e5cfc0989d9a2849c51c720a16b90b2c061a1aeb ]

of_find_compatible_node() increments the node's refcount, and it must be
decremented again with a call to of_node_put() when the pointer is no
longer required to avoid leaking the resource.

Instead of adding the missing calls to of_node_put() in all execution
paths, use the cleanup attribute for 'arm_timer' by means of the
__free() macro, which automatically calls of_node_put() when the
variable goes out of scope.

Fixes: 25de4ce5ed02 ("clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241031-timer-ti-dm-systimer-of_node_put-v3-1-063ee822b73a@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm-systimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index c2dcd8d68e458..d1c144d6f328c 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -686,9 +686,9 @@ subsys_initcall(dmtimer_percpu_timer_startup);
 
 static int __init dmtimer_percpu_quirk_init(struct device_node *np, u32 pa)
 {
-	struct device_node *arm_timer;
+	struct device_node *arm_timer __free(device_node) =
+		of_find_compatible_node(NULL, NULL, "arm,armv7-timer");
 
-	arm_timer = of_find_compatible_node(NULL, NULL, "arm,armv7-timer");
 	if (of_device_is_available(arm_timer)) {
 		pr_warn_once("ARM architected timer wrap issue i940 detected\n");
 		return 0;
-- 
2.43.0



