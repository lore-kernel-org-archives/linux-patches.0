Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720B92820AE;
	Wed, 23 Apr 2025 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422162; cv=none; b=g3b/YvfeW0v4MHve2PSaKY4+A8NSPO4ENrCPojd2tylpigvYrSvmFZj1bKJkRt6uMbAmoCKm/8ssrImfCn/XLE67kZehsMD9e3A3yFu22HCqJdkAVVj2s6iN9ldBao/9/Ixo0N9/5PMfxsQtLrUN+hKTt/W15k4RZFuYZidpyjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422162; c=relaxed/simple;
	bh=w563MhAKs28ebAe7LBAInPROAJelIXZ5ogRpuGyGFFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmZdFA2mdslFabeeCI1utcLPQzvVhTkGMHpV9wRG6B6BfKBxj/0ZawNT4krgqoVCy0/J4cdraavYbraSoQuEz9D9w7OAWOQIiKRH3p5b3kDyk4jQ8u69JLbEGywML0ig0QnRx4/MgBEIOhCSz69IlMwG0a4LhhNJXjxgxjDtQoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbK35Jnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbK35Jnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E87C4CEE2;
	Wed, 23 Apr 2025 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422162;
	bh=w563MhAKs28ebAe7LBAInPROAJelIXZ5ogRpuGyGFFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbK35JnlIsvrzrQJIHli/snP63hVKyAEmtc5YZeEfq0UmRHwrn3/K0q2TWErt9TR3
	 sWNYKn/C2aRz58qIEhGrrg+9/ycfZ5cbhU9KvTrVL1KiVWye1m5+XwP5SJ4jtJ592A
	 AV0YGcQnjlTjg6YnhDJEVgaPkQ8gU4EcQ2ukGCxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Maimon <maimon.sagi@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/393] ptp: ocp: fix start time alignment in ptp_ocp_signal_set
Date: Wed, 23 Apr 2025 16:43:05 +0200
Message-ID: <20250423142655.277779114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 13343c3198770..4899fdf9bdf7a 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1842,6 +1842,7 @@ ptp_ocp_signal_set(struct ptp_ocp *bp, int gen, struct ptp_ocp_signal *s)
 	if (!s->start) {
 		/* roundup() does not work on 32-bit systems */
 		s->start = DIV64_U64_ROUND_UP(start_ns, s->period);
+		s->start *= s->period;
 		s->start = ktime_add(s->start, s->phase);
 	}
 
-- 
2.39.5



