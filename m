Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68E32F12BA;
	Fri, 17 Oct 2025 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714984; cv=none; b=FNac7/sKq847LatrWphfLyQQjvzF8EhH7gMzqL/bZXYhK76DeBsfDh5pS2GY6q43DbxrtPR6Omh4UzmHJRVCsqk9RJbDRiJIPRaEL/nlDb25RkaMu6nV1lrus6E+ueH0HQZ2s/SuD5xurIqMRtGvCl2uXyfpqOTdFbFiHbS5ZKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714984; c=relaxed/simple;
	bh=pz3ySmcGUS/wVU6E/ihKFMVW7+NyYpsullNZDPRlM/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHb9WlcmOj3xjAzLAjKCRq1k+jbf+jyzq59t7xVVcCJQ6ANok3QC2c1Zffi8u8HSoJdaipv20wug9HKNku967KB/JK0BcoXcFwiR81dbqa8qB9LgGxwWiWx9rYwDWLlI8OcobSlfTEO5MfUyu6tzGBXfqjZ/2xKPJyhTBb84QUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fm5cMfLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fm5cMfLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0A5C4CEFE;
	Fri, 17 Oct 2025 15:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714984;
	bh=pz3ySmcGUS/wVU6E/ihKFMVW7+NyYpsullNZDPRlM/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fm5cMfLYdwZhFW2xlkz6q81/01TAH8BPAYXd6v5WQOTuV7KOzp4QeWxyTK2r9CofO
	 yV3VCRY38Ymfwzain07y3MnLmrEKz0PbXF2dxVcoclDDHms5kctKvj07k0gtq6yjkf
	 mSv7Iq1teagiXBxHT0SwuaYqkTK6T3QblV9Ps85A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Collin Funk <collin.funk1@gmail.com>,
	James Clark <james.clark@linaro.org>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Blake Jones <blakejones@google.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Li Huafei <lihuafei1@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nam Cao <namcao@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 025/371] perf disasm: Avoid undefined behavior in incrementing NULL
Date: Fri, 17 Oct 2025 16:50:00 +0200
Message-ID: <20251017145202.707572212@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 78d853512d6f979cf0cc41566e4f6cd82995ff34 ]

Incrementing NULL is undefined behavior and triggers ubsan during the
perf annotate test.

Split a compound statement over two lines to avoid this.

Fixes: 98f69a573c668a18 ("perf annotate: Split out util/disasm.c")
Reviewed-by: Collin Funk <collin.funk1@gmail.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Blake Jones <blakejones@google.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250821163820.1132977-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/disasm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index b1e4919d016f1..e257bd918c891 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -390,13 +390,16 @@ static int jump__parse(struct arch *arch, struct ins_operands *ops, struct map_s
 	 * skip over possible up to 2 operands to get to address, e.g.:
 	 * tbnz	 w0, #26, ffff0000083cd190 <security_file_permission+0xd0>
 	 */
-	if (c++ != NULL) {
+	if (c != NULL) {
+		c++;
 		ops->target.addr = strtoull(c, NULL, 16);
 		if (!ops->target.addr) {
 			c = strchr(c, ',');
 			c = validate_comma(c, ops);
-			if (c++ != NULL)
+			if (c != NULL) {
+				c++;
 				ops->target.addr = strtoull(c, NULL, 16);
+			}
 		}
 	} else {
 		ops->target.addr = strtoull(ops->raw, NULL, 16);
-- 
2.51.0



