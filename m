Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7291C5F2D;
	Wed, 19 Mar 2025 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394920; cv=none; b=FIXIjbbNZYW3DagqgsfIH4L1B64Z0UYjpW2K+L8BRW065L/RrvPUDsvrzWCxZYoidoAh/05sQpt0W6czlQOv8rzKPqt3sc/TuhrV9oi3d8rtp+o5SOC7NplrrYzJwzUCTk6S/cnz9GZkKMnHJODCwz1qQnRftsEI9o+ACOSb3to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394920; c=relaxed/simple;
	bh=2hFThKx49oxz27PHz3w7DmRpLcx7evRFPIMWkshsjnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VouijtTAc1NolyUJe3/HKyzHUuMtw0YveHl1uj3qwtfBm74Xd1pW0MAVLttrVCQfEPY6KYlEXa2djLRMgspIjYDAnvZo1eJMCf+2ElVK35vkqVQ6fJiDDE3J9H2LOwc9z4nvMidI7PjcdNyi/1s882c7E/JVm4tL4EyJQK/pY4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCsoz63+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCsoz63+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A281C4CEE4;
	Wed, 19 Mar 2025 14:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394920;
	bh=2hFThKx49oxz27PHz3w7DmRpLcx7evRFPIMWkshsjnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCsoz63+mdTNbzaHtRtAojbffnC1t32Tn33kvkRtEi6aNr3jDz+M6mwRssbRcbDuD
	 AndNgzI0k/wiv8AsnHdVFja9S/7LRJhDvdnBbfphNGwtdTndXLYso0h07ILIvxsfYY
	 W8mFYPW7KfdkyPw4623TRf9vha71pLIv82ZOef7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 131/241] sctp: Fix undefined behavior in left shift operation
Date: Wed, 19 Mar 2025 07:30:01 -0700
Message-ID: <20250319143030.967150625@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



