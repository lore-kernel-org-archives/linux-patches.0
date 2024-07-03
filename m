Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3601850A8;
	Wed,  3 Jul 2024 10:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004139; cv=none; b=p37WeQHqF/pKZalhLF3rTkXns8Y52Fbxx9cspdsQ8pDd7sDjVRSoOv2itjuXIBFuU2S65JQJhvIBFvjftGfN056zG2u1cULeYpKwzG3tofrKD3RCw7Vo05mK97SbVQcbQHVTfbw7ZZb/zrap/g++2H5kap9QnJ2L1a5IWc4WZGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004139; c=relaxed/simple;
	bh=PdRTEHXcamTO6gC5mMnfHI1v2T4bMaWLLR6UG9X0BYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjV+b6B+bwxJtA3hFqHqPhf3iJNiPWUpBtI1D2YDU+j848qHSEY3VjhzvayU3vyhFCUNXYEPgiaMi+4lRIgkZ6NsoQ6OBahv+P57sWt0+1xecCmKDU87WJ2JtQ1nJqCsnrdjB7WNwbihKp8wcAeM9kFfJsEeYLfrb5Dlmma+ndk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdvDtdf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdvDtdf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F23C2BD10;
	Wed,  3 Jul 2024 10:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004139;
	bh=PdRTEHXcamTO6gC5mMnfHI1v2T4bMaWLLR6UG9X0BYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdvDtdf7RvlqjiTGpK7VCkKfw7QfW7W7rLl7dsdEpf6DeQtowEePz3gHUVgkNXIQY
	 hr03K8GvNAwKAlua4ACAoTMWh6ogbn6k9l/aTJQDP5OWuqklYljlhgwX2dNGLoP/oU
	 1BXNNlGaTbebTaALw8c+QD+LVKFfmJOZoRYiVB98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/189] pinctrl: fix deadlock in create_pinctrl() when handling -EPROBE_DEFER
Date: Wed,  3 Jul 2024 12:39:55 +0200
Message-ID: <20240703102846.542333481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 44802e5017945..1d8324e220fcf 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1090,8 +1090,8 @@ static struct pinctrl *create_pinctrl(struct device *dev,
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



