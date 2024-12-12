Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADC8215764;
	Thu, 12 Dec 2024 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024502; cv=none; b=Ilx9F5+OxXTvJXoYn9CBUL9fVjANdEV9PV8kIeeZBhB0ZriUrrVH6ifEYCc6NM+FZbTgyqVjTtQTHs4vR5Rx+fNZwyf5MiykaW2u69KqC0H33i37cUGZL5HnUcqE5Vr9YWZuXA8ee7ncI0JgfijWF5Uw1VF/mx4LOMqlzc8t2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024502; c=relaxed/simple;
	bh=gQ+qFUOIojTPeb/EI8hJ48noAOqdwXQr5ZVVL/XOJZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW21v8vOZSqIUfJXpABMy056Ak+KKjcVVNDcXTSQwr/J6+t1abHVU2tS5SnbOgDGhOsr6n20EnbPjqcOnQTNlcG/mqgxaDg/HhLMbXKH1k+OxgoANGh7hF9il6X43Mh3MallnefJQSmiYZECUF7R2ER0xo3pUHGFSfKyRYwahxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bi+qrib1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bi+qrib1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89CCC4CED0;
	Thu, 12 Dec 2024 17:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024502;
	bh=gQ+qFUOIojTPeb/EI8hJ48noAOqdwXQr5ZVVL/XOJZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bi+qrib1DvI1TnscPRcGc3BArkwV4BM9cp8lNn9BG54C1Q+h/mUeAlKmloM8KnyQw
	 QLTBhndxeq3Y/30NXlc18S3NJTQ0eq2mE3BtbHK6RF7bK7aoW5PhcXhrXeDUZeH6pU
	 025eCNXY5dAE6X9/6zqoXHadjhOB3HO7VHud9Zec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 287/459] rpmsg: glink: Propagate TX failures in intentless mode as well
Date: Thu, 12 Dec 2024 16:00:25 +0100
Message-ID: <20241212144304.970681365@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


