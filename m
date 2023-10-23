Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C597F4FE
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKyvddbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42524C433C7;
	Mon, 23 Oct 2023 11:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059456;
	bh=nzRpaXyFnm1ZNeeAgkETRyZpsHCwkQNCuDFEJ9HICog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKyvddbS6RQuaWfEUvmoDTZXmoqToAouaZStMdOCeGo9Q6/aBw/c+XwoHVi3W0RRm
	 iOOaTXd2DbJCfJYPdmZsmYqWsMn++tUNHLzQbt94AU4xq/KbY2tNi6HuysFpECTnJZ
	 dMSxLx0leL7SWL0tw8405sox2iuS0lLxFgbQTF34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.5 184/241] perf dlfilter: Fix use of addr_location__exit() in dlfilter__object_code()
Date: Mon, 23 Oct 2023 12:56:10 +0200
Message-ID: <20231023104838.368460241@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 7a48b58eb5ff3798f0480d2da16bf27df9654fc7 upstream.

Stop calling addr_location__exit() when addr_location__init() was not
called.

Fixes: 0dd5041c9a0e ("perf addr_location: Add init/exit/copy functions")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20230928071605.17624-1-adrian.hunter@intel.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/dlfilter.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/tools/perf/util/dlfilter.c
+++ b/tools/perf/util/dlfilter.c
@@ -280,13 +280,21 @@ static struct perf_event_attr *dlfilter_
 	return &d->evsel->core.attr;
 }
 
+static __s32 code_read(__u64 ip, struct map *map, struct machine *machine, void *buf, __u32 len)
+{
+	u64 offset = map__map_ip(map, ip);
+
+	if (ip + len >= map__end(map))
+		len = map__end(map) - ip;
+
+	return dso__data_read_offset(map__dso(map), machine, offset, buf, len);
+}
+
 static __s32 dlfilter__object_code(void *ctx, __u64 ip, void *buf, __u32 len)
 {
 	struct dlfilter *d = (struct dlfilter *)ctx;
 	struct addr_location *al;
 	struct addr_location a;
-	struct map *map;
-	u64 offset;
 	__s32 ret;
 
 	if (!d->ctx_valid)
@@ -296,27 +304,17 @@ static __s32 dlfilter__object_code(void
 	if (!al)
 		return -1;
 
-	map = al->map;
-
-	if (map && ip >= map__start(map) && ip < map__end(map) &&
+	if (al->map && ip >= map__start(al->map) && ip < map__end(al->map) &&
 	    machine__kernel_ip(d->machine, ip) == machine__kernel_ip(d->machine, d->sample->ip))
-		goto have_map;
+		return code_read(ip, al->map, d->machine, buf, len);
 
 	addr_location__init(&a);
+
 	thread__find_map_fb(al->thread, d->sample->cpumode, ip, &a);
-	if (!a.map) {
-		ret = -1;
-		goto out;
-	}
-
-	map = a.map;
-have_map:
-	offset = map__map_ip(map, ip);
-	if (ip + len >= map__end(map))
-		len = map__end(map) - ip;
-	ret = dso__data_read_offset(map__dso(map), d->machine, offset, buf, len);
-out:
+	ret = a.map ? code_read(ip, a.map, d->machine, buf, len) : -1;
+
 	addr_location__exit(&a);
+
 	return ret;
 }
 


