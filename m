Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7242246D544;
	Tue, 21 Jul 2026 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657311; cv=none; b=iKAm5t+PyLMcHCIvk6tJZnGFVvFu+48v7QcDm8DuOLgpcKLbPKLipJ7elO3wITXUXDp9k7ONMF8jUfI7plk9CWY1W5c7e1HeDOWe1r+DsMpf/66b5PwPZ7W9uX1HK5u2XIPlSYzgnYor1cTARCZnzdEmJy4pn6YVYRjCT8ho7tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657311; c=relaxed/simple;
	bh=oXzrkGlzWbwjmvwCbHTRpjDrGfNdjLEW5MEbA0AX0DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aac2z/bGqq55R1Jr7ds2CY/xzTSdTr7KR03Ld4j0VReYXnXn3P9iFT3TAmcvbeUInXdD+Lge63QWuSyyAMGI9Q2+pYmDoaQIbbSPLxLNi5pLTNZiW6BUu72mTtREUOFyLRJPNeQI0BepXMltc5PipcBVTwcEKV89z0uPRlhMjk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/fOuu+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/fOuu+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B4C1F00A3D;
	Tue, 21 Jul 2026 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657309;
	bh=JIm6EXD5WMc9OckeOAzkd/gdUc8gtkSrCbapinSQ4wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/fOuu+7PmkJ0UiJKg6hUX6U8vVv+giUbBqSL32Nl6W7CPV5SArxX1N3tx7FSsu2V
	 FapV5yJpfOdOs4onpU7Lky7S26OdCmKT6+yY+wXDo1+53wW7Cn2jS7gT4nMZWLiHji
	 RuLp7jhQFacMiIm2xOj0JOiKxlPiv/mFWa03tM04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0716/1611] perf hwmon: Fix parse_hwmon_filename() strlcpy buffer overflow
Date: Tue, 21 Jul 2026 17:13:52 +0200
Message-ID: <20260721152531.485269320@linuxfoundation.org>
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

[ Upstream commit e1a2c9d70b312acc262f6be936dd5bbd9bbc6236 ]

parse_hwmon_filename() strips the "_alarm" suffix from event names
by copying into a 24-byte stack buffer:

    strlcpy(fn_type, fn_item, fn_item_len - 5);

The third argument is the source length minus the suffix, not the
destination buffer capacity.  A long event name ending in "_alarm"
can have fn_item_len - 5 > sizeof(fn_type), causing strlcpy() to
write past the 24-byte fn_type[] array.  The assert() only validates
that the longest *valid* hwmon item fits, but does not protect
against crafted input.

Clamp the strlcpy size to min(fn_item_len - 5, sizeof(fn_type)).

Fixes: 4810b761f812da3c ("perf hwmon_pmu: Add hwmon filename parser")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index 5df5ed2aa0ecd9..539c669d5196a0 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -202,7 +202,8 @@ bool parse_hwmon_filename(const char *filename,
 	fn_item_len = strlen(fn_item);
 	if (fn_item_len > 6 && !strcmp(&fn_item[fn_item_len - 6], "_alarm")) {
 		assert(strlen(LONGEST_HWMON_ITEM_STR) < sizeof(fn_type));
-		strlcpy(fn_type, fn_item, fn_item_len - 5);
+		/* fn_item_len - 5 strips "_alarm"; clamp to buffer size */
+		strlcpy(fn_type, fn_item, min_t(size_t, fn_item_len - 5, sizeof(fn_type)));
 		fn_item = fn_type;
 		*alarm = true;
 	}
-- 
2.53.0



