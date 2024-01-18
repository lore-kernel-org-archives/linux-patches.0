Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F521774B;
	Thu, 18 Jan 2024 10:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575510; cv=none; b=K5FHSVHpyn0Nr1syW5kLonnGEHsmNFK0TbN+frsLsLQJHBbvZnzHlGn9/rEz33oDDyYXbM3gS96xx3m93882AtU/8cFkInoxECBSUKyfZVLFdMZJHPmtOeuOujj4dHCMg6Ui9qfVyzyC4bOUIdRX/tUkpCYRx3myf7IomAzTtvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575510; c=relaxed/simple;
	bh=bwLqZkpY6hyQ/i7gV77yA5FpnoAT1MkxstAZHCGW+tU=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=Ro7pdFMbz2iNZ7OiL9kT3vVItoz+DtJCWWhDpvhWYLaiswvg6k79sTAnEfisaffFFRP7MsIzu9ozDM2y4h6txNMQjOHWAAKhbX6lklRSF4nYQlTglszlzEkDeCUEbMvS/hkthrDB90cIggj3KGgTHVJDL3CFS7XHQpIL2DA4iQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6+GZVCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6+GZVCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16807C433F1;
	Thu, 18 Jan 2024 10:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575510;
	bh=bwLqZkpY6hyQ/i7gV77yA5FpnoAT1MkxstAZHCGW+tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6+GZVCcy4WCo+bFfMo3nBHHGAMeIqrV28TXI30Gv2ZTWVaS8VaLJswfrQOF8bKtP
	 v2BWFeoClSXsqDLtMDPpv+DJIveHwHKIllyFaRWRPxT2hWELTKdlmBy/bmAsRovLOu
	 u7FrBWYNte/suOnRK4IrPQJ0V68SOxnWq2aHcn8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddh Raman Pant <code@siddh.me>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Suman Ghosh <sumang@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/150] nfc: Do not send datagram if socket state isnt LLCP_BOUND
Date: Thu, 18 Jan 2024 11:49:04 +0100
Message-ID: <20240118104325.707184004@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddh Raman Pant <code@siddh.me>

[ Upstream commit 6ec0d7527c4287369b52df3bcefd21a0c4fb2b7c ]

As we know we cannot send the datagram (state can be set to LLCP_CLOSED
by nfc_llcp_socket_release()), there is no need to proceed further.

Thus, bail out early from llcp_sock_sendmsg().

Signed-off-by: Siddh Raman Pant <code@siddh.me>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 645677f84dba..819157bbb5a2 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -796,6 +796,11 @@ static int llcp_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	if (sk->sk_type == SOCK_DGRAM) {
+		if (sk->sk_state != LLCP_BOUND) {
+			release_sock(sk);
+			return -ENOTCONN;
+		}
+
 		DECLARE_SOCKADDR(struct sockaddr_nfc_llcp *, addr,
 				 msg->msg_name);
 
-- 
2.43.0



