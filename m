Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAA2368D66;
	Sat, 12 Sep 2026 11:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213832; cv=none; b=tJLA0wo6d4FuzUSqs7JW8pfcxH0JY7W1yG93Bg9uuneZi/wPvoohW43p9/Nm3EtZaEgpAWpuHVsluLm0gR7h9l6eKtt+UZx/OoeAWco/+QRhdp5TtLX0U6Bk7fkM/OLUIghCMCyPEEdzM96jQ5eQD46s+ZQjrjqEX6LXZ3vQhog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213832; c=relaxed/simple;
	bh=Z4e3GtnLps+bYIoTe4tBdltJA0Cq6eCfKNrQbelK4hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ua9e5Uf4wfr4FAl/CEI1QjmrppN7iElceoBEar/DdqzmxPr06t0mYGaLASWrIVUxTnMlI9qEG/QzDmroQ1+gnMsPE6qpV9JliMBSuTkZzu0G6qFffIuCU8x+v5FeYD95S0vJYm6bFZGoW5VUSaJsJpc/1yEwx8MCup2ZoAS2+Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWv3Oxmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWv3Oxmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCE61F000FF;
	Sat, 12 Sep 2026 11:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213831;
	bh=kqgw6HS2/CT5wbw1cuvAbp2UbOLaa+C7d9DRwTSs7Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWv3OxmcA4tQkYXs1LTaopVZcjhBN/FdOazRS+DI+i2/OvF3UIyw+sg8YG09eN89Q
	 aP3Gm98xs7m33wS8+AoHRAUvgLOLyv1AdTfs2iUC1Qr1uquO7C/X88yHp/dK6Cb8PF
	 vIJuh6/4JcGwYF36z9B7Hi0mgY5umxPLBRHcYiFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0185/1376] media: cec: Serialize exclusive follower delivery
Date: Sat, 12 Sep 2026 08:43:31 +0200
Message-ID: <20260912065611.674724246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2209,9 +2209,13 @@ static int cec_receive_notify(struct cec
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
 
@@ -2224,10 +2228,12 @@ skip_processing:
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
 


