Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69EB1D5ABA;
	Wed, 25 Feb 2026 01:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982862; cv=none; b=Yts9r+8WPuO2NLi+SNsHQnHVy3Om/kuXsuwm3Kw3u9we1a81XoZGzx1D+8BhCf+qXqU0OZLD2MerIjBFONq5ZZTqgv4ktD1s0tq5b0JSTkIWbdQS56HBQQC+jkbcvJMXg7tGVoSbKcZvMrz+5EvSI2OZq1QOnO9CQ4V88vTGNCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982862; c=relaxed/simple;
	bh=urMHUGQTnzeM73X8EWKrPpWVfznbliddg4Lo/aJFPcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=navRaC3MNYxTMW/5cRFJzOmYUGnxRDCXWIExUfCCNl0Vkjkl43+EoSXUAsoZI7KjpD3Fcc5UcuwnfGZKWh/alfT9AGRUrgqVWjYHipWjVL7X12I8oa4QRG3HEGyRkbfdBc2rHppQArvd26oXwxl0eWji20XJ8K88zKCFoie2Qic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUGwmut4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUGwmut4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B953C116D0;
	Wed, 25 Feb 2026 01:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982862;
	bh=urMHUGQTnzeM73X8EWKrPpWVfznbliddg4Lo/aJFPcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUGwmut4AQsj1cnbwXj/bWO8dhB/aPrtPTSwg3NMjwON9qIz8IE9RMljPDUAwv3Kh
	 nR3X6VmTOfPdu1epuVma/EIfYxT7wH3QYMp0gpaOl/eGhZBwmET6K8NR9hGuv6uw6t
	 HNvsXvuDABe00d9SqfqLeGQ0XD0rjEWc1UcP1gTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 049/781] md/md-llbitmap: fix percpu_ref not resurrected on suspend timeout
Date: Tue, 24 Feb 2026 17:12:38 -0800
Message-ID: <20260225012400.906676567@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit d119bd2e1643cc023210ff3c6f0657e4f914e71d ]

When llbitmap_suspend_timeout() times out waiting for percpu_ref to
become zero, it returns -ETIMEDOUT without resurrecting the percpu_ref.
The caller (md_llbitmap_daemon_fn) then continues to the next page
without calling llbitmap_resume(), leaving the percpu_ref in a killed
state permanently.

Fix this by resurrecting the percpu_ref before returning the error,
ensuring the page control structure remains usable for subsequent
operations.

Link: https://lore.kernel.org/linux-raid/20260123182623.3718551-3-yukuai@fnnas.com
Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-llbitmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 9c1ade19b7741..cd713a7dc2706 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -712,8 +712,10 @@ static int llbitmap_suspend_timeout(struct llbitmap *llbitmap, int page_idx)
 	percpu_ref_kill(&pctl->active);
 
 	if (!wait_event_timeout(pctl->wait, percpu_ref_is_zero(&pctl->active),
-			llbitmap->mddev->bitmap_info.daemon_sleep * HZ))
+			llbitmap->mddev->bitmap_info.daemon_sleep * HZ)) {
+		percpu_ref_resurrect(&pctl->active);
 		return -ETIMEDOUT;
+	}
 
 	return 0;
 }
-- 
2.51.0



