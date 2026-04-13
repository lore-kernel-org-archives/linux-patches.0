Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C37282F3D;
	Mon, 13 Apr 2026 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096545; cv=none; b=iNymRLrEriT8cpexDMNmWNNdHcYKojJITheE1rS2YoInHSOSErNqC3VGRj8ce+w4j9tAeh81xsgNmQ7sX9XLeIEMtN4bsNa4DfeLf5F+9j89CdhZtH84fz9mwrfgNraPvgb83iaw2tn9ykU5qpKklAdHGuUgIXE0NPldSP4eBOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096545; c=relaxed/simple;
	bh=s62FdUp3beENydrVEzgzWPl/4K8u665qJawZtrxtdPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQdQKu13MKne7YNS/F9n+GH8s4ntY4PNiQhhIpEwvazWP3DV6Dcs2jKkr0oqJzKZouxtGnSbUHeMI7op2TXQBn11G1WVdMCgkI9x5g+bYyj57lXZ4QtIrXXZIPdsvZQMNICKOIgZqlpitBshXAv7nADWavEnM9mWhvkD1ElHKUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glMRyQ3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glMRyQ3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1B3C2BCAF;
	Mon, 13 Apr 2026 16:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096544;
	bh=s62FdUp3beENydrVEzgzWPl/4K8u665qJawZtrxtdPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glMRyQ3KsoFXy7B3dcwgy2jTVLwJSIEoLavWKKKVuBjnNY+xsy7kxUqBkPEPuiSp2
	 LMcwNCGBeSBmoUPnaAiE3pu4vow9Oy3V4ldmLls/740UZlYx7ZdKWEeUIy+U0nfSYM
	 /Z9syE3Ai+uXEmdUdKJ/qLq/fwe/h0mNbfLerox8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Stefan Wahren <wahrenst@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 53/83] net: qualcomm: qca_uart: report the consumed byte on RX skb allocation failure
Date: Mon, 13 Apr 2026 18:00:21 +0200
Message-ID: <20260413155732.998594196@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit b76254c55dc8f23edc089027dd3f8792554c69fb upstream.

qca_tty_receive() consumes each input byte before checking whether a
completed frame needs a fresh receive skb. When the current byte completes
a frame, the driver delivers that frame and then allocates a new skb for
the next one.

If that allocation fails, the current code returns i even though data[i]
has already been consumed and may already have completed the delivered
frame. Since serdev interprets the return value as the number of accepted
bytes, this under-reports progress by one byte and can replay the final
byte of the completed frame into a fresh parser state on the next call.

Return i + 1 in that failure path so the accepted-byte count matches the
actual receive-state progress.

Fixes: dfc768fbe618 ("net: qualcomm: add QCA7000 UART driver")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260402071207.4036-1-pengpeng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qualcomm/qca_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -100,7 +100,7 @@ qca_tty_receive(struct serdev_device *se
 			if (!qca->rx_skb) {
 				netdev_dbg(netdev, "recv: out of RX resources\n");
 				n_stats->rx_errors++;
-				return i;
+				return i + 1;
 			}
 		}
 	}


