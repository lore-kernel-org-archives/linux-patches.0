Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2787E1E8322;
	Wed, 19 Mar 2025 14:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395117; cv=none; b=Hu+WvoElmAnXi7CRmVSzeXBmp0WL+ScCofXX+Rdwj+cdVtHzvYvHJTa0zuTO3drGa75C6jI8FGcSZO+/mo+wYc83Bca34sEjdlzcdilR3TyvGKB+kFPUQqf/Hd0/HJbYKxSCo8G3aabrEe91hT/aQiJ4peFHI4uBeM3EA4mZ1S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395117; c=relaxed/simple;
	bh=dmuwcabb7HRpwstnjqEKEbIu8yfbJrU+8Z9JWbi2+CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdBtecITl+EtR7Ez8HbSWnWY+sAw1qVeaMeGnOnmZZA2T0M2OKmajJbgxXDVCA8tgUQKJzRxd487+Vz27+9f5L6jLIeg1ksTAQQajSQYc3jIXH+1BmT5+3paht/yepkSzQd/a/bDKoRSxjFkhufYzBK0hLc9ZITRDVcWuvNai9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zN8PVm21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zN8PVm21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00277C4CEE4;
	Wed, 19 Mar 2025 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395117;
	bh=dmuwcabb7HRpwstnjqEKEbIu8yfbJrU+8Z9JWbi2+CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zN8PVm21b+sMt8N1duaSPouLDt06IThp45RFHrm2+g8ToICugodxICkJEIrjQ2IeX
	 PVNkNDM6NxYGp2F+l87ZbpYY8aMe2B8uuB7BFRBEHzIk+0zDen1m2WlBH0QzyMU0+8
	 Y1y4xotBeDADFv8Cj2eD23x4zwAB0F9AFW+0MarQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/231] sctp: Fix undefined behavior in left shift operation
Date: Wed, 19 Mar 2025 07:30:18 -0700
Message-ID: <20250319143029.928103531@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit 606572eb22c1786a3957d24307f5760bb058ca19 ]

According to the C11 standard (ISO/IEC 9899:2011, 6.5.7):
"If E1 has a signed type and E1 x 2^E2 is not representable in the result
type, the behavior is undefined."

Shifting 1 << 31 causes signed integer overflow, which leads to undefined
behavior.

Fix this by explicitly using '1U << 31' to ensure the shift operates on
an unsigned type, avoiding undefined behavior.

Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Link: https://patch.msgid.link/20250218081217.3468369-1-eleanor15x@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index c241cc552e8d5..bfcff6d6a4386 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -735,7 +735,7 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 	 *     value SHOULD be the smallest TSN not acknowledged by the
 	 *     receiver of the request plus 2^31.
 	 */
-	init_tsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map) + (1 << 31);
+	init_tsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map) + (1U << 31);
 	sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
 			 init_tsn, GFP_ATOMIC);
 
-- 
2.39.5



