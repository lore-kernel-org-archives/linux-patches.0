Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6EC32FA2D;
	Mon, 29 Dec 2025 16:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025067; cv=none; b=kHnL/xmbEILPXwYAqiACyIXc6dwfCmTai77ekv5spMdBku3wchp/5cM46LtB+Jh4ixaUd6V6eZ/Alo3zwQ1zDyc4EshwAaoo4H10ic6g74TE2D8af5JmBJtIXIBrjol7Z/BhbncMQ1Tg7wXL6CfH+wLxLrAKVc3hNRqL6GBQptU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025067; c=relaxed/simple;
	bh=l/P1P4GTZmNLnjB6lCarPh3dbSepviW86/IZhV3uSqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1gaPxwF82myjhx74z76KSyT1VzuHTsHciY/wlWJMYy2xk0p5wL6MYWAj24z8KFECVqbkK5yGICeIAlM9fPEsWDc296Mae1fipEg+CfwgSHZKoIOzdcV+VjazBZx1IH7PAX0MKCj8kc+bpC4lkAvT5U//ng9/Yi6xCsNA9ODCkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1Mibvqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1Mibvqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B611CC4CEF7;
	Mon, 29 Dec 2025 16:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025067;
	bh=l/P1P4GTZmNLnjB6lCarPh3dbSepviW86/IZhV3uSqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1MibvqwNEGazil5RXsnRq73dbR8rSFbitCwZHWRd+qbVb+8tFVf6KcWBZjtMfMkd
	 3Zm9VXIq8rlRfTXZbM3jxb2xvpU5OGR0DAzcqfeDzaae6OskiKiIfhTtAgYXLzul5i
	 fh6TA8xo7NeKE1MsV2xFmqbSiAHq9QgVxUxrq+/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/430] caif: fix integer underflow in cffrml_receive()
Date: Mon, 29 Dec 2025 17:08:04 +0100
Message-ID: <20251229160727.381293564@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 8a11ff0948b5ad09b71896b7ccc850625f9878d1 ]

The cffrml_receive() function extracts a length field from the packet
header and, when FCS is disabled, subtracts 2 from this length without
validating that len >= 2.

If an attacker sends a malicious packet with a length field of 0 or 1
to an interface with FCS disabled, the subtraction causes an integer
underflow.

This can lead to memory exhaustion and kernel instability, potential
information disclosure if padding contains uninitialized kernel memory.

Fix this by validating that len >= 2 before performing the subtraction.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: b482cd2053e3 ("net-caif: add CAIF core protocol stack")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/SYBPR01MB7881511122BAFEA8212A1608AFA6A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/caif/cffrml.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/caif/cffrml.c b/net/caif/cffrml.c
index 6651a8dc62e04..d4d63586053ad 100644
--- a/net/caif/cffrml.c
+++ b/net/caif/cffrml.c
@@ -92,8 +92,15 @@ static int cffrml_receive(struct cflayer *layr, struct cfpkt *pkt)
 	len = le16_to_cpu(tmp);
 
 	/* Subtract for FCS on length if FCS is not used. */
-	if (!this->dofcs)
+	if (!this->dofcs) {
+		if (len < 2) {
+			++cffrml_rcv_error;
+			pr_err("Invalid frame length (%d)\n", len);
+			cfpkt_destroy(pkt);
+			return -EPROTO;
+		}
 		len -= 2;
+	}
 
 	if (cfpkt_setlen(pkt, len) < 0) {
 		++cffrml_rcv_error;
-- 
2.51.0



