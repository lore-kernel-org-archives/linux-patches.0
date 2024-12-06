Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A91149C69;
	Fri,  6 Dec 2024 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496914; cv=none; b=ccz/HVrRk9fsRVKXtTVgv45uRa9HuxQm2xbGDpspVfBoS9TcQjUEA2R/FCf7rWFJmY1WQngqVohSewuV0qvJoEkxIgw0CwmeMLqpAPDfkl/yrf/cwmFV6UQ0Elor5swCugrGpPlSeYPtbFEF1l29G1yg/JHYg0DXryONQj6LNvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496914; c=relaxed/simple;
	bh=knOJPnMh3Zz3FqeEDkqINw4fd2J4XRzgy0pSsxIPIbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCjEhVd0IdOoSXLMxK7wtOOjOC8oZGMnUrkDs46XWH8K0/OF/L5pjTgqJ0bMrVhs6FsK6z34yiUUKgB8l0ISfgzApK/4TPScUycJvGy0zuciPqfWT4+3cInDST1QxBrAX4CIRh0X6fSTmOTKIwN329kE5zdj44p4pP5Xv9xHOX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ewkksncs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ewkksncs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94A3C4CEE1;
	Fri,  6 Dec 2024 14:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496914;
	bh=knOJPnMh3Zz3FqeEDkqINw4fd2J4XRzgy0pSsxIPIbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwkksncsQqbdOjfBd6EtJFnh6vBk6cRb3uxxBOVJ3I+YiI3AO9XAiH9kaSYy9I8yX
	 8tKgTaJw6Spp+WYaFLyGzAQ6ka9jHO35YMWQm3wfK8CJOPsNkT9FliwYcaaXYCVSa0
	 i9dyUMnCBJ7htXLYNLUzefSsoPyNRIUDdMN3N4Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/676] clocksource/drivers/timer-ti-dm: Fix child node refcount handling
Date: Fri,  6 Dec 2024 15:28:50 +0100
Message-ID: <20241206143657.696025370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



