Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DED13BB24;
	Tue,  3 Dec 2024 14:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236819; cv=none; b=L4UJVUccCI1NMEBaa+/pW5XGDTbgNxK4iFHk8bbtM7nUvrRzdw+g7q/jPzFCJI9o5aUDUw1T0TQhHMVpaFWIIkABUzB9XX3Gsv5Iv8Ir5YMVx6IuUJgix9Ynphs+2cw+qinfMUohlglAzb69enI7zEdc09bDZS5iYXchurVEGcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236819; c=relaxed/simple;
	bh=kmXDzORr3Mf3OVL8xJtnYM7jNI85p+ad7XcDoAAm2vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di2mKCW5PqUhUUhHudDv7gyWN88kgGWmThyCZuEVCpTrgMov7waB0O7nKbJv0NgiVwRMPjdUvkIK4MDJu7ir2VHFx6k0ZG0DG9/Jcn51d+scvKWH4846OfMGhEGX//NQwhGl3n+AgIWlikk9qM7PFN3fdjkOK43Whr5ccU75Tvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPo79o1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPo79o1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B18C4CECF;
	Tue,  3 Dec 2024 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236817;
	bh=kmXDzORr3Mf3OVL8xJtnYM7jNI85p+ad7XcDoAAm2vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPo79o1YqcOqrfb2nhixI+4dOnPpS5iPKsMMmav/lQO3/07jvUCptFKpc7Amywojd
	 m1RqMwYGZce3Mc2iVQF2rscEaTZmeGE40giffHbvIEesbDU8Q8+ZfQs24aXkY3EED9
	 uH/OYfqQQQ85orarD+9IjhqcoVHqUaH7gCSjAaN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 4.19 126/138] rpmsg: glink: Propagate TX failures in intentless mode as well
Date: Tue,  3 Dec 2024 15:32:35 +0100
Message-ID: <20241203141928.387213576@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


