Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED06EC8F8
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614B9C433C9;
	Mon, 26 Jun 2023 18:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804897;
	bh=S1IDXCHd/U+Nc2Q9yGCCF+cX+g8D9zoTb8jVqXYpAig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAtF4jyz3NMeAuAUfTXla5XuA5avKP3rzY10PoSHJLeWVGXqIJhCTSOlYP8JnaCYa
	 Ti0DUdS8SD8+r+yfLZ0maxRoyFfEWuBFAY9/BYk3/4AJFAzgxrD8ri/+o53j1mEmQh
	 mgTqXytim3Dy05LfqJ7cPb4XBF81xD2W3djIBTIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 79/96] media: cec: core: dont set last_initiator if tx in progress
Date: Mon, 26 Jun 2023 20:12:34 +0200
Message-ID: <20230626180750.294039489@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 73af6c7511038249cad3d5f3b44bf8d78ac0f499 ]

When a message was received the last_initiator is set to 0xff.
This will force the signal free time for the next transmit
to that for a new initiator. However, if a new transmit is
already in progress, then don't set last_initiator, since
that's the initiator of the current transmit. Overwriting
this would cause the signal free time of a following transmit
to be that of the new initiator instead of a next transmit.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 67776a0d31e8c..99ede1417d727 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1086,7 +1086,8 @@ void cec_received_msg_ts(struct cec_adapter *adap,
 	mutex_lock(&adap->lock);
 	dprintk(2, "%s: %*ph\n", __func__, msg->len, msg->msg);
 
-	adap->last_initiator = 0xff;
+	if (!adap->transmit_in_progress)
+		adap->last_initiator = 0xff;
 
 	/* Check if this message was for us (directed or broadcast). */
 	if (!cec_msg_is_broadcast(msg))
-- 
2.39.2



