Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA17A79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B34C433D2;
	Thu, 12 Jan 2023 14:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534091;
	bh=hg9vQWgi088EO1jB7dtOWG7rUUvSRhN8hRnowNFf2aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=di59EkN77M3v39WL1MzP/mFbW/diVqfh62R1m3tHCd1m5HRNvzqDlzXNyJ737SSzL
	 aHuUU9KvUAkZ4bWDgKNgqiMoYzVWHZyl5FQQGSjaOLooUBle5ljyaoDCg04xou1G5h
	 TnooSwh6SkrPzjDxhYbIyHZXEgmAq1XnBkDk5epg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Antonov <alexander.antonov@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 692/783] perf/x86/intel/uncore: Clear attr_update properly
Date: Thu, 12 Jan 2023 14:56:48 +0100
Message-Id: <20230112135556.393401651@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Antonov <alexander.antonov@linux.intel.com>

[ Upstream commit 6532783310e2b2f50dc13f46c49aa6546cb6e7a3 ]

Current clear_attr_update procedure in pmu_set_mapping() sets attr_update
field in NULL that is not correct because intel_uncore_type pmu types can
contain several groups in attr_update field. For example, SPR platform
already has uncore_alias_group to update and then UPI topology group will
be added in next patches.

Fix current behavior and clear attr_update group related to mapping only.

Fixes: bb42b3d39781 ("perf/x86/intel/uncore: Expose an Uncore unit to IIO PMON mapping")
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221117122833.3103580-4-alexander.antonov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 03e34a440cdf..ad084a5a1463 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3747,6 +3747,21 @@ static const struct attribute_group *skx_iio_attr_update[] = {
 	NULL,
 };
 
+static void pmu_clear_mapping_attr(const struct attribute_group **groups,
+				   struct attribute_group *ag)
+{
+	int i;
+
+	for (i = 0; groups[i]; i++) {
+		if (groups[i] == ag) {
+			for (i++; groups[i]; i++)
+				groups[i - 1] = groups[i];
+			groups[i - 1] = NULL;
+			break;
+		}
+	}
+}
+
 static int
 pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
 {
@@ -3795,7 +3810,7 @@ pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
 clear_topology:
 	kfree(type->topology);
 clear_attr_update:
-	type->attr_update = NULL;
+	pmu_clear_mapping_attr(type->attr_update, ag);
 	return ret;
 }
 
-- 
2.35.1



