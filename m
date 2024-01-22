Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BA777638;
	Tue, 23 Jan 2024 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975510; cv=none; b=dlmjxH1KJzY+aZIE1z3jwoJB4eTQ3rey1xFFcmH1NNJbpznxqqxKfi1duDc2/GEax4eK3zd+yOmWLY6Jj4xI6VYsmoecJgiIgJIn3giyWShpLNQl09cFkdd6Um9IRlWlx8gVg92KCw9UMFdarM1NymNaZUqMGSlcCflzRLoXNuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975510; c=relaxed/simple;
	bh=JURhskW7KAK3qIpRBal2k3uZa33LZP1eH10g7IfFn1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrX2t91Bmnl2c0UcUjJr05WlPFvREDllgtbZufAcqCcy8VbA6m2MgvAJvKhl/p8ZyobgiarjZqLzx6HZFDTPwRETxVep6iKrpMgjw8H35e8rvtyBBxZvZ4Utkr65ZghtM5T76AvXhKird27BXskVIvZhHD3lTq3HHb+ACyilyKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5WBoEJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5WBoEJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFFEC433F1;
	Tue, 23 Jan 2024 02:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975510;
	bh=JURhskW7KAK3qIpRBal2k3uZa33LZP1eH10g7IfFn1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5WBoEJ1fVLxohQGk9bYdHtEusQe3S455guVA6mgh0RAT6qhS0nRgC81tdQs5gqKz
	 5fbNcAk8QL6ps75RWKt9GRWEHaUqxyxh1QUduikZU6y4xyi2PpozesMQYxyzpzClru
	 ERTzTpVW4wxA7gQgw+PVSOkqrRs2VpyiQzMyVLlk=
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
Subject: [PATCH 6.6 462/583] perf header: Fix segfault on build_mem_topology() error path
Date: Mon, 22 Jan 2024 15:58:33 -0800
Message-ID: <20240122235826.113286533@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d812e1e371a7..41032243774e 100644
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



