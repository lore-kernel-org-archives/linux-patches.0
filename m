Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774623;
	b=pTuufUt+mbNOcGMIM6bqVSMQz8IXLI3eO5PhcRDq6iJ1YrPUWV60CqfiXFePjtQyGh3k
	 2YOgtuNKi2eVdYBvjZ0CcNuV/e/eJzWwbWgbb7l4G631yz8TxKWbGl+n//lJrtTwx07V8
	 R3/FWaC4/clMFM2CM04YdzBpP8W45uHBGiExvLY+ks+MMQOjTrA1LO2vR4O75PGeO/wow
	 tG0FH2y/4M8pPsRL3sRFvqv69HlbzHYkl/u3NQJkp5Lcz85/e1KBdSiQnM6+BOxTcMsH6
	 Jd1O4gBPNa3luu1oDCQaKJRUpa4ehBn51hTF6s3cUSJ86+AHGkNfhUVI07suGsD7WAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kAAi5hCR16Dt9L9rk8229a70XDqx246iBGZQhbfpUv4=;
	b=zuMn3bFGufm5OdQfPiztnnyS+NpUUEnETDR74egXBNS1oYH577lb8/wchNTpWg8adhl3
	 YP/aY09I28gIgZyi/3r0EWjhXU4ZNEXbWK7Lnup76nUvAgNNXJJ+CKbJhN6d0tg4908H7
	 5rQfDu2Y58BA0Q8822JS0SoFcfk6yHXJhMQWJtuYye4um7tfcwLbhB/t8CX9fK1y0vSMW
	 oW1WmzYZvn8mY6EUhQjUuSaH94hBUpJYlMv5I0yTIXjpQ7JZ2mQo4SIkhOjbsAIea4Ipp
	 mGUBJXPp/I5TKFJLWWSRLCormp+x7ltCuez37umFTK5kja+/AgUyu1qxuHTZeNrRbAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VQPWg/Ow";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BC6606A31A;
	Fri, 23 Oct 2026 16:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQPWg/Ow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28421F01825;
	Fri, 23 Oct 2026 16:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774623;
	bh=kAAi5hCR16Dt9L9rk8229a70XDqx246iBGZQhbfpUv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQPWg/OwV5gNefST272phuuMZOkC/aV0uaqJycLbOKDdowlPDY5MDcZORhTCwMcab
	 PLeMtDurcWysxdV0dSoJZapPyrJwfsS8KkOWbTfM7T7OX6dpMCOZfa/s89XiFnHqQe
	 K73jcebBBLNjKt7qbKNDiLelaAeQSwnECgEy3gjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 104/242] ASoC: SOF: sof-client: Use event-handler mutex consistently
Date: Fri, 23 Oct 2026 18:39:06 +0200
Message-ID: <20261023163716.241565884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit f90f8afb61beb268ca8092e7f3a826b520d3e8da upstream.

Protect IPC RX and FW state handler list unregister/dispatch paths with
client_event_handler_mutex to match list registration and locking
comments.

Fixes: 5c19da34df02 ("ASoC: SOF: Use guard()/scoped_guard() for mutex locks where it makes sense")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20261008090143.15158-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-client.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/sof/sof-client.c
+++ b/sound/soc/sof/sof-client.c
@@ -576,7 +576,7 @@ void sof_client_unregister_ipc_rx_handle
 	struct snd_sof_dev *sdev = sof_client_dev_to_sof_dev(cdev);
 	struct sof_ipc_event_entry *event;
 
-	guard(mutex)(&sdev->ipc_client_mutex);
+	guard(mutex)(&sdev->client_event_handler_mutex);
 
 	list_for_each_entry(event, &sdev->ipc_rx_handler_list, list) {
 		if (event->cdev == cdev && event->ipc_msg_type == ipc_msg_type) {
@@ -593,7 +593,7 @@ void sof_client_fw_state_dispatcher(stru
 {
 	struct sof_state_event_entry *event;
 
-	guard(mutex)(&sdev->ipc_client_mutex);
+	guard(mutex)(&sdev->client_event_handler_mutex);
 
 	list_for_each_entry(event, &sdev->fw_state_handler_list, list)
 		event->callback(event->cdev, sdev->fw_state);
@@ -628,7 +628,7 @@ void sof_client_unregister_fw_state_hand
 	struct snd_sof_dev *sdev = sof_client_dev_to_sof_dev(cdev);
 	struct sof_state_event_entry *event;
 
-	guard(mutex)(&sdev->ipc_client_mutex);
+	guard(mutex)(&sdev->client_event_handler_mutex);
 
 	list_for_each_entry(event, &sdev->fw_state_handler_list, list) {
 		if (event->cdev == cdev) {


