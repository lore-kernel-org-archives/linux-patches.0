Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C770B4DEC08;
	Thu, 17 Sep 2026 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665301; cv=none; b=RZjSWVzIjmVxeYUg4hj8nNzqTPU7I1v51v8tdp86MQRPyqg2YYlOy9/bBLcnTI+4r1L6l94RWgG/ap9WBZsCaqCcA+gF9fXQt0/UvY2ohGgQ83PwDagMn/5FsFNndI6jF8cPRysd0cdTTw3hOPpoevla20229CwGDLJtjc8z9jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665301; c=relaxed/simple;
	bh=inSjwIP2FyMl0KqL0Knb0UoTFDvAGqR8qqgWORnE+tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jETGks9nJH1RllmEfjSMRdYGSRXUz1aXoRJTwLYAgYljsHcoTec7QSqouCJAr5/dyg05ydwNkaDsUgnrYeRXaOcsXpBGw+/TvP9DskALSFOHPStMKIwn3Z0JWjQLHeq4t9d2Dg1g0MzVHigtNC1yPxPkPQ6QQP+S+nnIFEAwVRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyvS8NoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyvS8NoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5151F000FF;
	Thu, 17 Sep 2026 17:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665299;
	bh=0k27Zq2//JzYegjU30sHTuhVLXmZB7N0RHur4p2apgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyvS8NoKNGq9zRZ+rTE1zbc0dwwIBhmVQvxG32w4qTaghmDewDOpsU/oGGT1d2N6Q
	 9/Zn9V5vEkpDdoOKFOcxGgAX06nuxvpX6bG0S0Jv9rK1AeGGMGTg0rR9PY3v4UGfm1
	 a21ZxBdM3ZSb79mv811SwD4pLAXU3ioN5NzivKU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Xu <stitch@zju.edu.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0660/1250] workqueue: reject watchdog thresholds that overflow jiffies
Date: Thu, 17 Sep 2026 16:07:35 +0100
Message-ID: <20260917151609.781381353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 20c79180fbfa9..7f469a3c9c175 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7736,6 +7736,9 @@ static int wq_watchdog_param_set_thresh(const char *val,
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



