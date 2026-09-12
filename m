Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302952FF672;
	Sat, 12 Sep 2026 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221954; cv=none; b=XeDk0u3jLQn34oVe33jAz1JpdboksqaGNwKtmEN7Pu2s2APB2OauOS4L/itvalxmh1Vm1P9v8MmOO6dDB3cW/iJvC/w6m43h8NI37At46b3aT8enh7l22SsU9phIU00KRrEQBN4F1zbnAsnOuRj05kDUxXB2dhnYQac7E8Ls7VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221954; c=relaxed/simple;
	bh=2eBZ6cg46mR0a1aRO/FWXJhaJ858vhrIdpzUCWqWKAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ie0+N+cVah5SSJNsXJ3FqpDqqfa31PmWe9iq95KoYTJU1DXvjkZEWJ07KkjMswBsQOnjBxKwQ4ztDAoZHYeLdYPJrk9/hNkTBpEjOtbnpJdac+Af4fLo3ST9kwPGsCmcEnBabDUVrgWA5IdoWHynxLyKC2AJLB0+HRC3Bs/Alcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR+G8f1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR+G8f1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337E81F000FF;
	Sat, 12 Sep 2026 14:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221953;
	bh=2BBqHc5/ZRxf5DM8/T3oRvEmc95/8j5RZ6jREK4HzLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QR+G8f1FXVk2dkb9onPIgbgU6SQq1XwAky0u69Tb1lkqPX8pcUD79rqHEp0ay4Mj1
	 LY+cfYVCDrYcm24Kx+5g8fBpJQ3WPhjRPgC8h0EMmeVEDI1jIVhgWlnlhzjAu5rv+h
	 ZdazJYZuuv64oY5LRKxZY08TVJoYM1FMBpizcTAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0444/1424] media: cec: Serialize exclusive follower delivery
Date: Sat, 12 Sep 2026 08:47:56 +0200
Message-ID: <20260912065617.228479896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2155,9 +2155,13 @@ static int cec_receive_notify(struct cec
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
 
@@ -2170,10 +2174,12 @@ skip_processing:
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
 


