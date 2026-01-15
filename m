Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678C53BFE43;
	Thu, 15 Jan 2026 17:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499294; cv=none; b=aBBGc0Ht4QVwc0m+Tdofx6zwmOUZ59ORK7p65oiP0eEFiCd4eSFw5XWCwmANKneRJZPA+7ErxvzO0sG11vtJDHszOM8wsf2XMRb2FAJHCa9aI9CT9wo4Eh+H5ZMoG6ARFAdB5qt7T1jLJ8O2qDtzGBEGHOK7Xo514p2RI2FUE+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499294; c=relaxed/simple;
	bh=jThK3rzlyIuJ2OcmHomIYtfH+nEQpejBKlrXZ/M23lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AH0hrMgqYiximGhM3qPFSxMZsiJfWRjQn8fU/NDOgI2z/fT2sgoIXPytCTvXB7Vyev1U7EN2kIBmGFCdlo17SzrhOZUCi1QrBZ/yL4YgEscOulZQ12pyUvKn0/kXXTYG0CSu1WUFhj7lSUwIennZMf4+NB6Hh+gFLCAwjkwZ0ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/raIDXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/raIDXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E076BC116D0;
	Thu, 15 Jan 2026 17:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499294;
	bh=jThK3rzlyIuJ2OcmHomIYtfH+nEQpejBKlrXZ/M23lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/raIDXoVSLjk/+7UMTof77eH44e+rHjqIvi5CXIuPQy1lHoVBaKgCAmqlJ7PU3wn
	 9ftl72W2EpGZnLsxVFTBt8JPWdsTbKku0JKS6qmW+iOgN2U+kNv4q9mOE2qEFWUMfy
	 z9jED97oNpW1T/OpWqV1H7YGJ9HlwpdWUN59Kh6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/451] caif: fix integer underflow in cffrml_receive()
Date: Thu, 15 Jan 2026 17:46:18 +0100
Message-ID: <20260115164237.307959733@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



