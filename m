Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E08B8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F35EC433EF;
	Fri, 10 Mar 2023 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460105;
	bh=+gG78ObpD8v6Uhmrv4zUkPa2t7eYN91BNznaEBr2Ekw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/hwuMQIYHzBI69YkZG+lP2Abl3GXz9zU8ZTzHQm7oZ/TA5m4rS394TH9AwwF1K7M
	 upXJXtUZWn3qR1y2iL1S1yLjoW9puHWqU8ysCMvNMF43togptkcO7FqlhdOW6JoSVy
	 XO8yw8La/EI/qYsXeNa3wejZIjrx86256reXsdUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jin Yao <yao.jin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-arm-kernel@lists.infradead.org,
	linuxarm@huawei.com,
	prime.zeng@hisilicon.com,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/529] perf tools: Fix auto-complete on aarch64
Date: Fri, 10 Mar 2023 14:36:08 +0100
Message-Id: <20230310133815.427518452@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit ffd1240e8f0814262ceb957dbe961f6e0aef1e7a ]

On aarch64 CPU related events are not under event_source/devices/cpu/events,
they're under event_source/devices/armv8_pmuv3_0/events on my machine.
Using current auto-complete script will generate below error:

  [root@localhost bin]# perf stat -e
  ls: cannot access '/sys/bus/event_source/devices/cpu/events': No such file or directory

Fix this by not testing /sys/bus/event_source/devices/cpu/events on
aarch64 machine.

Fixes: 74cd5815d9af6e6c ("perf tool: Improve bash command line auto-complete for multiple events with comma")
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxarm@huawei.com
Cc: prime.zeng@hisilicon.com
Link: https://lore.kernel.org/r/20230207035057.43394-1-yangyicong@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/perf-completion.sh | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index fdf75d45efff7..978249d7868c2 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -165,7 +165,12 @@ __perf_main ()
 
 		local cur1=${COMP_WORDS[COMP_CWORD]}
 		local raw_evts=$($cmd list --raw-dump)
-		local arr s tmp result
+		local arr s tmp result cpu_evts
+
+		# aarch64 doesn't have /sys/bus/event_source/devices/cpu/events
+		if [[ `uname -m` != aarch64 ]]; then
+			cpu_evts=$(ls /sys/bus/event_source/devices/cpu/events)
+		fi
 
 		if [[ "$cur1" == */* && ${cur1#*/} =~ ^[A-Z] ]]; then
 			OLD_IFS="$IFS"
@@ -183,9 +188,9 @@ __perf_main ()
 				fi
 			done
 
-			evts=${result}" "$(ls /sys/bus/event_source/devices/cpu/events)
+			evts=${result}" "${cpu_evts}
 		else
-			evts=${raw_evts}" "$(ls /sys/bus/event_source/devices/cpu/events)
+			evts=${raw_evts}" "${cpu_evts}
 		fi
 
 		if [[ "$cur1" == , ]]; then
-- 
2.39.2



