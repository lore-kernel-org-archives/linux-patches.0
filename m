Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4279D30F545;
	Mon, 13 Apr 2026 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096331; cv=none; b=SXwjWVrma+5ampQt815e70td+QgLJ0JqT5rjEftUzTnVu9iroXaSFl7oRZKv1blhH1VLqTjY0FDFOiPY0KZNDiD59KYrCFFsUSsmIFcIh43/4mP/ir/AOqFBWqCn8qS62bSzzQqA/V/nP9YIhndAqAFAn4zRcp+UzfqvPrCBeR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096331; c=relaxed/simple;
	bh=ST4cE3HsiuZ0GRv13d33Gisc0XHDXN+xSaPK9gUbBdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2/I/HiUcUZ0cueZKIRCsoTWEqZM0HEZPMcAl+7wT8Aq8Zw1+p7NSLezRSdiBzoVx5Ma2uWTfc2SUyaFBK/GgnzUrYMPoBHSShyXiMw4Qs1l9ND4u1ePZSGeYUlRgRWciKXpt9QUqgUZgNOmPhzk4uGI9Xb+oGsfpYdaOvwolog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLlI/5g1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLlI/5g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6BEC2BCB6;
	Mon, 13 Apr 2026 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096331;
	bh=ST4cE3HsiuZ0GRv13d33Gisc0XHDXN+xSaPK9gUbBdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLlI/5g1mhp9+dZDgVYRSxRHRFutWKWL9R2aGAgUnfw12WSd+S3yxLJs9WP1rH8ju
	 yVGUQlkF/81C4KrJ3tR0UBbW71owUML9ZGhP8IzhpKyPOFKYbhdTCr0Kx2Wy1DSs1M
	 1ginRdW0qGEWSl3l2ImEPpcv8JI8EXoVEb8r+EA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Stefan Wahren <wahrenst@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 56/86] net: qualcomm: qca_uart: report the consumed byte on RX skb allocation failure
Date: Mon, 13 Apr 2026 18:00:03 +0200
Message-ID: <20260413155733.656343584@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


