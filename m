Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68DB415F1A;
	Tue, 21 Jul 2026 19:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662854; cv=none; b=ioNt+PoKZKhiq1O3rvH0TtBZWCu2jKr5UmEsx+Ft+Ap1zmRxlh8hYOAWYyJnyvFpvjVxJQNgrMiAUdtbbhBIfH4F8y9a3Y50OEGZ447MOiTsE+QDKe3NFZhj585KP0asP5I7Cxxdv1CLCn9kYXHoxJrb7m7RWsfYgaSxs6gqVqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662854; c=relaxed/simple;
	bh=Kp/XYV12CbDdDeGlk6SV8pbFNyJSd90pGlKiWWaabYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SolItlALphJz93jUarhvRQBWhOnVtTQJg8X12PVJuHLmsIIXwK3DHQ8kNrvB6UeMdtByyH6X5eZxx9N8PDQtJBePc6BSFRk0x05XIVeRc4MpZaNa5d9ft4DAe8XjuM38exHW5JoQjAtGNB1rudWdwXtA9Vbi3MsZvHSg2KjTmvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkz4CiJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkz4CiJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1F91F000E9;
	Tue, 21 Jul 2026 19:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662853;
	bh=6B7U4tJfgRAk6+qv9lOfH0rBanjuBxIT8G0CtUMK8Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkz4CiJVCcsiNH358/4VVo3KYO8s0JztGSIhApEB7Cr5qR+cxmq7IxbVPgShZPHln
	 d+iowh0IOUaGidUrVBIxNhGUpQhBG7h7WeXSrED57EKprqhXz+Fs5wMfbSKqUWkRlB
	 Lwo/RfYGAnkwfseYFybJ+IR2fadvqI6QMx68HvDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	James Clark <james.clark@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0559/1276] perf cs-etm: Reject CPU IDs that would overflow signed comparison
Date: Tue, 21 Jul 2026 17:16:42 +0200
Message-ID: <20260721152458.627745343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 776bef4e00156e..e1b2612efa88a8 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -6,6 +6,7 @@
  * Author: Mathieu Poirier <mathieu.poirier@linaro.org>
  */
 
+#include <limits.h>
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/coresight-pmu.h>
@@ -3465,7 +3466,13 @@ int cs_etm__process_auxtrace_info_full(union perf_event *event,
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



