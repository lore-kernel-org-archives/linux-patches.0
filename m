Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D29839847;
	Tue,  2 Jul 2024 17:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940792; cv=none; b=jMTnpngTiCfhx6ajmhFVqcLkNrLdJc+NAKz92EtrYfQ6PH5lFqQk24TQL6F9f1GIJktVna+EIMVgIjERMRavY1tjup4WGsfueqnS0VWlFP4RRmavMUp8CkenkbUD53+69RN3UcUe2hdhKrOyyw2d6ie6wARY25nqjtoWu4x27dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940792; c=relaxed/simple;
	bh=XKyXLIWbb85t9sofe3fTnKAdikZmHsDOJoDafk4bOIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/xAQFA9rq7ZzcmK1in5jgGNB2FEUWp+46jcgKWTsXSDIQlSR/8CktSPgrXDIoKzS6/Zos8FrlmXGAFYvNdo4wJpsBW0lSHZ0cjJoFeAwKPBZuaSFmFiquCbEVp2yCIOubdRkPaae06fMtWK6Cb/ho9tNXsgrfaJxlenWObXzbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2li0iUjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2li0iUjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15643C116B1;
	Tue,  2 Jul 2024 17:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940792;
	bh=XKyXLIWbb85t9sofe3fTnKAdikZmHsDOJoDafk4bOIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2li0iUjEc8eAmANcj68rkbfZn2XNOdl8KOAfHMRFIaLgaXWRvngLlqJA8Mp7OGUks
	 lKP/SF8zDc2ej6jjnoV/1QYG//vpO6pF72PQsP/M4hT3UXtwrAWFCCOC/6fRW9HBC9
	 DYkA7NB5eLhyxTjRKSbZndqicBxFV6WlWPgpExVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/163] pinctrl: fix deadlock in create_pinctrl() when handling -EPROBE_DEFER
Date: Tue,  2 Jul 2024 19:02:01 +0200
Message-ID: <20240702170233.330757582@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index 9e7b3e6c79cb1..e19ee66e027bb 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1098,8 +1098,8 @@ static struct pinctrl *create_pinctrl(struct device *dev,
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



