Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7703917B411;
	Wed,  3 Jul 2024 11:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005980; cv=none; b=BPFQhIieEn93MQ/IXhRkWzGH6mY7EGjgnEHvEG+la878cFhh4S4QO3DE8ceMLeCxXcbKT6B8iOd5e0FPMlthOqxafNT5zwoiKbto7BjuE6ZoI16LM5masNP5AByrjOYDO20L3J6BnwPZQLJwokwvIgmkcJCoKP3MwpouB4Jfb2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005980; c=relaxed/simple;
	bh=QlsgLWm4bnaAzIEf/oyAOtgVzMSxixnQPeXrZUG9rrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWk2s+kW1ThL1tk7xXjhZL9rSJs8sYaKOtjW77arAxoshRMihvUj5PTRrvnLrT67sSMKh4AhAivS+t3lPz4IHc4IbVnO9jzl1Ky4z4WA3o/2LVj0GKpLVEFLQZa+aJ3nLzUEtBK8nQJDN33nGl3OGIPWGfz3ETXH5GSUxhBGh4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qb0vBVsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qb0vBVsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022BDC32781;
	Wed,  3 Jul 2024 11:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005980;
	bh=QlsgLWm4bnaAzIEf/oyAOtgVzMSxixnQPeXrZUG9rrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qb0vBVswSzO2okctybG7TIIukfYVYrD6sq2a2AXJDOJrn4Wa6Hkt9k+wcEwKVWTND
	 I4DT9/A8u3YevTNj6vOzt1dln/mWEn3LBEir5UyWiLFcBLWUN/taqnT3NtLwMbnySn
	 4N+7tY5wO1cnMfH+9G+7Pkr9JtuQfOlk9PypIRPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/356] pinctrl: fix deadlock in create_pinctrl() when handling -EPROBE_DEFER
Date: Wed,  3 Jul 2024 12:39:57 +0200
Message-ID: <20240703102922.991086015@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hagar Hemdan <hagarhem@amazon.com>

[ Upstream commit adec57ff8e66aee632f3dd1f93787c13d112b7a1 ]

In create_pinctrl(), pinctrl_maps_mutex is acquired before calling
add_setting(). If add_setting() returns -EPROBE_DEFER, create_pinctrl()
calls pinctrl_free(). However, pinctrl_free() attempts to acquire
pinctrl_maps_mutex, which is already held by create_pinctrl(), leading to
a potential deadlock.

This patch resolves the issue by releasing pinctrl_maps_mutex before
calling pinctrl_free(), preventing the deadlock.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 42fed7ba44e4 ("pinctrl: move subsystem mutex to pinctrl_dev struct")
Suggested-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Link: https://lore.kernel.org/r/20240604085838.3344-1-hagarhem@amazon.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 46a06067e9947..f567805cbde8e 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1092,8 +1092,8 @@ static struct pinctrl *create_pinctrl(struct device *dev,
 		 * an -EPROBE_DEFER later, as that is the worst case.
 		 */
 		if (ret == -EPROBE_DEFER) {
-			pinctrl_free(p, false);
 			mutex_unlock(&pinctrl_maps_mutex);
+			pinctrl_free(p, false);
 			return ERR_PTR(ret);
 		}
 	}
-- 
2.43.0



