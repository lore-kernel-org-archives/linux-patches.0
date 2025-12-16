Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31C03451DB;
	Tue, 16 Dec 2025 11:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886279; cv=none; b=p/AxOh05eO5NqIxsZL9+A8BaoLrpsEMxd6EZe1FkZSo/LUcVMG8IDGDlV4wbhJR7dw3yCgkKtom6MMuLo0SAxzjxL1ckFzOn01NcjarR0ZNt5kL3ivejua+mZfXLoL2noFeCnqU4i486QfQHDc88WnzDu+SW9C6JzFTl8eXF0as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886279; c=relaxed/simple;
	bh=BgqUDm6cFOTAimTqgJmCLeCVGPgSWY+1GTSpGKQrJD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5gxQfgsOMmaQQ+NOoIKtPGY8PeGGVRybjkfvV03fIiUG8elxaKa6cSA6bLJkKrHYxEWj8CGOMBNUEvp9ZUfkndpHROo+tgmYJqsWYCb1OhkUHhIyxj7TGbBRaxHVRxlpt0W+RcZ640YsxGQMfFja9VzNaYFdViApksV0YnLhxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeqwnKY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeqwnKY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522E7C4CEF1;
	Tue, 16 Dec 2025 11:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886278;
	bh=BgqUDm6cFOTAimTqgJmCLeCVGPgSWY+1GTSpGKQrJD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeqwnKY5G/SdOJFsmWqrqDoHVDc3jQknVOuwE+f2p3/cVBkuYeoGQLEIioeOdKgg4
	 256K/yjOaJBbKzsf/hUf7As6R6Rd523bIIR6L00+p7N0sf5cKSvJ/8V0VXFDnC/yQr
	 ZMfy6IJG3OXTqZH1xhoosKHo9Zy9cJSQ5/di8MZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 357/507] clocksource/drivers/stm: Fix double deregistration on probe failure
Date: Tue, 16 Dec 2025 12:13:18 +0100
Message-ID: <20251216111358.389555775@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6b38a8b31e2c5c2c3fd5f9848850788c190f216d ]

The purpose of the devm_add_action_or_reset() helper is to call the
action function in case adding an action ever fails so drop the clock
source deregistration from the error path to avoid deregistering twice.

Fixes: cec32ac75827 ("clocksource/drivers/nxp-timer: Add the System Timer Module for the s32gx platforms")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20251017055039.7307-1-johan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-nxp-stm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-nxp-stm.c b/drivers/clocksource/timer-nxp-stm.c
index d7ccf90017298..8bca183abe8f2 100644
--- a/drivers/clocksource/timer-nxp-stm.c
+++ b/drivers/clocksource/timer-nxp-stm.c
@@ -207,10 +207,8 @@ static int __init nxp_stm_clocksource_init(struct device *dev, struct stm_timer
 		return ret;
 
 	ret = devm_add_action_or_reset(dev, devm_clocksource_unregister, stm_timer);
-	if (ret) {
-		clocksource_unregister(&stm_timer->cs);
+	if (ret)
 		return ret;
-	}
 
 	stm_sched_clock = stm_timer;
 
-- 
2.51.0



