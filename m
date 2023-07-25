Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500EE1EA72
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75C6C433C8;
	Tue, 25 Jul 2023 10:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282191;
	bh=fBbc3fg8Ybz07UT0TqBEvEuHPRM0Bc2QgEfyWV2y8SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPVNfwEUQDocntbgWk9wuigr7T/MUiPY2c7NEcopHfi5qejKeTY3/+VtoB501m7vs
	 QlCa4uaIMbiMq3MVpzBTqr265/+pC0P1C3HyXaYhGI7hS+uO1nYSQGF84KuV+XVPbh
	 1z34mFeLO1GoBFmoUO/uOWhF/WvNzzTQoG9zBXCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.4 041/227] accel/qaic: tighten bounds checking in decode_message()
Date: Tue, 25 Jul 2023 12:43:28 +0200
Message-ID: <20230725104516.520059159@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 51b56382ed2a2b03347372272362b3baa623ed1e upstream.

Copy the bounds checking from encode_message() to decode_message().

This patch addresses the following concerns.  Ensure that there is
enough space for at least one header so that we don't have a negative
size later.

	if (msg_hdr_len < sizeof(*trans_hdr))

Ensure that we have enough space to read the next header from the
msg->data.

	if (msg_len > msg_hdr_len - sizeof(*trans_hdr))
		return -EINVAL;

Check that the trans_hdr->len is not below the minimum size:

	if (hdr_len < sizeof(*trans_hdr))

This minimum check ensures that we don't corrupt memory in
decode_passthrough() when we do.

	memcpy(out_trans->data, in_trans->data, len - sizeof(in_trans->hdr));

And finally, use size_add() to prevent an integer overflow:

	if (size_add(msg_len, hdr_len) > msg_hdr_len)

Fixes: 129776ac2e38 ("accel/qaic: Add control path")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Cc: stable@vger.kernel.org # 6.4.x
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/ZK0Q5nbLyDO7kJa+@moroto
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/qaic/qaic_control.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/accel/qaic/qaic_control.c
+++ b/drivers/accel/qaic/qaic_control.c
@@ -959,15 +959,23 @@ static int decode_message(struct qaic_de
 	int ret;
 	int i;
 
-	if (msg_hdr_len > QAIC_MANAGE_MAX_MSG_LENGTH)
+	if (msg_hdr_len < sizeof(*trans_hdr) ||
+	    msg_hdr_len > QAIC_MANAGE_MAX_MSG_LENGTH)
 		return -EINVAL;
 
 	user_msg->len = 0;
 	user_msg->count = le32_to_cpu(msg->hdr.count);
 
 	for (i = 0; i < user_msg->count; ++i) {
+		u32 hdr_len;
+
+		if (msg_len > msg_hdr_len - sizeof(*trans_hdr))
+			return -EINVAL;
+
 		trans_hdr = (struct wire_trans_hdr *)(msg->data + msg_len);
-		if (msg_len + le32_to_cpu(trans_hdr->len) > msg_hdr_len)
+		hdr_len = le32_to_cpu(trans_hdr->len);
+		if (hdr_len < sizeof(*trans_hdr) ||
+		    size_add(msg_len, hdr_len) > msg_hdr_len)
 			return -EINVAL;
 
 		switch (le32_to_cpu(trans_hdr->type)) {


