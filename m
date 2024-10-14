Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08891AAE02;
	Mon, 14 Oct 2024 15:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919352; cv=none; b=sZhYCrKc92CtivmkmZziyNQQU133WVQSAuT+5XmzUXA9habOthffYLf3k8UEOEIECyMejMLZ7JLMSYwZ8DmIhL3ElbTsXkuBoim1xo3pPRANC8Vkt6N8M5/2kBn0gtbp+XYBXMw4mgoGm90GSNKk/sAZ3TPCpAlZeiiIr8mPb5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919352; c=relaxed/simple;
	bh=TI7ATnjIEPUCFgj9st/vJprO7fML4Vl69iVlqJq3arI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx0JkZZ3P1xIDxHiU1ypbLhFoICu2UVVntdJpXu9iPHWL+H77Wil8zn2RCk3yunbwyUbTwwyhhqJhq8tbXUswMm3FD0ZDXdpnaRgLKFZ6jhkn76Zi5TkzINRj6rL8LXzl5YMeD3ZUl9KGhnJ2fmFPNklKjzr9sCA/yNL+awGGB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuqGVBEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuqGVBEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DED9C4CEC7;
	Mon, 14 Oct 2024 15:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919351;
	bh=TI7ATnjIEPUCFgj9st/vJprO7fML4Vl69iVlqJq3arI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuqGVBEawIEZujKIYAkXr/Gguw3O5OSgZhsvQYqJwjABTMB5FG81GByYU/4way5Kj
	 R5eX/aKD9OIVrZaYRhnQcmrmDzVorVVEe4/RmchkZKS+OXg2m66yGkxd2Q18w4PyJu
	 pWxza1+4a7JbCHnCHmiMrpWOSYXQEOlAdYYSq9xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 585/798] media: uapi/linux/cec.h: cec_msg_set_reply_to: zero flags
Date: Mon, 14 Oct 2024 16:18:59 +0200
Message-ID: <20241014141240.986407152@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 599f6899051cb70c4e0aa9fd591b9ee220cb6f14 upstream.

The cec_msg_set_reply_to() helper function never zeroed the
struct cec_msg flags field, this can cause unexpected behavior
if flags was uninitialized to begin with.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 0dbacebede1e ("[media] cec: move the CEC framework out of staging and to media")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/cec.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -132,6 +132,8 @@ static inline void cec_msg_init(struct c
  * Set the msg destination to the orig initiator and the msg initiator to the
  * orig destination. Note that msg and orig may be the same pointer, in which
  * case the change is done in place.
+ *
+ * It also zeroes the reply, timeout and flags fields.
  */
 static inline void cec_msg_set_reply_to(struct cec_msg *msg,
 					struct cec_msg *orig)
@@ -139,7 +141,9 @@ static inline void cec_msg_set_reply_to(
 	/* The destination becomes the initiator and vice versa */
 	msg->msg[0] = (cec_msg_destination(orig) << 4) |
 		      cec_msg_initiator(orig);
-	msg->reply = msg->timeout = 0;
+	msg->reply = 0;
+	msg->timeout = 0;
+	msg->flags = 0;
 }
 
 /**


