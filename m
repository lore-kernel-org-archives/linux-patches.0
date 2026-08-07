Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9B73F1662;
	Fri,  7 Aug 2026 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115546; cv=none; b=o0wAa5YmViAIW/6ORcOkPY6r52FEd53fRyRiJgzHhcA29yEk8HOGHeDc8lu8rso3Z5aKTnf8dUux/HTPGfb2ZeHx7X9EBwSHUM/QkvTD4xB6ubyF35So6lqsIw7hamjlLB0D3qcZtALq6QQzaa7fssEHg5MY0EeHJfpKr+yVX0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115546; c=relaxed/simple;
	bh=8gi7t5dlIP4K0nODhsdS4h3XZWDsAxqjF4ETawfFeVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu9WxyS4UOOltCKuolx4IxxWs9IdDd+BML3XZFxEeqb6KJTO/erwZPUH4Cm7qsx3wpylZyTTmzFzZKcODe50eglCoUdlco35kyZzenxAZ4qY94GKsQIZrXJG1RVzcGS1aayT71LXqcsBHgK9qrvgpmlyq1AUz8JUtn52GhOJ2og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kap41/Hr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kap41/Hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731AE1F00A3A;
	Fri,  7 Aug 2026 15:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115540;
	bh=0gYuM9D+atJgzbbxENnzBH2bLAaZQbwY5kbX0n73MNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kap41/Hr/loxTPxYEwhbyL23/FBHq5DN+pA7s75QCMvs38E12jAbcldTNCmaRYiBQ
	 akdUhATr920fgU5HJIFsMy5c4zm2Bf1vW3XmBcKHbKBgvKVg1cHorVQfnIMtc4zccS
	 7eV+I0VDVM/wtLJcz7PjeQNL64l2mvrsmAL+lvOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 311/396] can: ctucanfd: mark error-active controller status valid
Date: Fri,  7 Aug 2026 16:37:51 +0200
Message-ID: <20260807143430.976491094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

commit 4e735cbe3affe88001428fdd9cae8e685ce92f21 upstream.

In the CAN_STATE_ERROR_ACTIVE case, cf->data[1] is set to
CAN_ERR_CRTL_ACTIVE, but cf->can_id is not set with CAN_ERR_CRTL in
that path.

Set CAN_ERR_CRTL so consumers know the controller-status information
in cf->data[1] is valid.

Fixes: 9bd24927e3ee ("can: ctucanfd: handle skb allocation failure")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20260723155543.318414-1-thnkslprpt@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -869,7 +869,7 @@ static void ctucan_err_interrupt(struct
 			break;
 		case CAN_STATE_ERROR_ACTIVE:
 			if (skb) {
-				cf->can_id |= CAN_ERR_CNT;
+				cf->can_id |= CAN_ERR_CRTL | CAN_ERR_CNT;
 				cf->data[1] = CAN_ERR_CRTL_ACTIVE;
 				cf->data[6] = bec.txerr;
 				cf->data[7] = bec.rxerr;


