Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBE312B176;
	Tue, 30 Apr 2024 10:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474770; cv=none; b=CSpafUXUxHqzFNHdwUXrGMCr6XcHkV1ofSQFWuZhLbV5h+DTPDuiHwAEM5O2aIDcyUEsgJUG2osgDz3Ws7GK+sLAbfGvOKzr6l2GfPz4ZmxxxijEZ+2/mnhlmCTHo9tw5ncjoemBAHiM9e9bTK20OrH28rtvbtR1VXGhDQuksyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474770; c=relaxed/simple;
	bh=34k3XxnnZ3V9U2iJpUYnuDWGnLyEgrG3q+MCfEpIEa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qm27gHdUAeDFiDt7zqH7/kVSTErk//oCePdauyMgT7j2sgg+COU4cqgok/qq6k8iVG6bKqQqNgqF23iX5vevwclHykEx6ZaS3qZ2Qzbw9noEyXZ9LDa0f8zLSOTqpAgLQKAnKo8Ykg6pcJyhAodz7PAl3FB6hIEisdNVGl0B5dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKJUfdMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKJUfdMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03140C2BBFC;
	Tue, 30 Apr 2024 10:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474770;
	bh=34k3XxnnZ3V9U2iJpUYnuDWGnLyEgrG3q+MCfEpIEa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKJUfdMCTjfUtkmYNTXuFFjT7nEQQQZZlUGpVLCOPX6mhk0P1KlPhQ1oD0cAFdkSg
	 McXZFCR2yEFsVwSUUaGJ1nNiykzObdBgBKiGwnYUwwkTnTrbS+sKfqFdW6nxWqEoGD
	 l660iSZ8RSMbV5b2hnb/ByIVrj9CrVPO/5KYa+r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nini Song <nini.song@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.10 003/138] media: cec: core: remove length check of Timer Status
Date: Tue, 30 Apr 2024 12:38:08 +0200
Message-ID: <20240430103049.527061326@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

From: Nini Song <nini.song@mediatek.com>

commit ce5d241c3ad4568c12842168288993234345c0eb upstream.

The valid_la is used to check the length requirements,
including special cases of Timer Status. If the length is
shorter than 5, that means no Duration Available is returned,
the message will be forced to be invalid.

However, the description of Duration Available in the spec
is that this parameter may be returned when these cases, or
that it can be optionally return when these cases. The key
words in the spec description are flexible choices.

Remove the special length check of Timer Status to fit the
spec which is not compulsory about that.

Signed-off-by: Nini Song <nini.song@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-adap.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1116,20 +1116,6 @@ void cec_received_msg_ts(struct cec_adap
 	if (valid_la && min_len) {
 		/* These messages have special length requirements */
 		switch (cmd) {
-		case CEC_MSG_TIMER_STATUS:
-			if (msg->msg[2] & 0x10) {
-				switch (msg->msg[2] & 0xf) {
-				case CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE:
-				case CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE:
-					if (msg->len < 5)
-						valid_la = false;
-					break;
-				}
-			} else if ((msg->msg[2] & 0xf) == CEC_OP_PROG_ERROR_DUPLICATE) {
-				if (msg->len < 5)
-					valid_la = false;
-			}
-			break;
 		case CEC_MSG_RECORD_ON:
 			switch (msg->msg[2]) {
 			case CEC_OP_RECORD_SRC_OWN:


