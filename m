Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BFC2931DF;
	Wed,  9 Sep 2026 14:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962618; cv=none; b=DqT7hpYY8yKyzONJI0NSOkS2ZALtjH+dPypwembr1IsMLk382FemJavA+aVXK/PcyeQj9SJnvrc6+vLmCk+m+PSRshf8UavTqNw9urA+YSk6VnadN9ByqfhAez1cZ6VknPPByAqVU2xDFKiNWO27AFAcsbODrB25QIeHk47UgXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962618; c=relaxed/simple;
	bh=jO3uOt746xx3UtpRsFAg0tOXRrGfBN/f158kY/Du4w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA1lb1Q3gza0yoRZL6BFouU/twl4VUljhdNO0jyordnelgWIl1s0t660Y9o/h0OcTSK9FYxxbGJey99hRx/mpNS3Fn81/t0Do5z5pGswMIWtFNpTY0MVqELEd0l6izMwpM7fd/5gCYZ4nk6MWDYOBUOxCYj2mp7Ns1n5wj3sKH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBMztNCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBMztNCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186451F00A3D;
	Wed,  9 Sep 2026 14:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962616;
	bh=SOGedqeJbPq1gDBH+2mZgRb7l5XF8Y3V0XkYk3OMOfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBMztNCazrHG1dg1ds1qX2/7hnUyeo39uZNrnFV37PEw4pSY5wIvse5+juUUXytWK
	 zqk2nkxQ4TYnptBpW8o4cMz4XIZ5VggRaJ+L1aM7bHrvUB3jwNSw7JcWzCfaur1C9W
	 g3kLeV2bOJBWVFAt98xSMKO2zKrmfr2AbOtvoQYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 353/556] media: cec: Serialize exclusive follower delivery
Date: Wed,  9 Sep 2026 15:40:33 +0200
Message-ID: <20260909134243.079222895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -2219,9 +2219,13 @@ static int cec_receive_notify(struct cec
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
 
@@ -2234,10 +2238,12 @@ skip_processing:
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
 


