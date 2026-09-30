Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296B84FB9C8;
	Wed, 30 Sep 2026 15:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782869; cv=none; b=CoY9EDMZ0mOP0xKtG0CYiExlKLBlhQZ9gESW5BiLGXe9Z62qz5EWxlvJ++d9pRxOUhsOosFTnjINXg04hqIl498XV/lGbB9eXsWh/wsuy/QrJYYnQkE1mMmwdTJDIlAy6chg+UokqQ4e5Yb+MbCa/e1TGBdCoIdrnqeFO3UvUpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782869; c=relaxed/simple;
	bh=6JqdmcAhzWAKsQM0SKUaKr1zsmap0OFyekR0/hDZWfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEl6g9HqN0oUU8lvrgQ5T6gEZTcvOtJIIa1HCiq1SfuELBGWHQ7xCsIyiixz3RFqx1rrFs8bJ4KVelRKidQWPfgx3eszKGiNsTtKpBQah4EH5P/FHTfsYbpe12HbpNeiHehIjNnwoLCjGY5NUcJ29vVDcFOR10WEG3Ize/Cztt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YIPlBAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YIPlBAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192861F000FF;
	Wed, 30 Sep 2026 15:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782865;
	bh=s9KOPWyJ9BE6vcKEayDleBgEb3aJ0542xGQjP6aTpDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YIPlBABxZ8QdCqojrkb9qcREfs1lWBdzQC9B2CVWJjdZJgxHeUnd3gkceE6HSft7
	 39Op6A26L5y830zQd84FfckmPCPAwoELeNC5pnYyJtygM7ziA6N3RYJ6pYE1ZfQL6x
	 L3dT/YhNuVQfWJyk9QR9g9XZoG0Zx5cL+DRTDzW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/595] sctp: fix soft lockup from unpadded ASCONF-ACK parameter iteration
Date: Wed, 30 Sep 2026 17:21:29 +0200
Message-ID: <20260930152351.954444903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 2cb0b0b1ed69430bf73740377ea0a1c44c50db63 ]

sctp_verify_asconf() walks ASCONF-ACK parameters with
sctp_walk_params(), which advances by SCTP_PAD4(length), while the
consumer sctp_get_asconf_response() iterates the same parameters
advancing by the raw length, without padding. A single odd-length
parameter desynchronises the two walks and makes the consumer
interpret attacker-controlled bytes at a misaligned offset.

When those bytes yield a length of zero, the while loop over
asconf_ack_len makes no progress, spinning forever in softirq
context, and the watchdog reports a soft lockup. All reads stay
within the received skb, so the lockup is a pure remote denial of
service. A remote peer can trigger it with a crafted ASCONF-ACK on
an ADD-IP enabled association with an outstanding ASCONF (RFC 5061
section 4.1.2 requires the chunk to be authenticated, but the
predefined empty key id 0 allows the peer to compute the same
association HMAC from publicly exchanged parameters, so the gate
does not help).

The SCTP_PARAM_ERR_CAUSE case of sctp_verify_asconf() also performs
no length check, letting a parameter without a complete error
header reach the consumer, which reads errhdr.cause past the end of
the parameter, an out-of-bounds read.

Reject SCTP_PARAM_ERR_CAUSE parameters shorter than
sizeof(struct sctp_addip_param) + sizeof(struct sctp_errhdr) at the
verifier, and advance the consumer iterator with the same padding
rule as the verifier to keep the two walks in lockstep. The verifier
change guarantees a complete error header in every ERR_CAUSE
parameter the consumer can see, so the consumer's asconf_ack_len
check is dropped and it returns err_param->cause directly. The
consumer padding fix is still required because odd lengths remain
valid for SCTP_PARAM_ERR_CAUSE per RFC 5061.

The issue was found by ZeroHive, a vulnerability hunting agent at
Tencent Yunding Lab.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260828042431.3873725-1-bsdhenrymartin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 06309c1869da0..3425554931a37 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3192,6 +3192,9 @@ bool sctp_verify_asconf(const struct sctp_association *asoc,
 		*errp = param.p;
 		switch (param.p->type) {
 		case SCTP_PARAM_ERR_CAUSE:
+			if (length < sizeof(struct sctp_addip_param) +
+				     sizeof(struct sctp_errhdr))
+				return false;
 			break;
 		case SCTP_PARAM_IPV4_ADDRESS:
 			if (length != sizeof(struct sctp_ipv4addr_param))
@@ -3425,20 +3428,15 @@ static __be16 sctp_get_asconf_response(struct sctp_chunk *asconf_ack,
 			case SCTP_PARAM_ERR_CAUSE:
 				length = sizeof(*asconf_ack_param);
 				err_param = (void *)asconf_ack_param + length;
-				asconf_ack_len -= length;
-				if (asconf_ack_len > 0)
-					return err_param->cause;
-				else
-					return SCTP_ERROR_INV_PARAM;
-				break;
+				return err_param->cause;
 			default:
 				return SCTP_ERROR_INV_PARAM;
 			}
 		}
 
 		length = ntohs(asconf_ack_param->param_hdr.length);
-		asconf_ack_param = (void *)asconf_ack_param + length;
-		asconf_ack_len -= length;
+		asconf_ack_param = (void *)asconf_ack_param + SCTP_PAD4(length);
+		asconf_ack_len -= SCTP_PAD4(length);
 	}
 
 	return err_code;
-- 
2.53.0



