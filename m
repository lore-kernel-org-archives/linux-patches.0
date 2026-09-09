Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBDB3101A9;
	Wed,  9 Sep 2026 14:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964020; cv=none; b=P0euscI0cVx5Cz4aTYvCOUuQtUOtcyrFtst1/ofTM9PjD6eb4gN7EbGO3WTidc+XCF7nkYu3hfwEGamYe7dYPKgPgBmWLJLCP65IVbaZ7+s2kQw3MpIWQdU9G2aBkfzD+DJnUu1ACqU8QrectDzyuwL8aMQk+u/QIZlvlltNCFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964020; c=relaxed/simple;
	bh=GSOReHE5krdFeY+vWG8K22F35Uol9BUxTSj3sRPJZ/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXFqjh6RW5NEHEHjN/5xDYHorHYHbIUD7MbwoEEN+e4Pnkx/ea3nIDNYKX4RQ8rbx+yESdJRzONH0vvZWjHOhkGJ5v8YL96U8g4604tg7YBnsIV9+Gko3dn2DMhqhWkh31TeMxp8TBle0QNw6S/+glaZIkKQ9pp6nDuy44uM0PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1npRTTdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1npRTTdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71931F00A3A;
	Wed,  9 Sep 2026 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964019;
	bh=wM3Pex/rJkwnwWOWFDzp2i2SZ2h7O5SeuUn9LTZAmR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1npRTTdYbVxkbVkJ0ncQ22fsv/wBVuZMuuRe2luFAOihO5qmZifuByxiO1rQm8nVi
	 jOXPFsiFDXtsNy34pzBOhMKJi1mKsOkLv0Q3/n7AwRlliqFQpJBx1Op7+grBeZr6yt
	 XRuvVus/vtqjHTOEUNDt5puf1ROEDfr2reDBgPYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 280/583] media: cec: Serialize exclusive follower delivery
Date: Wed,  9 Sep 2026 15:39:25 +0200
Message-ID: <20260909134247.762717913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -2210,9 +2210,13 @@ static int cec_receive_notify(struct cec
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
 
@@ -2225,10 +2229,12 @@ skip_processing:
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
 


