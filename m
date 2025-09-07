Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A8C1DE8AF;
	Sun,  7 Sep 2025 20:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277179; cv=none; b=Lqck4NR7Lljuzub53yccAtOHxeOrTe2fBnjMKg5G/tF6tEfd30r80tEzatAXABAjphd13aWPbVGqZWt4oWFksfBgWZoY20yw4t+3AgzeaeZ9ED1abf8yo+QRbdHGjBxsjcQ01DL8aDVAuCE/TrTqdKthcHYV9dypd6uIMRFbwNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277179; c=relaxed/simple;
	bh=QU10ll9j4/wAT+yPSbLdZk6WO1TSzIIR9iATuE+D6RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYf54o5uksupM0qkf01JsdwYV7tPfgnBuZypldbPLPMtp/EPgCCAjiAUyVJS3lJOC42dVSHNxRJO1QPfiC+uuWQSIFaxkNOBuJyfxgk2P7QMHtOfI+3wQP63wSYrQGAoePDxYFStCYKqILDz1QtGYvOJM/bwYaFChIhSSscS1m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pK1O6N8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pK1O6N8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E2AC4CEF8;
	Sun,  7 Sep 2025 20:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277179;
	bh=QU10ll9j4/wAT+yPSbLdZk6WO1TSzIIR9iATuE+D6RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pK1O6N8hgVB8hMfaNBHmXSwUbGKc3YQN8TrSjO16nB033ejKXdq7CX+uVkgK0W+yP
	 4Rr+3JhR52GgQVYD4IS8lPE8Jk1vrB5V4LnaW6BVsOtmZmRYl+x1OZ0DoWeZFCmmz7
	 JqvTtyX+zgexLZgzuN0mnBilWSJaY6wPCkyiE484=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/175] net/smc: Remove validation of reserved bits in CLC Decline message
Date: Sun,  7 Sep 2025 21:57:58 +0200
Message-ID: <20250907195616.800876879@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Mahanta Jambigi <mjambigi@linux.ibm.com>

[ Upstream commit cc282f73bc0cbdf3ee7af2f2d3a2ef4e6b19242d ]

Currently SMC code is validating the reserved bits while parsing the incoming
CLC decline message & when this validation fails, its treated as a protocol
error. As a result, the SMC connection is terminated instead of falling back to
TCP. As per RFC7609[1] specs we shouldn't be validating the reserved bits that
is part of CLC message. This patch fixes this issue.

CLC Decline message format can viewed here[2].

[1] https://datatracker.ietf.org/doc/html/rfc7609#page-92
[2] https://datatracker.ietf.org/doc/html/rfc7609#page-105

Fixes: 8ade200c269f ("net/smc: add v2 format of CLC decline message")
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20250902082041.98996-1-mjambigi@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 521f5df80e10c..8a794333e9927 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -426,8 +426,6 @@ smc_clc_msg_decl_valid(struct smc_clc_msg_decline *dclc)
 {
 	struct smc_clc_msg_hdr *hdr = &dclc->hdr;
 
-	if (hdr->typev1 != SMC_TYPE_R && hdr->typev1 != SMC_TYPE_D)
-		return false;
 	if (hdr->version == SMC_V1) {
 		if (ntohs(hdr->length) != sizeof(struct smc_clc_msg_decline))
 			return false;
-- 
2.50.1



