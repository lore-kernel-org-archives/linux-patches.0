Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C618F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF6AC433EF;
	Mon, 13 Feb 2023 14:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300163;
	bh=HF/C6F1iH/7H756W8/+pL6VjCy/T6uyP+mv7SgGK/CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+buRwLC5yQw0Q7wri6jiIYrvaqa/kuIm6Xb7taIA23rhgozEL1VS5l+PJH6MoI2d
	 nOog1zKpotrI9WfhQ5eb6nEI+qt7A1g5aW6X7m5BSxLekp/lsegmnIlChcbpNaYFz8
	 aDTMbe49N7am4uhxwtRWqi8Fh7/bSC9XI4g3buAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.1 088/114] cxl/region: Fix passthrough-decoder detection
Date: Mon, 13 Feb 2023 15:48:43 +0100
Message-Id: <20230213144746.695793633@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

commit 711442e29f16f0d39dd0e2460c9baacfccb9d5a7 upstream.

A passthrough decoder is a decoder that maps only 1 target. It is a
special case because it does not impose any constraints on the
interleave-math as compared to a decoder with multiple targets. Extend
the passthrough case to multi-target-capable decoders that only have one
target selected. I.e. the current code was only considering passthrough
*ports* which are only a subset of the potential passthrough decoder
scenarios.

Fixes: e4f6dfa9ef75 ("cxl/region: Fix 'distance' calculation with passthrough ports")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 02275e6b621b..940f805b1534 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -993,10 +993,10 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 		int i, distance;
 
 		/*
-		 * Passthrough ports impose no distance requirements between
+		 * Passthrough decoders impose no distance requirements between
 		 * peers
 		 */
-		if (port->nr_dports == 1)
+		if (cxl_rr->nr_targets == 1)
 			distance = 0;
 		else
 			distance = p->nr_targets / cxl_rr->nr_targets;
-- 
2.39.1



