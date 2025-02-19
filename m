Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4841E0B7D;
	Wed, 19 Feb 2025 09:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955658; cv=none; b=FlC69/uFzPgi8p7teGmmVZt7SY3Ei/zBcmejU0OEwQA9QqyNVZqvbhoEvu2SAkUubxB11ydQ/fycGPnBJV80KTzZ2JzME6brizoeEKdjb7coo0EJvD0dKCyqNpoinutZIwCX6BH6dwGSL6GEv7Z+T2vGMsP5ejjUdVMQ7UEpvXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955658; c=relaxed/simple;
	bh=OfzCCQNWL8ukNODmEiJlQghrh53txjRt6OKVqAZmahA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9OGBbSJcmPBwiNrUsW0fnbvXbyBnkv1bpDFdjJ9PSFR/Ot5sVhaiHR/t069HX57+s6SRa4jxkAHf7X6Q6UhOsopwlAEseyNt/+7Wyqy8l9Y0w+P+AWq+3MDxMkxwR8cZZPh8XHCGGDQRm/J+14tQn95CwHc5/x3S9SHbE/g9ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhEadf6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhEadf6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F974C4CEE6;
	Wed, 19 Feb 2025 09:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955657;
	bh=OfzCCQNWL8ukNODmEiJlQghrh53txjRt6OKVqAZmahA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhEadf6qEBm/PkI5bHGTqQKKy3oAKobmz5utNpStObUj3twnfQxZjpyxVAKXdBOof
	 hX7a+m3kIWtM4vMvp0fI7QD3c9WM3SZ7EVngm8R0hlH6CzSMOA//1LZtvFvF3r0Rx8
	 ZS02CcpElwWmzH+5UQAyIb4Z4JOZYiwsiHxAuO28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 074/152] can: ctucanfd: handle skb allocation failure
Date: Wed, 19 Feb 2025 09:28:07 +0100
Message-ID: <20250219082552.976795691@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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


