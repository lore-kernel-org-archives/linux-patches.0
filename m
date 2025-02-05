Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A97A1DA628;
	Wed,  5 Feb 2025 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766645; cv=none; b=PR8usEghIERlH4O7ZwFUGNuCI9T6Ij/q8MDr8C/8ziK2xMM0x6fXurCODDYwTCCjp63royFxgsJn26LBiFKVJ4gw+DChs+B8FcWApQOjcRUiJ9mCrujJ087/QsI+QNgWd+J9D0HbZKPa5p6kz1GksA7KUp/MyroSuuaIfYNpsM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766645; c=relaxed/simple;
	bh=U8hPxhDM5m2w0uxY11QUi8N2VoJT1nfn//iYvRmxd9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfUNAKqHJCY3JTiX6tDbnM8U2rWx0sZAsLbYGqQY1S4o7M4mG+HN9ta8jqf4c9ac3Nc29LOw2RsWzO2f1qsseUiaecGhacGgHIo/6P3/uedW2XihL2C8i3IT6AyG9ouAyPR7FuPQAkcALRsYtCd+UCMQzc2NR6LUUR7JWU4jGJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXefhxIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXefhxIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1C8C4CED1;
	Wed,  5 Feb 2025 14:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766645;
	bh=U8hPxhDM5m2w0uxY11QUi8N2VoJT1nfn//iYvRmxd9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXefhxIZwF/oUWCkoXJGnaC9JCAxxujEWsjoLJ2GPNjF29IA1g4VtKqgp6UP/yI32
	 nMQNnzMoGcCMBkSerYqpxh/k2I2ldgbwoKJ7kAs822Ab2KB7WZPxj7aPDWO2M2dq4V
	 7mNfT486Rvy+arsxto4gmDfl+BfZJpI91GF4IrPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.6 381/393] usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE
Date: Wed,  5 Feb 2025 14:45:00 +0100
Message-ID: <20250205134434.872773954@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jos Wang <joswang@lenovo.com>

commit 2eb3da037c2c20fa30bc502bc092479b2a1aaae2 upstream.

As PD2.0 spec ("8.3.3.2.3 PE_SRC_Send_Capabilities state"), after the
Source receives the GoodCRC Message from the Sink in response to the
Source_Capabilities message, it should start the SenderResponseTimer,
after the timer times out, the state machine transitions to the
HARD_RESET state.

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable@vger.kernel.org
Signed-off-by: Jos Wang <joswang@lenovo.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20250105135245.7493-1-joswang1221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4065,7 +4065,7 @@ static void run_state_machine(struct tcp
 			port->caps_count = 0;
 			port->pd_capable = true;
 			tcpm_set_state_cond(port, SRC_SEND_CAPABILITIES_TIMEOUT,
-					    PD_T_SEND_SOURCE_CAP);
+					    PD_T_SENDER_RESPONSE);
 		}
 		break;
 	case SRC_SEND_CAPABILITIES_TIMEOUT:


