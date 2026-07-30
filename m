Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199BD40963F;
	Thu, 30 Jul 2026 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422082; cv=none; b=ulEe6CCnRPfB6JiXPHLMIA2PYKSw8FkSj30V+qD3VO/9I2qFTS3zWjfJZyLdfLGlk1jxELQfYjWXzMpJTKSmGIBmUa1QgiE8/f5dEPen/5UX0mI1b5cTporIJCnyE+wDHzWgyQWWVQjHWa1Hd5eyemtWVcPNOaLsX0ZgIlsfSiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422082; c=relaxed/simple;
	bh=Y8mOhFuVmtRkkOnPONEn5cGj/0jNfYkvJvxSWvT7Re4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TF/6ubs4Rd6whwmASLtfM+Zzud1cKN9xEqx8ZiaVcp0I8ru/cpmc42N4k54Wc/yuUgfn71hnRs3lsV3I8uqvaq6tmxXe7QlEpF2QJuEBls2xox1uT879g1TbC6FwiQ4Zunuz/BbD4f8LxNZMOLjqVErtL4NVNbRNaM3O5rjLl0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zd8ycMx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zd8ycMx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8671F00A3E;
	Thu, 30 Jul 2026 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422081;
	bh=//HZfekeCt1sbBePKr3vT4hai263oJZoMlpPFfDjGtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zd8ycMx/75Jinvn7d/N1Z17GxjZMSez4I/aSboUn0jnWODeSbacBiJG+TLy6iBUXi
	 iccVg3I1ci3IoguwIDwS0as917/jL+CEpAMP6SadEAKLTUlawbuIa1VP1lR93KXpDq
	 TWkWL4cctwVHqVnvPYrnHK6djOk/658PHZee07Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	Xin Long <lucien.xin@gmail.com>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 274/744] sctp: validate stream count in sctp_process_strreset_inreq()
Date: Thu, 30 Jul 2026 16:09:07 +0200
Message-ID: <20260730141450.115282283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit 18ae07691d43183d270de8be9dc8e027906015d9 ]

When processing a RESET_IN_REQUEST from a peer,
sctp_process_strreset_inreq() derives the stream count from the
parameter length but does not check whether the resulting
RESET_OUT_REQUEST would exceed SCTP_MAX_CHUNK_LEN.

The OUT request header (sctp_strreset_outreq, 16 bytes) is 8 bytes
larger than the IN request header (sctp_strreset_inreq, 8 bytes).
Generally, the IP payload is bounded to 65535 bytes, so the stream
list cannot be large enough to trigger the overflow. However, on
interfaces with MTU > 65535 (e.g., loopback with IPv6 jumbograms), a
stream list that fits within the incoming IN parameter can cause a
__u16 overflow in sctp_make_strreset_req() when computing the OUT
request size, leading to an undersized skb allocation and a kernel
BUG:

  net/core/skbuff.c:207         skb_panic
  net/core/skbuff.c:2625        skb_put
  net/sctp/sm_make_chunk.c:1535 sctp_addto_chunk
  net/sctp/sm_make_chunk.c:3695 sctp_make_strreset_req
  net/sctp/stream.c:655         sctp_process_strreset_inreq

The local setsockopt path validates the generated reset request size.
However, for an incoming-only reset, it accounts for the smaller IN
request even though the peer must generate an OUT request with the same
stream list. Such a request cannot be completed successfully by the
peer.

Reject peer IN requests whose corresponding OUT request would exceed
SCTP_MAX_CHUNK_LEN. Also tighten the local check so it does not send an
IN request that would require an oversized OUT request from the peer.

Fixes: 7f9d68ac944e ("sctp: implement sender-side procedures for SSN Reset Request Parameter")
Reported-by: AutonomousCodeSecurity@microsoft.com
Closes: https://lore.kernel.org/all/20260707203215.2752-1-blbllhy@gmail.com/
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260710010718.20318-1-blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/stream.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 5c2fdedea088ff..34ffe6c945a4bb 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -308,7 +308,8 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 					goto out;
 
 			param_len += str_nums * sizeof(__u16) +
-				     sizeof(struct sctp_strreset_inreq);
+				     (out ? sizeof(struct sctp_strreset_inreq)
+					  : sizeof(struct sctp_strreset_outreq));
 		}
 
 		if (param_len > SCTP_MAX_CHUNK_LEN -
@@ -639,6 +640,9 @@ struct sctp_chunk *sctp_process_strreset_inreq(
 
 	nums = (ntohs(param.p->length) - sizeof(*inreq)) / sizeof(__u16);
 	str_p = inreq->list_of_streams;
+	if (nums * sizeof(__u16) + sizeof(struct sctp_strreset_outreq) >
+	    SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_reconf_chunk))
+		goto out;
 	for (i = 0; i < nums; i++) {
 		if (ntohs(str_p[i]) >= stream->outcnt) {
 			result = SCTP_STRRESET_ERR_WRONG_SSN;
-- 
2.53.0



