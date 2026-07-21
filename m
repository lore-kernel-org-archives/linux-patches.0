Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0FF471275;
	Tue, 21 Jul 2026 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657315; cv=none; b=FPQWb/7gdZIQAr3O9ql+EojyFpM3IIFzH/C55QuslUgfocO/BYOrKabXHqZtrfP8tv6yb0KMe9qActZaqxqat2KvvEP6TR+JNvUsF2aZ0spzK51w2ViyHlF3BqWGKtL4FktpCZGonG10Cws7UfSK/wH7fhJoahUvGhrX8Yk04n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657315; c=relaxed/simple;
	bh=7e5tovGKVGsfFsbHbzIK/HrUIqc9MpVJc6pFhycqjp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmE+ZUOOVpW1Kf+nMMfJQwqYzlxIotJkBpEq5TQoiHuWGp3dZjntjxkGhV7oQoFUKuBBvakzM4Vs9+SGTzlksx2isYoxVvEKGMbecujhV+nc/KBEZzKGB3ZzN/wlZ7m03Kb7oJbh4GC6P9v9fqyHUcBPQJ09rk1H0mixqjHv64o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bzcs3W/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bzcs3W/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C58D1F000E9;
	Tue, 21 Jul 2026 18:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657314;
	bh=aeNSFzEuAKsunNn4YUFpTk8Uh8PUPQCe1Ow/F1nb4SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bzcs3W/L1SjNYZUXNhbuRQJph/uTN/zq6ICh4Lak+4wH/r+Fkvl6XymkHgkGF1Hvn
	 9txa5doaidfGpb1z+snLxyDzn1ZObignwbxb0NIIZrI/aI3Z4NVxXgRffZHf7ubIgd
	 sQ38P1mMFEAZ6hM+V4sQzOkIcaJzgIEEkiSjV/gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0718/1611] perf hwmon: Guard label read against empty or failed reads
Date: Tue, 21 Jul 2026 17:13:54 +0200
Message-ID: <20260721152531.531003981@linuxfoundation.org>
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

[ Upstream commit 34d3d93fac6d92237cb9d730ca04c37ed361c7a6 ]

hwmon_pmu__read_events() reads label files with read() into a stack
buffer, strips trailing newlines, then checks buf[0] == '\0'.  When
read() returns 0 (empty file) or -1 (error), the buffer is never
written, so buf[0] reads uninitialized stack memory.  If the garbage
byte is non-zero, the code falls through to strdup(buf) which copies
arbitrary stack data as the label string.

Fix by checking read_len <= 0 before accessing buf contents, closing
the fd and skipping the entry.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 53cc0b351ec99278 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index 539c669d5196a0..c3bc9e427cdbb7 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -295,8 +295,11 @@ static int hwmon_pmu__read_events(struct hwmon_pmu *pmu)
 			while (read_len > 0 && buf[read_len - 1] == '\n')
 				read_len--;
 
-			if (read_len > 0)
-				buf[read_len] = '\0';
+			if (read_len <= 0) {
+				close(fd);
+				continue;
+			}
+			buf[read_len] = '\0';
 
 			if (buf[0] == '\0') {
 				pr_debug("hwmon_pmu: empty label file %s %s\n",
-- 
2.53.0



