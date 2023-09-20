Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A797B156E5
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FB1C433CC;
	Wed, 20 Sep 2023 12:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213411;
	bh=2bs2NHmta7Mxx+Fc2/ELAiPdc4PJO6KXWo5vx6NoczY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFbdL/i9UuPud+5g5QktXYeiLXNzz8quT2k/Z0g/4Z/6Umrh+HaL0QsU7kIpvlFBc
	 6KIVh/zh3rPPWw2EfzEAJdBpTMp8Rx1bQVI4ZOO2H/87wu6g1aUsZWvtQjw3LdyQRM
	 0DYvqiVFd9fsy6goSX/h2X7/jNuOeBtv/bIvGiak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Dhruva Gole <d-gole@ti.com>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.4 210/367] PM / devfreq: Fix leak in devfreq_dev_release()
Date: Wed, 20 Sep 2023 13:29:47 +0200
Message-ID: <20230920112904.045745879@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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
@@ -595,6 +595,7 @@ static void devfreq_dev_release(struct d
 		devfreq->profile->exit(devfreq->dev.parent);
 
 	mutex_destroy(&devfreq->lock);
+	srcu_cleanup_notifier_head(&devfreq->transition_notifier_list);
 	kfree(devfreq);
 }
 


