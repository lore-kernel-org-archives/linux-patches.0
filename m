Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D77C79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883EEC433EF;
	Thu, 12 Jan 2023 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534005;
	bh=fJ+sT9wlDCZUKQrFX/kz9++CjBi0cQ//WVI+4TssWIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dznSCwgLYblRv3VUiXBZvGmCAQ8RWF0QXSP0koMNcZ9eYm/XwxCEBBGDoS5cLJwse
	 l9iXt8qFFPtM6vnZpMd6BCMK+6MgjafqqtiJIQK1XFYBadD29f04ttbIy2a7Z5Bn4g
	 oeouDbiIJPW1JF3DS9E8XChbH6+hwim8H/HJjsao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maria Yu <quic_aiquny@quicinc.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 662/783] remoteproc: core: Do pm_relax when in RPROC_OFFLINE state
Date: Thu, 12 Jan 2023 14:56:18 +0100
Message-Id: <20230112135555.032412975@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maria Yu <quic_aiquny@quicinc.com>

commit 11c7f9e3131ad14b27a957496088fa488b153a48 upstream.

Make sure that pm_relax() happens even when the remoteproc
is stopped before the crash handler work is scheduled.

Signed-off-by: Maria Yu <quic_aiquny@quicinc.com>
Cc: stable <stable@vger.kernel.org>
Fixes: a781e5aa5911 ("remoteproc: core: Prevent system suspend during remoteproc recovery")
Link: https://lore.kernel.org/r/20221206015957.2616-2-quic_aiquny@quicinc.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/remoteproc_core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1741,12 +1741,18 @@ static void rproc_crash_handler_work(str
 
 	mutex_lock(&rproc->lock);
 
-	if (rproc->state == RPROC_CRASHED || rproc->state == RPROC_OFFLINE) {
+	if (rproc->state == RPROC_CRASHED) {
 		/* handle only the first crash detected */
 		mutex_unlock(&rproc->lock);
 		return;
 	}
 
+	if (rproc->state == RPROC_OFFLINE) {
+		/* Don't recover if the remote processor was stopped */
+		mutex_unlock(&rproc->lock);
+		goto out;
+	}
+
 	rproc->state = RPROC_CRASHED;
 	dev_err(dev, "handling crash #%u in %s\n", ++rproc->crash_cnt,
 		rproc->name);
@@ -1756,6 +1762,7 @@ static void rproc_crash_handler_work(str
 	if (!rproc->recovery_disabled)
 		rproc_trigger_recovery(rproc);
 
+out:
 	pm_relax(rproc->dev.parent);
 }
 


