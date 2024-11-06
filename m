Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6051DFE1E;
	Wed,  6 Nov 2024 12:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897830; cv=none; b=bOYg5xzZFD0K5S/IRGqa2gSC02Bl8hi7sjk1EXWu1UiOw7R4x9GSSFhXY6jrnXiLMxM/00A7tFwvuNJY2MG2RJJd/zC2FJAjuvpOSQYtvAXey6CGTu02m8IAgUXF86G3GIFLKf2phYDaRFloxLF1SDc32RsTRE2KFsNZna/YC40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897830; c=relaxed/simple;
	bh=BhozlaqMdxkZtEI7fchd8K2BdCiTby+fbEDClrYeJjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcB1ykPxWyUcPM8i6dqlHDUtwd2+CErjWxW2GNpmWUYE6X8AVFKdPcanSPG3fhoCJU+e6buGE8h1J+dJN+qnJFwhOlyKId/K+ukREkCZ6cDas08eHX6bCEt82+QoGnHE+s02fMm8gj5fHHDmT6U3v/cPU4f+iH/n0vFEJX7CovY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXMgLO+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXMgLO+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF03C4CECD;
	Wed,  6 Nov 2024 12:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897829;
	bh=BhozlaqMdxkZtEI7fchd8K2BdCiTby+fbEDClrYeJjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXMgLO+xNvfx7HJlmnoW4r8fcpoLHTE88W+mXirDybuDeH/0kUCkgUMYfiwi3BQCb
	 PqH+bjIzj4wf3nf+Zt+EdwFl9Lk4dUF37JfVX/FF1cslT3q54D7hA+ESvIyVfk9y1q
	 7oFp5ssSUbzrJDXw0WgyYVvXa4TIUglCAzXX6EiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Chou <jacky_chou@aspeedtech.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/462] net: ftgmac100: Enable TX interrupt to avoid TX timeout
Date: Wed,  6 Nov 2024 12:58:21 +0100
Message-ID: <20241106120331.713527825@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Chou <jacky_chou@aspeedtech.com>

[ Upstream commit fef2843bb49f414d1523ca007d088071dee0e055 ]

Currently, the driver only enables RX interrupt to handle RX
packets and TX resources. Sometimes there is not RX traffic,
so the TX resource needs to wait for RX interrupt to free.
This situation will toggle the TX timeout watchdog when the MAC
TX ring has no more resources to transmit packets.
Therefore, enable TX interrupt to release TX resources at any time.

When I am verifying iperf3 over UDP, the network hangs.
Like the log below.

root# iperf3 -c 192.168.100.100 -i1 -t10 -u -b0
Connecting to host 192.168.100.100, port 5201
[  4] local 192.168.100.101 port 35773 connected to 192.168.100.100 port 5201
[ ID] Interval           Transfer     Bandwidth       Total Datagrams
[  4]   0.00-20.42  sec   160 KBytes  64.2 Kbits/sec  20
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval          Transfer    Bandwidth      Jitter   Lost/Total Datagrams
[  4]   0.00-20.42  sec  160 KBytes 64.2 Kbits/sec 0.000 ms 0/20 (0%)
[  4] Sent 20 datagrams
iperf3: error - the server has terminated

The network topology is FTGMAC connects directly to a PC.
UDP does not need to wait for ACK, unlike TCP.
Therefore, FTGMAC needs to enable TX interrupt to release TX resources instead
of waiting for the RX interrupt.

Fixes: 10cbd6407609 ("ftgmac100: Rework NAPI & interrupts handling")
Signed-off-by: Jacky Chou <jacky_chou@aspeedtech.com>
Link: https://patch.msgid.link/20240906062831.2243399-1-jacky_chou@aspeedtech.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.h b/drivers/net/ethernet/faraday/ftgmac100.h
index 63b3e02fab16..4968f6f0bdbc 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.h
+++ b/drivers/net/ethernet/faraday/ftgmac100.h
@@ -84,7 +84,7 @@
 			    FTGMAC100_INT_RPKT_BUF)
 
 /* All the interrupts we care about */
-#define FTGMAC100_INT_ALL (FTGMAC100_INT_RPKT_BUF  |  \
+#define FTGMAC100_INT_ALL (FTGMAC100_INT_RXTX  |  \
 			   FTGMAC100_INT_BAD)
 
 /*
-- 
2.43.0



