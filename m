Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C363C3450;
	Wed, 30 Sep 2026 19:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795022; cv=none; b=CJtQHba/D2QgyxUtCAxc1xoDGKHpmfULvY1GiJj31A8W5vEa89WvcSMKMKTGCbrtcWq5x2IMI2Hic/70XVTlODwm6v3LPYbhisPiLY7J8tYUi96la96eUY0Q2W0816zemOOVglyuHP3znW03Fh76mrjkRFt70fvijtYxR8b9KwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795022; c=relaxed/simple;
	bh=0qdsu5hBQvGfKTsJmi9fCWFu2JVhxaFwiDZISApeBbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLJt4aIpHGbsB2LDyRos89l89l0G4gMuRjyy/JwJv8QuhaBojArMNckGdhyIwrkh1HuVPapLR7VzjcBMislYxmDZyvd6ugSW0oiQtrQZ/REEsu1CEylNiHSL+aBj3fe+W+tBLJJBdfGb5Nki9us6pGCv/XKpejM1FKvEf10JPxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjplqWT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjplqWT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A441F000FF;
	Wed, 30 Sep 2026 19:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795020;
	bh=S3qNjeNDdyEf/yL9IeYbPrMe/P5UXBUti6zEDbWVaI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjplqWT+Kt9QsVn0kAUAwDGL8ESLX2jraqOA/W06Kj/FBhYf4WXlPg9WIIHXGX7Wx
	 17wj8bZlZa1/7CtSl/3Vt2ptU6r3v6VPgyCcrILFDX/QPKxgncHvz5GoiIZZVyjdd1
	 pPpD/q0QZefck0LhpS9Oq4yE3UFT0YryGhNRMpgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Xu <stitch@zju.edu.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0413/1193] workqueue: reject watchdog thresholds that overflow jiffies
Date: Wed, 30 Sep 2026 17:18:17 +0200
Message-ID: <20260930152443.375122942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiacheng Xu <stitch@zju.edu.cn>

[ Upstream commit 068c35b5d0546c8625b3d7c61910f73775cf1216 ]

The watchdog threshold is supplied in seconds but is multiplied by HZ
before being used as a jiffies interval. Reject values that exceed
MAX_JIFFY_OFFSET / HZ so the multiplication cannot wrap and the
time_after() comparisons remain within their supported range.

The check is performed before changing the threshold or watchdog timer.
Zero remains the value used to disable the watchdog.

Fixes: 82607adcf9cdf ("workqueue: implement lockup detector")
Signed-off-by: Jiacheng Xu <stitch@zju.edu.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bb12f74fa190a..69cdb67eb10a4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6574,6 +6574,9 @@ static int wq_watchdog_param_set_thresh(const char *val,
 	if (ret)
 		return ret;
 
+	if (thresh > MAX_JIFFY_OFFSET / HZ)
+		return -ERANGE;
+
 	if (system_percpu_wq)
 		wq_watchdog_set_thresh(thresh);
 	else
-- 
2.53.0



