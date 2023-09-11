Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27431170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E6BC433C8;
	Mon, 11 Sep 2023 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442164;
	bh=j48/7V109Oydh+Ylt7bvBP6LoodQAulAUDUMaZS5zb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyPceyYSK79zUOSHRKcNwykm9jr+P5yEqFJ9lk5Xu4irq0XRhKRX1J/8YOyH1WAoc
	 zx511wD55aDNAmpwcSNj0u0zuPsTgwD7xI531yT2Jx75YMiMnqDB6t07n4xh3+WAn+
	 N105TiG0i0KkP/HypZY9iwxL9RtUz29/vGc6t6Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Dhruva Gole <d-gole@ti.com>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.5 641/739] PM / devfreq: Fix leak in devfreq_dev_release()
Date: Mon, 11 Sep 2023 15:47:20 +0200
Message-ID: <20230911134708.998801908@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -763,6 +763,7 @@ static void devfreq_dev_release(struct d
 		dev_pm_opp_put_opp_table(devfreq->opp_table);
 
 	mutex_destroy(&devfreq->lock);
+	srcu_cleanup_notifier_head(&devfreq->transition_notifier_list);
 	kfree(devfreq);
 }
 


