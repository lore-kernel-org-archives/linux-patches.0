Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D608B2119;
	Mon, 15 Apr 2024 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192145; cv=none; b=Aj8J1UH2DLboau3GOCc9sr6T2W5r50QUa6ZKRA+A95wGChl75X4Mvi3lL7HYGw7zFNsluX5AyocQdy6Jz0tMfcwfpRIABBg9XzHlyAciT5PLnhrzekSAiDMTsGXVB19oe4nlWRD3i9CZq52LqlRL0QB965XGJgAxEU0A0Z+QMT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192145; c=relaxed/simple;
	bh=ZG5KibeU2xuASX5q4uPr0cXxhW+RfBwucSG0PEN2WeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Enc/reLwlnkZiYRGvLfI2DyiyEKgO6DtWXjf9Y99mUM2K4xzfNwCW7irBbL8fSE24eA1WpfCuCU4Bb8RfplZLHITkEuMFhnp+2ShBYcpSTc0rXnJ6//eMM4yIqcezyzXdFCVxbjyNiUNn3jzgMKzqrInem3Qol/e/HIozEblmI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrQski88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrQski88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60670C113CC;
	Mon, 15 Apr 2024 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192145;
	bh=ZG5KibeU2xuASX5q4uPr0cXxhW+RfBwucSG0PEN2WeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrQski88lcIz91pO9+/UvATTMfOZJaZB69eluuTDI61fkVetRY0cr7E+gbkceF/Z/
	 LSEwBLhBsNJebAR9K534WFaZjmW4IF49wf+Dpfg2a1+ZqGkZYF7ldT/bF3QysU+bGk
	 d3cIspkainQbGssCtCDdoRh6Cpq930E972BHYgnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nini Song <nini.song@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.15 04/45] media: cec: core: remove length check of Timer Status
Date: Mon, 15 Apr 2024 16:21:11 +0200
Message-ID: <20240415141942.373861079@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1117,20 +1117,6 @@ void cec_received_msg_ts(struct cec_adap
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


