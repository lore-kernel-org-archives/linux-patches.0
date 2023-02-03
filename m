Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583491FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EE5C433D2;
	Fri,  3 Feb 2023 10:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420180;
	bh=dG0ecsWTjyA24pZfgwVP5l/shWn2X0Ond7gYjAZ0R6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5BGAYrpHaPcp51Xm76hp9fcIwvKiFAUDNt0p8mT+Ig/eUlQ/OIqozGMi7F6qVT8Y
	 OKgYjR2hNbVJZ4gtIxPshaWC55exqXW+SiQxQlNSgKtR6/K6zpVv9WyMo/8x2mIDZU
	 G9bAbkrRKEtslxNwapjasQRsEO+Thv0ykBnDZUWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 5.4 107/134] perf/x86/amd: fix potential integer overflow on shift of a int
Date: Fri,  3 Feb 2023 11:13:32 +0100
Message-Id: <20230203101028.643246582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Colin Ian King <colin.i.king@gmail.com>

commit 08245672cdc6505550d1a5020603b0a8d4a6dcc7 upstream.

The left shift of int 32 bit integer constant 1 is evaluated using 32 bit
arithmetic and then passed as a 64 bit function argument. In the case where
i is 32 or more this can lead to an overflow.  Avoid this by shifting
using the BIT_ULL macro instead.

Fixes: 471af006a747 ("perf/x86/amd: Constrain Large Increment per Cycle events")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Ian Rogers <irogers@google.com>
Acked-by: Kim Phillips <kim.phillips@amd.com>
Link: https://lore.kernel.org/r/20221202135149.1797974-1-colin.i.king@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -969,7 +969,7 @@ static int __init amd_core_pmu_init(void
 		 * numbered counter following it.
 		 */
 		for (i = 0; i < x86_pmu.num_counters - 1; i += 2)
-			even_ctr_mask |= 1 << i;
+			even_ctr_mask |= BIT_ULL(i);
 
 		pair_constraint = (struct event_constraint)
 				    __EVENT_CONSTRAINT(0, even_ctr_mask, 0,


