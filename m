Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55B31E493;
	Tue,  8 Oct 2024 12:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390775; cv=none; b=Hwcv82yWBNrOQWxRNDEUbDFWcMoYy7YQCvzM5kUHchIUdGDYOUHdFiaX51NNbRmUEySFlRLRTsUA1VQ1dT+RWCUyXoKsP8uwxq4/NHpzz7wobC9D6xcHnfLvSjGuSVZTwRnf+NOarvZWogb5BYkIM5B4oPvAemntPiPNuTRQrbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390775; c=relaxed/simple;
	bh=eRMIeBCBcGhvIOv4CHYQaBnFbh2ti3Y+DIkBnqdD/2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOfq3xeEz5zRwRfJwhv/VuzV5irxe+nXQNwS11NWahlBxQfqFJOhrcPfmBIZc7NXnv0RNZE+KfOt2xzWHRcrnzLqJU68y/AN2YP5C9cZU+aH1+8pAuEadnHrNutYWxVl/NttiGxMX3sKxihe7ZsXbezgykYU7xnDPti5JwUi8bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHS6amXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHS6amXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D118C4CEC7;
	Tue,  8 Oct 2024 12:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390775;
	bh=eRMIeBCBcGhvIOv4CHYQaBnFbh2ti3Y+DIkBnqdD/2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHS6amXpkXpoaBNl7G6WDbmhqtES+6ig6t/aRy9Zb36qC4+avMwop7wax6HOCE4bD
	 K+lBiCkNG6q44+VAEOw8jCC0RkqydNfLzwrQEL9nkYNvE8Og9gbyUg+BzajYBj13Lh
	 TPQfFAyUp1wQibbQ5PhbTRarzbtzZM2i5ESt8ra0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.10 388/482] media: uapi/linux/cec.h: cec_msg_set_reply_to: zero flags
Date: Tue,  8 Oct 2024 14:07:31 +0200
Message-ID: <20241008115703.683227441@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


