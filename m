Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037A6382292;
	Sat, 12 Sep 2026 19:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242063; cv=none; b=YTySAh7c8esNiYCtoAgPERldnXYiczsRDwhfq5tsDFgHB8nUcL31FQzQHJjMgmMy0f8b+FFLuLM4HcHBt0obb8Bpr9A16uQ/2oAMIua8nSvByFWcpMRHtQ8uJxXl/C9sQpD6bHfo9JyNOX5lgpklksDVaSQsvqjTe6GJHoXX404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242063; c=relaxed/simple;
	bh=bN1hgWNfngB1YyWMbMCILE9dAZsEHXnK3S0ilG73rgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsWYqV8WQrmtGNfeWa6T5ZF6fxlHIrVjueqyY6Tf3tDs7z9BVcnx0h+LRLprfgewWBSDsL9QWUlUenl5hCg1yZVMuzUYlxV41F+wS4HJaDtpHdoOqGM0cuyBdxGhBrKCvwYrVBx6Sqxx7HRb4+bSGPBmY4XNoyp9iqOBYp8PN/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T21F9WMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T21F9WMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B111F000FF;
	Sat, 12 Sep 2026 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242061;
	bh=bMNm8p7tUK4p/r5xiOHSAeKO+Oq++KC8VgR+xoxRo+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T21F9WMriVYOXa+EMcsh1IqmoGwUuPcyn3NxE4PP1uhqqm4xBLh7HAaRfDVBmRDBQ
	 PIr2K5Js6k95U8duye3Dl9OWveLLMqeKBy1vyD232gxMXP9Pw/DU+JdF2espt7iFX6
	 Zszw4O9h1UjtKQ5Ab7TmfE05oDkx8WTvSU6/Lq8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 271/798] media: cec: Serialize exclusive follower delivery
Date: Sat, 12 Sep 2026 08:58:19 +0200
Message-ID: <20260912065523.368563089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

commit 1924d0788caa6c66fd320dd4704fae99487fd2c7 upstream.

cec_receive_notify() reads the exclusive follower pointer without the
adapter lock. Serialize the no-follower check and message delivery
against mode changes and release.

Fixes: 9881fe0ca187 ("[media] cec: add HDMI CEC framework (adapter)")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-adap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -2128,9 +2128,13 @@ static int cec_receive_notify(struct cec
 		 * Unprocessed messages are aborted if userspace isn't doing
 		 * any processing either.
 		 */
+		mutex_lock(&adap->lock);
 		if (!is_broadcast && !is_reply && !adap->follower_cnt &&
-		    !adap->cec_follower && msg->msg[1] != CEC_MSG_FEATURE_ABORT)
+		    !adap->cec_follower && msg->msg[1] != CEC_MSG_FEATURE_ABORT) {
+			mutex_unlock(&adap->lock);
 			return cec_feature_abort(adap, msg);
+		}
+		mutex_unlock(&adap->lock);
 		break;
 	}
 
@@ -2143,10 +2147,12 @@ skip_processing:
 	 * Send to the exclusive follower if there is one, otherwise send
 	 * to all followers.
 	 */
+	mutex_lock(&adap->lock);
 	if (adap->cec_follower)
 		cec_queue_msg_fh(adap->cec_follower, msg);
 	else
 		cec_queue_msg_followers(adap, msg);
+	mutex_unlock(&adap->lock);
 	return 0;
 }
 


