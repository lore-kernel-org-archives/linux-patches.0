Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E64B42586F;
	Thu, 16 Jul 2026 13:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209817; cv=none; b=tmC8YR++y7tTRCEhJodVpNbdwTxFNFSfsE7UxxXlFno9116ENDkCA5suqBL2whTtYXgix3gQv+clybmihIgh0hTmGwa82kyekhzdH2DUj3V3oy8yTFqCFUsd663Qg75UuEh5ZQIrHSAKSmZBOChhF5GRa0PgyMPuIVDotxqYz74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209817; c=relaxed/simple;
	bh=MwChEuhcsP5NUZeLVMg37tlLGNx9l387aD8pfoY2wTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InG68Po8oAsZQMj4AFncDI5fzkN386wmZriXoNWQQSJVtoMHReHqVhdrXPgEgUTjtMi7HlidWD9ktRCnUD09Q8mMV5FglkOcBhcGZ2XGhNG2UipriNJv7YelcpJTP3gyDvGE0szEctKsw4nc6EfZwBKPzYXBN4FXJaX2A6bhLZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NI5d3AWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NI5d3AWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A3C1F000E9;
	Thu, 16 Jul 2026 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209815;
	bh=+DXlJFeFNNgbE95dPBF+2LcV1bLnxzSlQC+CZx6VR88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NI5d3AWg+uedbDecDcLwz4c48qTi3qD7IGmVqjs43W90TTiEXW4/f65mQuI5T45Zf
	 hkaV72nmen7QFcQfn5oofmfK19hE4nCT564L8T/LOLuqd4XGCpCjCWFDJ3ifBhsBB7
	 U5FvwkI06iGjJhbuMeoCK6/tmnqCHBjGlHl2fFa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 7.1 329/518] usb: typec: ps883x: Fix DP+USB3 configuration
Date: Thu, 16 Jul 2026 15:29:57 +0200
Message-ID: <20260716133055.010814935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit b229b22b0a945d52dee887c856991ad08744d08e upstream.

Commit 6bebd9b77726 ("usb: typec: ps883x: Rework ps883x_set()") introduced
two regressions:

 1. The CONN_STATUS_0_USB_3_1_CONNECTED bit is mistakenly written to the
    wrong configuration register (cfg1 instead of cfg0). This breaks USB3
    when using USB3+DP adapters.

 2. The switch-case fallthrough block is inverted: Currently,
    TYPEC_DP_STATE_C (DP-only) inherits the USB3 configuration, while
    TYPEC_DP_STATE_D (DP+USB3) is missing the necessary DP sink flags.

Fix these by writing the USB3 bit to the correct register and swapping the
case statement order so both states get their correct bits assigned.

Cc: stable <stable@kernel.org>
Fixes: 6bebd9b77726 ("usb: typec: ps883x: Rework ps883x_set()")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260601-ps883x-usb3dp-fixes-v1-1-d19bec3a6d26@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/ps883x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/mux/ps883x.c
+++ b/drivers/usb/typec/mux/ps883x.c
@@ -118,12 +118,12 @@ static int ps883x_set(struct ps883x_reti
 				CONN_STATUS_1_DP_HPD_LEVEL;
 
 			switch (state->mode)  {
+			case TYPEC_DP_STATE_D:
+				cfg0 |= CONN_STATUS_0_USB_3_1_CONNECTED;
+				fallthrough;
 			case TYPEC_DP_STATE_C:
 				cfg1 |= CONN_STATUS_1_DP_SINK_REQUESTED |
 					CONN_STATUS_1_DP_PIN_ASSIGNMENT_C_D;
-				fallthrough;
-			case TYPEC_DP_STATE_D:
-				cfg1 |= CONN_STATUS_0_USB_3_1_CONNECTED;
 				break;
 			default: /* MODE_E */
 				break;


