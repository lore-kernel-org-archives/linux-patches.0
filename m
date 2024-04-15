Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07454762FF;
	Mon, 15 Apr 2024 14:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191945; cv=none; b=WbYS5s7Frr4cwkTXheW5G9ScwJOD/HhFSY3T6796zVKn7pyTXdIOyjH0LbOKrzNy05lI6AHA48/wcGt0dLNQ0SW/IRctfJFUnsQw26hic+gK1eJNJWDfPSASmC+oNdUUqHfTNmZauLuHz6P6RBizq3rXnGBbLdxmccO/lOHS4lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191945; c=relaxed/simple;
	bh=ZVjGXAZuSlV7nEKYVY40AbXz6wOACrqbnUkhggjDCH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjgdmT9v82n5Pt2gMs2Jf8vkv8MX7ey3xSYGyvZyZRSMTOY6dYe3Ql/6pn6kwJDboK4ptN/bQExOYRalUb3fSl29fT8JggUZZBP7AxeUi6XRX63Po6AdOb9BgAQE5oSvdGnpCXrtgelwJv0pItS8LvgMB5wpWYIred5QMM2JRQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8LzzJ9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8LzzJ9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86302C113CC;
	Mon, 15 Apr 2024 14:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191944;
	bh=ZVjGXAZuSlV7nEKYVY40AbXz6wOACrqbnUkhggjDCH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8LzzJ9IYDvfUh8qhjaSEkrsdFRCsizEzeRSeQ8mYaB6N7kQDwr2skPbqtIElji4b
	 trG+c42NWMnbaEbd2/hIqdxqvxuUrua1bk6VjPdJL4tjyk38y9iC0QTBlOLR7DEHyD
	 2/JV+rdeKJnHgNKedmpi4JtGz5tMqA4qH1oE/H6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nini Song <nini.song@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 08/69] media: cec: core: remove length check of Timer Status
Date: Mon, 15 Apr 2024 16:20:39 +0200
Message-ID: <20240415141946.422772193@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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
@@ -1121,20 +1121,6 @@ void cec_received_msg_ts(struct cec_adap
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


