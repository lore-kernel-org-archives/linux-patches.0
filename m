Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E0027FD73;
	Wed, 23 Apr 2025 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420296; cv=none; b=E4kcue/WJpO5zzQQsYS8qls7y+ZTHEKdv3t6h5iNY+6vjA73jrD5LSgOx/5U1zYuzY+9791/P5Bvsl6LIw5MR9Pg69xWrrzubYOEBQD8EERcPPgAgXbthQi/1N781frRkXibBuCw2xj4xr1AymRDjBxxdwzM57hialLkXgLI8mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420296; c=relaxed/simple;
	bh=nkF4EZdgMGX6BL1/0ZmD5hf9kxAuzc42KFA51akdAbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUO3NRd0hn7k5/vwcdMv9ag1LLE5lsh0ugtuWbslEXFR8LAjNJ8XN4o4vsJt28MxNZ/kB7PntQgSuvcMkx/NzSU4OPbzYfNKpQjSAEqrFGQfwg/BicvQXSSOFVvTULQBqIzdYH7sTEx7VNc0ErG+lhUFJbBlT0mi7WtucY6qN+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BI91Q3PZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BI91Q3PZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A433C4CEE2;
	Wed, 23 Apr 2025 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420294;
	bh=nkF4EZdgMGX6BL1/0ZmD5hf9kxAuzc42KFA51akdAbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BI91Q3PZ5MBfAwLBD95i9REPMqYDJM0u0A6WTL1I0KJXJq7bbhbR62Je+xJjuENBR
	 JdlYuypr4OiCJ4V+8fbIFECpdRchQbLX1KOvt3IvwGn1IiqVbl9JfdG6gEB6M/oBwk
	 0vCEsT8nE1bFnmd/Ukeu6h5lEqtnxVmB3d9+/SkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Maimon <maimon.sagi@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 079/241] ptp: ocp: fix start time alignment in ptp_ocp_signal_set
Date: Wed, 23 Apr 2025 16:42:23 +0200
Message-ID: <20250423142623.815667425@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Maimon <maimon.sagi@gmail.com>

[ Upstream commit 2a5970d5aaff8f3e33ce3bfaa403ae88c40de40d ]

In ptp_ocp_signal_set, the start time for periodic signals is not
aligned to the next period boundary. The current code rounds up the
start time and divides by the period but fails to multiply back by
the period, causing misaligned signal starts. Fix this by multiplying
the rounded-up value by the period to ensure the start time is the
closest next period.

Fixes: 4bd46bb037f8e ("ptp: ocp: Use DIV64_U64_ROUND_UP for rounding.")
Signed-off-by: Sagi Maimon <maimon.sagi@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250415053131.129413-1-maimon.sagi@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4a87af0980d69..4b7344e1816e4 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2067,6 +2067,7 @@ ptp_ocp_signal_set(struct ptp_ocp *bp, int gen, struct ptp_ocp_signal *s)
 	if (!s->start) {
 		/* roundup() does not work on 32-bit systems */
 		s->start = DIV64_U64_ROUND_UP(start_ns, s->period);
+		s->start *= s->period;
 		s->start = ktime_add(s->start, s->phase);
 	}
 
-- 
2.39.5



