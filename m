Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C637A4229C6;
	Tue, 21 Jul 2026 19:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660599; cv=none; b=ZD+nnRk+V+ER+08Gfvp8V11cD6ugw3tuqRszJOnru4EM/u2q3G40LUL0Ik7gkSYmK8du26QqZpezzNJTrFpb4crB0lIxq6pn2BnnKYnFMfGa12m7SURiEkOWBrG0QP2JUuIk3VoTg2Ry/xhPUoJ96Qkfoiprc+VlTf+M9BniSjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660599; c=relaxed/simple;
	bh=U0JoVKGEoNhz5SP3PXKmBxy/fI9Xid/zXaKXTXMNKWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsLgGVYbKviOYR3Rs4i44/lbYK02J+GRbE5dECcj7+cJLkg/MSh9hBTNuSPXasaUKOca0Ll8VO3cyPBN4PmcnutgZ1zDa95W29v6H7jicG0EXvlxJATt+spwOpk+Ny77oCzBbY4NrSVNCc509Px0W0jyxOt4kF8UZV2GMaCA5O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VT1ZKMGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VT1ZKMGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322221F000E9;
	Tue, 21 Jul 2026 19:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660597;
	bh=K/4kRKs2rAMSfiNzUGc0+wtYtc3DVgClKET6H1eUonU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VT1ZKMGcQr9EiFO7AK4dP4KdBaTD8elYcK2933Rnkb/S9slpvVPUaGhB75Lgh+G7E
	 T+hFhCpAx5w7v01a6SUNphAYhMvYT8vR4C8jTDczbdSRxmbxb/sNDiBuiTVfKo5FIu
	 Nv1pt6+8gV2NB4TqhJZH70xPBLyaDOM+K6OJ4iaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1013/2077] perf hwmon: Use scnprintf() in hwmon_pmu__for_each_event()
Date: Tue, 21 Jul 2026 17:11:26 +0200
Message-ID: <20260721152616.711536897@linuxfoundation.org>
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
index d895cd74f2a05f..fbfb872ceb1826 100644
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



