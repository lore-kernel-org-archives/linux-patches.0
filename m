Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DD81C68A6;
	Wed, 19 Feb 2025 08:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955145; cv=none; b=emYEwqCONqrxfYIhanndwMM/7kgBYNLjLvmGbeCo6Qg1VRR5dls83X/3NDyJBVFDrnHtg7Naxa8yz8Sw7/P/y+DT6RSrrjwsUcKaxu7Quxqnb02PJQtx14nYEqS5+Aj1t+4iLnMKckbNTJJzJNFx9QFT9A/p6g9Lq/vXPoEYK/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955145; c=relaxed/simple;
	bh=4mbo6yhB85rD4f21jU20J53DUVy20+LUQnBcHCvft2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jk8WSLKJXiKsqS9rq7908zBiA/HCPRT4aTRB/SfzJWX24jifehr5q5cLfkGBtpdAYRTSGbmO1Tk1x642ddgc0fkTmq+i4ldcUvlBLxz0cSt4lbWptZFTNIgw1zEBbHVEU2D7HVDnaZqO4sxq5wT9x43A+b4XsL5e+6LwOaYSrSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zi9FaPDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zi9FaPDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A41C4CEE6;
	Wed, 19 Feb 2025 08:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955145;
	bh=4mbo6yhB85rD4f21jU20J53DUVy20+LUQnBcHCvft2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zi9FaPDXeREoGHuQQWvSUTHxIIQon9SXiKvyMBjYHS6HEuESLci3mAJuZx9l26+fF
	 j7AQVVaU7xm+tiunC0fu0/5fKXsef7zEaZrGOpLLNWMh6mi29L98IRU2igxmtG9YU1
	 edUqwpp7QPsXFTL2arsiLfDwySDQBRKZ8s01GuAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 129/230] can: ctucanfd: handle skb allocation failure
Date: Wed, 19 Feb 2025 09:27:26 +0100
Message-ID: <20250219082606.730771150@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 9bd24927e3eeb85642c7baa3b28be8bea6c2a078 upstream.

If skb allocation fails, the pointer to struct can_frame is NULL. This
is actually handled everywhere inside ctucan_err_interrupt() except for
the only place.

Add the missed NULL check.

Found by Linux Verification Center (linuxtesting.org) with SVACE static
analysis tool.

Fixes: 2dcb8e8782d8 ("can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250114152138.139580-1-pchelkin@ispras.ru
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -867,10 +867,12 @@ static void ctucan_err_interrupt(struct
 			}
 			break;
 		case CAN_STATE_ERROR_ACTIVE:
-			cf->can_id |= CAN_ERR_CNT;
-			cf->data[1] = CAN_ERR_CRTL_ACTIVE;
-			cf->data[6] = bec.txerr;
-			cf->data[7] = bec.rxerr;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CNT;
+				cf->data[1] = CAN_ERR_CRTL_ACTIVE;
+				cf->data[6] = bec.txerr;
+				cf->data[7] = bec.rxerr;
+			}
 			break;
 		default:
 			netdev_warn(ndev, "unhandled error state (%d:%s)!\n",


