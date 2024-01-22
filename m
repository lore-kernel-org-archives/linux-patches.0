Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A0A4E1D7;
	Tue, 23 Jan 2024 00:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969942; cv=none; b=bF5J9lXqqVIVWMB9D2I4Qq+rC23z1GI+AVxd1l944p2ax1cs2QrVPnZV5G5GkBOqp+WREbiERAMlamvItDoKsA1ZREcljMYI9duJxj4JJYlb3gMV1lNpx9sg3SbMH0kgAx7/uw1SEktiHxflro8O26Stbj1ZT48105qwFjGMHy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969942; c=relaxed/simple;
	bh=q1U8mHsB4wLRUdMw+7immP+tqkWXNT6TPBBH5jBYA6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSwW9EDqb+K26thTXfTyzBxv1QN+yP13+yqYJWGJKYcB0lTbm8i4+jtDrvHkhfA98Rs9PQshTugmqeaBQiZuojJJFp2UDtwoj0xtbUANhrKHLUWYyEr6QYnVKACytVnwMbNskidXaAERPAZuhnUDKWjXUAcwEFZaHj9LV+IO1MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pi2DiTW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pi2DiTW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DCFC433C7;
	Tue, 23 Jan 2024 00:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969942;
	bh=q1U8mHsB4wLRUdMw+7immP+tqkWXNT6TPBBH5jBYA6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pi2DiTW9+FaufPtyDk3dNdcd9MLbitCvu9cmAm43V0WozV2wC5gjdLa7HxfllN5QG
	 OOHGYnANzVMQXCp1QRUdjbkoy81c6SGV/LPSqsAKD7Jm3lrdjq0+W4GHhdqte8WyQv
	 UbVxCcpo8CfbyOFjaGh2DNQ3N2QhvDpUuwGQxdQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	German Gomez <german.gomez@arm.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 508/641] perf header: Fix segfault on build_mem_topology() error path
Date: Mon, 22 Jan 2024 15:56:52 -0800
Message-ID: <20240122235833.971914972@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 70df07838fc1c0acfab3325ae79014e241a88bdf ]

Do not increase the node count unless a node has been successfully read,
because it can lead to a segfault if an error occurs.

For example, if perf exceeds the open file limit in memory_node__read(),
which, on a test system, could be made to happen by setting the file limit
to exactly 32:

 Before:

  $ ulimit -n 32
  $ perf mem record --all-user -- sleep 1
  [ perf record: Woken up 1 times to write data ]
  failed: can't open memory sysfs data
  perf: Segmentation fault
  Obtained 14 stack frames.
  perf(sighandler_dump_stack+0x48) [0x55f4b1f59558]
  /lib/x86_64-linux-gnu/libc.so.6(+0x42520) [0x7f4ba1c42520]
  /lib/x86_64-linux-gnu/libc.so.6(free+0x1e) [0x7f4ba1ca53fe]
  perf(+0x178ff4) [0x55f4b1f48ff4]
  perf(+0x179a70) [0x55f4b1f49a70]
  perf(+0x17ef5d) [0x55f4b1f4ef5d]
  perf(+0x85c0b) [0x55f4b1e55c0b]
  perf(cmd_record+0xe1d) [0x55f4b1e5920d]
  perf(cmd_mem+0xc96) [0x55f4b1e80e56]
  perf(+0x130460) [0x55f4b1f00460]
  perf(main+0x689) [0x55f4b1e427d9]
  /lib/x86_64-linux-gnu/libc.so.6(+0x29d90) [0x7f4ba1c29d90]
  /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0x80) [0x7f4ba1c29e40]
  perf(_start+0x25) [0x55f4b1e42a25]
  Segmentation fault (core dumped)
  $

After:

  $ ulimit -n 32
  $ perf mem record --all-user -- sleep 1
  [ perf record: Woken up 1 times to write data ]
  failed: can't open memory sysfs data
  [ perf record: Captured and wrote 0.005 MB perf.data (11 samples) ]
  $

Fixes: f8e502b9d1b3b197 ("perf header: Ensure bitmaps are freed")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20231123075848.9652-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e86b9439ffee..7609b4d468dc 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1444,7 +1444,9 @@ static int build_mem_topology(struct memory_node **nodesp, u64 *cntp)
 			nodes = new_nodes;
 			size += 4;
 		}
-		ret = memory_node__read(&nodes[cnt++], idx);
+		ret = memory_node__read(&nodes[cnt], idx);
+		if (!ret)
+			cnt += 1;
 	}
 out:
 	closedir(dir);
-- 
2.43.0



