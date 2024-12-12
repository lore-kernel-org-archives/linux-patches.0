Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9092153DD;
	Thu, 12 Dec 2024 17:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022971; cv=none; b=YbC2wE/S+4mLYguSkxZLgAWoisy7sK6wE5Mcn8AJVV5fLK8zfAtpZlJNqQmwMaRhOH+2qiT+lvjbisYWu1fh6Xc6FKl+HTT1xS+KqQst66TraAGZNGKinSDm51Jv4WTWL0VUvsd0lFYrgGjhxz2upv+zOVs592aTQNvdwIT4aFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022971; c=relaxed/simple;
	bh=7cBiUFyq7EYeReXk19+DqsCI3TC64D5K+Z2SleDYlmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKkm0/eCdkFpVG+DHwjvdaCAOf1dEQ0mmoT14dT7pTO6T7MB5f2og1ZzROV8r0nhqGKPkitJkdG3rRFK9/DOtABJnmRsjKAxSEwWNkh6Zq2/usDB1qQ6tufgCTXyF7HemZix22ufjlo1nzafZGJ0CsFQjbWSLgvLQklnC1Ick/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxT9+dzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxT9+dzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41BEC4CECE;
	Thu, 12 Dec 2024 17:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022971;
	bh=7cBiUFyq7EYeReXk19+DqsCI3TC64D5K+Z2SleDYlmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxT9+dzsHnX7s9wvzuDkEAw5mIdhmcR5Td+5I9UcGigv707nZHYHSui9QDpo7ehdu
	 /c0zoTKFdvU1Hp5gK6t8ua8Z0OCnYXAaT399yTWta1yCEnzbvQ2UyOUuR0eIR1fxad
	 nY/vVK1sLCalQONbhBuYqSHgMuZX14lxZn85XlHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 353/565] rpmsg: glink: Propagate TX failures in intentless mode as well
Date: Thu, 12 Dec 2024 15:59:08 +0100
Message-ID: <20241212144325.555335727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

commit 7a68f9fa97357a0f2073c9c31ed4101da4fce93e upstream.

As support for splitting transmission over several messages using
TX_DATA_CONT was introduced it does not immediately return the return
value of qcom_glink_tx().

The result is that in the intentless case (i.e. intent == NULL), the
code will continue to send all additional chunks. This is wasteful, and
it's possible that the send operation could incorrectly indicate
success, if the last chunk fits in the TX fifo.

Fix the condition.

Fixes: 8956927faed3 ("rpmsg: glink: Add TX_DATA_CONT command while sending")
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230418163018.785524-2-quic_bjorande@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/qcom_glink_native.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1355,8 +1355,9 @@ static int __qcom_glink_send(struct glin
 	ret = qcom_glink_tx(glink, &req, sizeof(req), data, chunk_size, wait);
 
 	/* Mark intent available if we failed */
-	if (ret && intent) {
-		intent->in_use = false;
+	if (ret) {
+		if (intent)
+			intent->in_use = false;
 		return ret;
 	}
 
@@ -1377,8 +1378,9 @@ static int __qcom_glink_send(struct glin
 				    chunk_size, wait);
 
 		/* Mark intent available if we failed */
-		if (ret && intent) {
-			intent->in_use = false;
+		if (ret) {
+			if (intent)
+				intent->in_use = false;
 			break;
 		}
 	}


