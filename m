Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBDA611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7E1C433C7;
	Mon, 28 Aug 2023 10:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219315;
	bh=r57GYv514Nle95Pavl75055vz/7lAEt8dwMn0Qv1cwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eD9XKeN6DpsjFlclCOkXDxCcwGDEJwU6MdqhjdOop5h+7HJSeA5Sb69hWLKWiI4Ds
	 swxMUH9L1cPkgw2TkCyV8+BmrjWVI1Mo4J7bqw5CXirhbk1ycHmcWpaetwJAGcVn21
	 yNl5FN8Phtc0dFKFrpNnSsTnnOU0BJ48mzjicVfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atul Dhudase <adhudase@codeaurora.org>,
	Sibi Sankar <sibis@codeaurora.org>,
	Georgi Djakov <georgi.djakov@linaro.org>
Subject: [PATCH 5.4 150/158] interconnect: Do not skip aggregation for disabled paths
Date: Mon, 28 Aug 2023 12:14:07 +0200
Message-ID: <20230828101202.746778941@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Georgi Djakov <georgi.djakov@linaro.org>

commit 91b44981a2316e7b00574d32dec4fae356444dcf upstream.

When an interconnect path is being disabled, currently we don't aggregate
the requests for it afterwards. But the re-aggregation step shouldn't be
skipped, as it may leave the nodes with outdated bandwidth data. This
outdated data may actually keep the path still enabled and prevent the
device from going into lower power states.

Reported-by: Atul Dhudase <adhudase@codeaurora.org>
Fixes: 7d374b209083 ("interconnect: Add helpers for enabling/disabling a path")
Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Tested-by: Atul Dhudase <adhudase@codeaurora.org>
Reviewed-by: Atul Dhudase <adhudase@codeaurora.org>
Link: https://lore.kernel.org/r/20200721120740.3436-1-georgi.djakov@linaro.org
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Link: https://lore.kernel.org/r/20200723083735.5616-2-georgi.djakov@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -176,6 +176,7 @@ static int aggregate_requests(struct icc
 {
 	struct icc_provider *p = node->provider;
 	struct icc_req *r;
+	u32 avg_bw, peak_bw;
 
 	node->avg_bw = 0;
 	node->peak_bw = 0;
@@ -184,9 +185,14 @@ static int aggregate_requests(struct icc
 		p->pre_aggregate(node);
 
 	hlist_for_each_entry(r, &node->req_list, req_node) {
-		if (!r->enabled)
-			continue;
-		p->aggregate(node, r->tag, r->avg_bw, r->peak_bw,
+		if (r->enabled) {
+			avg_bw = r->avg_bw;
+			peak_bw = r->peak_bw;
+		} else {
+			avg_bw = 0;
+			peak_bw = 0;
+		}
+		p->aggregate(node, r->tag, avg_bw, peak_bw,
 			     &node->avg_bw, &node->peak_bw);
 	}
 


