Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EDB76046;
	Mon, 15 Apr 2024 14:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191055; cv=none; b=CXls7+zsIN0plYmrqZBDSVaGMys+YspTHYIKGs86azJToOsbjuY4Twz7wer6LAFe6qC/tM9oY7uaxULq4GTgiJRaWAQ3B3GSzpUwTvRwDOFiLaFNlc2rZMydla3CG8CVK5jgJh6zDP+szDagN2naOZkF3j+XS6JUTYvArzyglXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191055; c=relaxed/simple;
	bh=0GAsRVfqT71yrruMukrN7H7emFS/JG/6ZwoWtz7n7W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7dHaMEDzh14T/q2oSMBuElkGDnq5Nwq7dFlM5cxznLK9fJhN7+ma1MWC8tlE+1V4qUUKeusaOO9xt7C0i+bTz+u4xa7tvRoDaDKQMNowUe5Wi1938El9Ae8degmBWTh2VpiGlE/RrzxmOUsFJTbnH0RXhfnxggEND+IoA/M/Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdD3EsPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdD3EsPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE698C113CC;
	Mon, 15 Apr 2024 14:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191055;
	bh=0GAsRVfqT71yrruMukrN7H7emFS/JG/6ZwoWtz7n7W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdD3EsPNVHeN/UAbg9bFuJ2LBVE6ZztJipbiZSDWCrPxj1glkLKL2fLffVXyulOuY
	 S8DF99ka0G3MeR4gSyc/J19oyy96LbOpF5zPYtwAYVzLZSgY7rZmSlojnA4ucWEGwm
	 vKdqoFbF8didSCk4zzeXyrX+94qQott8Q/vSOOmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nini Song <nini.song@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.8 018/172] media: cec: core: remove length check of Timer Status
Date: Mon, 15 Apr 2024 16:18:37 +0200
Message-ID: <20240415142000.906954544@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1151,20 +1151,6 @@ void cec_received_msg_ts(struct cec_adap
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


