Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10A446E016;
	Tue, 21 Jul 2026 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657308; cv=none; b=ZlWlu/+XpzNeyIYT/6mULgcA8+nqvJPz+ckesnfLCK2nhqW/Bz9PdZaKwZSsYzzdmvRkbH05n/gEXSDaFPZu4XFG97Dz94vLiQmG4aPnWB/vpjuWl/5TPaoXDRsm8W7Ek8pJIclFV+SXSYZSTeCU2L0TEdpsYlNzEtY4xq1RT6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657308; c=relaxed/simple;
	bh=2yd99keFSGr+zS5KrSTiNCSRciiiOYnIJjh46tDOWIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrFGbxIaGGFqGuCyE6RIGyplkJ0qrtONOT19EBhqAak1wW0tQRvzoVo6VZHGVNiVacJmF761cxBmOQm1qwW8ZNVVdtNOSKokik7OsJ72O82+M0QH6g27LP/4FK47OnWn2uY3ubC4woPZ6ljOO2Vy1nscmcHqoS3YrE+k/WVbSWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KC5kuM22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KC5kuM22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8479C1F00A3A;
	Tue, 21 Jul 2026 18:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657304;
	bh=a+yLV1YC7tKMGzs61sKU3aSfMyw/V3w8OnykgjOZTbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KC5kuM22T2rwww4Tr4NzuIQ5XJYbR964bL77itRW1oXqF/Holwr8qoObvxefKz4vd
	 o0QuUwQQLkFD1WZ1PRHjgTzOz0LjgJBpvVap8rXB3LaHM3otehrA6NMd0fDbQIVMER
	 mf989eAcJYjo3Cc1U4usaS7v3o3ARSJR0Z/lCyNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0715/1611] perf hwmon: Use scnprintf() in hwmon_pmu__for_each_event()
Date: Tue, 21 Jul 2026 17:13:51 +0200
Message-ID: <20260721152531.462975981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit ae75956c166fe169b8c137bf375305fc97820a62 ]

hwmon_pmu__for_each_event() formats description strings via:

    len = snprintf(desc_buf, sizeof(desc_buf), "%s in unit %s named %s.", ...);
    len += hwmon_pmu__describe_items(hwm, desc_buf + len, sizeof(desc_buf) - len, ...);

If value->label is long enough to cause snprintf() to truncate, it
returns the would-have-been-written count, making len exceed
sizeof(desc_buf).  The subsequent sizeof(desc_buf) - len underflows
to a huge size_t value, disabling bounds checking in
hwmon_pmu__describe_items().

The alias_buf snprintf has the same issue.  Switch both to scnprintf()
which returns actual bytes written.

Fixes: 53cc0b351ec99278 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index c4efeaae2607ec..5df5ed2aa0ecd9 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -514,14 +514,14 @@ int hwmon_pmu__for_each_event(struct perf_pmu *pmu, void *state, pmu_event_callb
 		int ret;
 		size_t len;
 
-		len = snprintf(alias_buf, sizeof(alias_buf), "%s%d",
-			       hwmon_type_strs[key.type], key.num);
+		scnprintf(alias_buf, sizeof(alias_buf), "%s%d",
+			  hwmon_type_strs[key.type], key.num);
 		if (!info.name) {
 			info.name = info.alias;
 			info.alias = NULL;
 		}
 
-		len = snprintf(desc_buf, sizeof(desc_buf), "%s in unit %s named %s.",
+		len = scnprintf(desc_buf, sizeof(desc_buf), "%s in unit %s named %s.",
 			hwmon_desc[key.type],
 			pmu->name + 6,
 			value->label ?: info.name);
-- 
2.53.0



