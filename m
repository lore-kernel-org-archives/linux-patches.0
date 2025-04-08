Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665B1264627;
	Tue,  8 Apr 2025 12:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113924; cv=none; b=co8hrLi6MHf+KXd/L7C0divIb2WWl7TbtP6G2oulkuqcnIZd5OSU1GH+82fo5bvNh1y7HQQ6Ei5DVw31saMzvV5sy+M8XZRNAuFDk+9cMe2uqThGcUust2O3iS1NdLr91b75P5jNcmeHZBC9UBGDzHoXR4gsbdJgqj2OC4XQiCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113924; c=relaxed/simple;
	bh=fWPPogGVH0sNXwG21E07agZCJJkOfVJFPDzUbQI/VbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpGHlM43vwIBbcsDtinp/02IMYHyE5oSHuB+KJ/K+bPDnbsEej4bO9vfYWE/SBf/koy8e5w96Vv09qSJT0FWayVSozNmkol5Wzg6qJmgpGxB0icOY1pl2aS63YV0Vdryxr/D/9LhkvQiihw9E9sX2JaoDKvIIc8zSn1ZuRlZz0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JS7xzQOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JS7xzQOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC240C4CEE7;
	Tue,  8 Apr 2025 12:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113924;
	bh=fWPPogGVH0sNXwG21E07agZCJJkOfVJFPDzUbQI/VbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JS7xzQOoqDLqgNlsoaDkSXkZ6hDRoVwXdiHcODIr2cGioX8Ovc+XuvlExEG3IppnQ
	 4sLYkBTvAYr4J4lEV9rOKVIUndT7F+nXhiW670ZcPiPMCLKqxhsWDj5oxxZ/cgDL/E
	 /6J7wsLO1vVQZVPeaZ26ZMAYrP43+dSi0OH4yARs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/154] sctp: Fix undefined behavior in left shift operation
Date: Tue,  8 Apr 2025 12:49:33 +0200
Message-ID: <20250408104816.288444281@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ca8fdc9abca5f..08cd06078fab1 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -736,7 +736,7 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 	 *     value SHOULD be the smallest TSN not acknowledged by the
 	 *     receiver of the request plus 2^31.
 	 */
-	init_tsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map) + (1 << 31);
+	init_tsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map) + (1U << 31);
 	sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
 			 init_tsn, GFP_ATOMIC);
 
-- 
2.39.5



