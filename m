Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241B946EF61;
	Tue, 21 Jul 2026 19:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660707; cv=none; b=CMN57IAv7OsgQefnfOx53XfiViGHmH8Wu6xSstvwVwHQcn1I7sa6oLEb+RRMrN7O9Y5yiG9dmhc3nt9SQ9xCx21ESBgfh7ZPnXsMhrSLb6M7Om204nN+HEzZA8m7C7XOn+dd1soUFziw1cIm0lKwZ04t65NdCNB+ipAOwicS5H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660707; c=relaxed/simple;
	bh=aaO/32gZ7ViRAF7jg5xYb1wBaizhNFRTax88P8iwyjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTIrmAGIvHaJiFX0dk0I6ha4eG6+R//guMKpwmtQlFhm5s+oZQ/E70fV9i45/9An+1zaQ4q4F4p+y/1cksGBmj+QQEwhQoGwNiNod+DXqlVA7vsvVrVQnwHerhKyZtSY7vGGCQknyYm4PN6mpVUVLZ1fI4IIKkIiubZHH5xtyBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ydi+EG8x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ydi+EG8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C7A1F00A3A;
	Tue, 21 Jul 2026 19:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660706;
	bh=Tbj+yfO8XAgV5pUCnvSwfYEqU0kTp6oViIFenwWghpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ydi+EG8xwObTZomI4AxOF2z1cdl6IjRd6SelwDOVqtM9J9H1/JP9xY2qkus+jDx++
	 8YvJVCS8lI0SWqRRvlbTbJP6fabe+5gr1aa19AhxLsqs98jsl7Y6yJQDjGNA7nuHxq
	 vWveI0OmsJG5FS+Q/Q1Px1xDv274t3KmnvJW6Vnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	James Clark <james.clark@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1081/2077] perf cs-etm: Reject CPU IDs that would overflow signed comparison
Date: Tue, 21 Jul 2026 17:12:34 +0200
Message-ID: <20260721152618.318682865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 542e88a4c6f7b6edd1326ce767d4cb3c2ea9d61d ]

metadata[j][CS_ETM_CPU] is a u64 from perf.data, but the comparison
with max_cpu casts it to (int).  A crafted value like 0xFFFFFFFF becomes
-1 after the cast, which compares less than max_cpu (0), so the queue
array is never sized to accommodate it.  When the value is later passed
to cs_etm__get_queue(), it indexes queue_array with the original large
value, causing an out-of-bounds access.

Validate that CS_ETM_CPU fits in an int before using it in the signed
comparison.

Fixes: 57880a7966be510c ("perf: cs-etm: Allocate queues for all CPUs")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index f6ffdf07969719..c1169254fadb7b 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -6,6 +6,7 @@
  * Author: Mathieu Poirier <mathieu.poirier@linaro.org>
  */
 
+#include <limits.h>
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/coresight-pmu.h>
@@ -3468,7 +3469,13 @@ int cs_etm__process_auxtrace_info_full(union perf_event *event,
 			goto err_free_metadata;
 		}
 
-		if ((int) metadata[j][CS_ETM_CPU] > max_cpu)
+		/* CPU id comes from perf.data and must fit max_cpu + 1 without overflow */
+		if (metadata[j][CS_ETM_CPU] >= INT_MAX) {
+			err = -EINVAL;
+			goto err_free_metadata;
+		}
+
+		if ((int)metadata[j][CS_ETM_CPU] > max_cpu)
 			max_cpu = metadata[j][CS_ETM_CPU];
 	}
 
-- 
2.53.0



