Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F0553B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D791FC433CA;
	Sun, 17 Sep 2023 19:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979308;
	bh=31TavuVgCmN9+4Z2Wkw5QCzzaBEHmH6luXnw23yOHAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EF0wz6BKeJ+SP4WYKL3WbxX25ZNLuHcloBoRdH/PtFr3gEi7RQ72sRGtYWuM8bafq
	 5tVIuo2BUydKk8WOXkMFr3QAWmhRHe//SwhXgiiyF7WGtg136CHOlOrra+deE1rRaE
	 SZSs2D26gm1nmWJBV/bW3xQAJ05csfROzGUwl4uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Dhruva Gole <d-gole@ti.com>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.10 274/406] PM / devfreq: Fix leak in devfreq_dev_release()
Date: Sun, 17 Sep 2023 21:12:08 +0200
Message-ID: <20230917191108.501360715@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 5693d077595de721f9ddbf9d37f40e5409707dfe upstream.

srcu_init_notifier_head() allocates resources that need to be released
with a srcu_cleanup_notifier_head() call.

Reported by kmemleak.

Fixes: 0fe3a66410a3 ("PM / devfreq: Add new DEVFREQ_TRANSITION_NOTIFIER notifier")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/devfreq/devfreq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -732,6 +732,7 @@ static void devfreq_dev_release(struct d
 		devfreq->profile->exit(devfreq->dev.parent);
 
 	mutex_destroy(&devfreq->lock);
+	srcu_cleanup_notifier_head(&devfreq->transition_notifier_list);
 	kfree(devfreq);
 }
 


