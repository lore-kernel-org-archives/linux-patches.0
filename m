Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32B1223DD0;
	Mon, 23 Jun 2025 22:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716769; cv=none; b=B94ZDRCe7YWkv2xUGa/wKjQ8vsBxic3uRgDR8rQczNmePF0MR6KMbcsQ6+5rEZmTWOQ1ZyW1vk5E1g0AdakRwtdv0srQg0sUGOC8wvV/+++NUZ0JXellPMKxv78yD/kyAnyYSt8DvKsnmTPiQ4iZH7peITR7p+b/ccAXzhdc2ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716769; c=relaxed/simple;
	bh=Kc4V1Ui+ztWUlcKyKeJCuK/WifF2xy6/WtZo8AdMMCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdYe8BR7zF8zXEE1VRIp56Ql4vevj7f20cT8fGUjcefyBdkfG5ILlv5JnO5eFbbrzb1HpDHJ3VWMJwQ4dPOsj/kN0Ql7UMJvLx5CKnwx1f4+EUM69fhBOmFqqJaV3dtGbsuNDA02T1+bZ8HGki1Uv8+6YQxHD7/82nm+q/8SHZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CD+bvNqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CD+bvNqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9E1C4CEEA;
	Mon, 23 Jun 2025 22:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716769;
	bh=Kc4V1Ui+ztWUlcKyKeJCuK/WifF2xy6/WtZo8AdMMCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CD+bvNqTNsq5mIqqPKMNgmbv2vqJgIzmtEyvGuNyjNBjP2Cw7eKJxPAo+0vE2Qk72
	 Nt18IGRgVFgSvToGyoBs2W/Kf8uwlHDTkhgaZ6cK1IQJqndkZhm7TU05qA3v37EsRc
	 SM7xW0JwXXh/TuF7xjeGB1U/J7koN4YVZAkTI17E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Namhyung Kim <namhyung.kim@lge.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/290] perf evsel: Missed close() when probing hybrid core PMUs
Date: Mon, 23 Jun 2025 15:09:09 +0200
Message-ID: <20250623130635.585267859@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit ebec62bc7ec435b475722a5467d67c720a1ad79f ]

Add missing close() to avoid leaking perf events.

In past perfs this mattered little as the function was just used by 'perf
list'.

As the function is now used to detect hybrid PMUs leaking the perf event
is somewhat more painful.

Fixes: b41f1cec91c37eee ("perf list: Skip unsupported events")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/20250614004108.1650988-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/print-events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/print-events.c b/tools/perf/util/print-events.c
index 9bee082194d5e..fb11a967c450d 100644
--- a/tools/perf/util/print-events.c
+++ b/tools/perf/util/print-events.c
@@ -271,6 +271,7 @@ bool is_event_supported(u8 type, u64 config)
 			ret = evsel__open(evsel, NULL, tmap) >= 0;
 		}
 
+		evsel__close(evsel);
 		evsel__delete(evsel);
 	}
 
-- 
2.39.5



