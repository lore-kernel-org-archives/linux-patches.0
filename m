Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAB54E4C4D;
	Thu, 17 Sep 2026 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659008; cv=none; b=hzHdvcgUngqfQZPZMPO+/b5j1vON6IvjsHt8oAZ3cyZ7TwgagGyEA2VK1+/ihqfQ0ZQEU0rtGfEPyo01YCzNbSk6Fnx8aMUnN4JEUdC7PD8x4q5W+n9bmPv4JqZ/vdofBV4XTzgfcTSYJs1JM2T8P+9V16b2vXkWza3O7Sn7cWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659008; c=relaxed/simple;
	bh=7GvBC2SsmG78lS7mdUwTVHGkQMJT/Oj+d4Pi61O8j4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUkOpZ9JUYeZ94GYcCTkxyBOpDe7eK7Bkx5JCL1QZ05PFdvxQHs2oJY0akJcUZoWOhL+Bz2x9N5KvvAxLHX9ffgoPpFV2LO3cnvdsxkBGLkfRsOmUDmbkPY5+Z54V0hGlCxh3wTGCBgBJMeudWL04ix0p8GKb2d7fApWZ1kBLbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GANViMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GANViMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62101F0089C;
	Thu, 17 Sep 2026 15:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658998;
	bh=QG7SzJ+YIrNsW9Kv5f5yYjYrIKR04O45ffg/VKQyU5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GANViMBz7H4SNj9O9J9ewl1DeLQynrdCVe+DfUyolZFyE9+YktRfk4z4HCj1o6Vy
	 /Zrg6C3VuioPe8Av0QgrQ/JPA1clvslocqRJt3Rd6T19xQxHN6BDZjUmJtFA+wIkr9
	 JmWKW1wVAhghedHgQXv6VuSsX2NgphgSreEvS1RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Xu <stitch@zju.edu.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 108/733] workqueue: reject watchdog thresholds that overflow jiffies
Date: Thu, 17 Sep 2026 16:06:56 +0100
Message-ID: <20260917151353.667053158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 929c04a9581bd..36aaeb38e2174 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7923,6 +7923,9 @@ static int wq_watchdog_param_set_thresh(const char *val,
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



