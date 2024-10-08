Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DE61DFD1;
	Tue,  8 Oct 2024 13:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392567; cv=none; b=VZoNLScFG15j4/IeihqVgKLZbR5RhXPkRmuoVZzVUEI+WnUjEo2Q91aW+Za4XsybGNQqGbz8dIQ7K/k62aPZAhgU02KgzQAtIXBnBP4uQVKwnteeo4ZkZ/vJOnfDCMIws+wjFyD0fre6KpEL60A36tYx1y0kUEIalVwSdrqjtyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392567; c=relaxed/simple;
	bh=xS0OijpjF5kYMH1AlrQDX9C2gQm0+ycF7zZrYhWi3XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c31mpIeWEr63PM67ZSVxrs/naoutLEib6r9XT59oGSQY8HB/hhMJjV1NACaZQLXAERv18JcdgcjwvdGRv4k8vFS0gB8d1nFmufaKihsT73NWib5xBoXxhH2HFJAs6mD4k4J05h0+eUL14nx4/S8wVTGAo2hMAqZWAGcG8B+D6q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcGy8tix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcGy8tix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CF1C4CEC7;
	Tue,  8 Oct 2024 13:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392566;
	bh=xS0OijpjF5kYMH1AlrQDX9C2gQm0+ycF7zZrYhWi3XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcGy8tixDa+hb64U7BvGydUWXEa6q82KdFDjjvXM4JOwZOGoINLWL+i7bnNfHh2VD
	 73Bzm6CTMth++1M79p4p2MKSrKBFNuSPZ29EEouXbF1dUiB6DRd430pPnMPleEiN+F
	 xdN8VMkDZkl+GF6Dc/SLRKDHh1CiflZfHLEkMPPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.11 454/558] media: uapi/linux/cec.h: cec_msg_set_reply_to: zero flags
Date: Tue,  8 Oct 2024 14:08:04 +0200
Message-ID: <20241008115720.125430763@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


