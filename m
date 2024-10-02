Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECF11D04A0;
	Wed,  2 Oct 2024 13:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876191; cv=none; b=V4tw/RkoCT/2RfBl2zYhAfqRWI+LbzqM4pk+f17gNxOSdmWb4q5qXzRW8dFSqQm1GCtcEcV3CDpBQz3/7awfSDtcjzVpPUaFGqW+xQ5fOWRIAzQs3kuFZMEofwhkoDutYw2X3UzKhjy27WKR+VIBOqH6wKCk4wSykDvIkILbtRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876191; c=relaxed/simple;
	bh=OQu7mUI8bvjw4Z2nU2LSkXCAdliyWLHxedqOhkCjngE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRBm3k8bhLfJH0n7EWD3pm+itz3s5pZSScGFgNX0IVt/vSVD8AAvrdrE7Pfw/zVRapJe5GYuW0USrSh1zNtL2gAn63dVDR4WE4LnWrb4BmK/mtbwlbz2mUrWq5bf34HzyqYopg+DUlaykehdtTU3h6SZduNKb7fV8M1vLFGpLMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhSwSxbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhSwSxbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16F9C4CECD;
	Wed,  2 Oct 2024 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876191;
	bh=OQu7mUI8bvjw4Z2nU2LSkXCAdliyWLHxedqOhkCjngE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhSwSxbCGmHAPfRcJZkJrLDgVZTYUmiX7DmiYgfA4MDVpNPfyV/+NNz3HhsaCeRM4
	 Lod8GiDyCB+5CSv9Kh97UAY0EZmxMX0teLaxqxrfVIBtXQEqyqmuOJDzNiuIkFB+NA
	 14nbBluqjAbo6jsIcs2m3ffDnNaCvcKDK/NNxKxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jiri Olsa <jolsa@redhat.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 329/695] perf inject: Fix leader sampling inserting additional samples
Date: Wed,  2 Oct 2024 14:55:27 +0200
Message-ID: <20241002125835.581355854@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 79bcd34e0f3da39fda841406ccc957405e724852 ]

The processing of leader samples would turn an individual sample with
a group of read values into multiple samples. 'perf inject' would pass
through the additional samples increasing the output data file size:

  $ perf record -g -e "{instructions,cycles}:S" -o perf.orig.data true
  $ perf script -D -i perf.orig.data | sed -e 's/perf.orig.data/perf.data/g' > orig.txt
  $ perf inject -i perf.orig.data -o perf.new.data
  $ perf script -D -i perf.new.data | sed -e 's/perf.new.data/perf.data/g' > new.txt
  $ diff -u orig.txt new.txt
  --- orig.txt    2024-07-29 14:29:40.606576769 -0700
  +++ new.txt     2024-07-29 14:30:04.142737434 -0700
  ...
  -0xc550@perf.data [0x30]: event: 3
  +0xc550@perf.data [0xd0]: event: 9
  +.
  +. ... raw event: size 208 bytes
  +.  0000:  09 00 00 00 01 00 d0 00 fc 72 01 86 ff ff ff ff  .........r......
  +.  0010:  74 7d 2c 00 74 7d 2c 00 fb c3 79 f9 ba d5 05 00  t},.t},...y.....
  +.  0020:  e6 cb 1a 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  +.  0030:  02 00 00 00 00 00 00 00 76 01 00 00 00 00 00 00  ........v.......
  +.  0040:  e6 cb 1a 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  +.  0050:  62 18 00 00 00 00 00 00 f6 cb 1a 00 00 00 00 00  b...............
  +.  0060:  00 00 00 00 00 00 00 00 0c 00 00 00 00 00 00 00  ................
  +.  0070:  80 ff ff ff ff ff ff ff fc 72 01 86 ff ff ff ff  .........r......
  +.  0080:  f3 0e 6e 85 ff ff ff ff 0c cb 7f 85 ff ff ff ff  ..n.............
  +.  0090:  bc f2 87 85 ff ff ff ff 44 af 7f 85 ff ff ff ff  ........D.......
  +.  00a0:  bd be 7f 85 ff ff ff ff 26 d0 7f 85 ff ff ff ff  ........&.......
  +.  00b0:  6d a4 ff 85 ff ff ff ff ea 00 20 86 ff ff ff ff  m......... .....
  +.  00c0:  00 fe ff ff ff ff ff ff 57 14 4f 43 fc 7e 00 00  ........W.OC.~..
  +
  +1642373909693435 0xc550 [0xd0]: PERF_RECORD_SAMPLE(IP, 0x1): 2915700/2915700: 0xffffffff860172fc period: 1 addr: 0
  +... FP chain: nr:12
  +.....  0: ffffffffffffff80
  +.....  1: ffffffff860172fc
  +.....  2: ffffffff856e0ef3
  +.....  3: ffffffff857fcb0c
  +.....  4: ffffffff8587f2bc
  +.....  5: ffffffff857faf44
  +.....  6: ffffffff857fbebd
  +.....  7: ffffffff857fd026
  +.....  8: ffffffff85ffa46d
  +.....  9: ffffffff862000ea
  +..... 10: fffffffffffffe00
  +..... 11: 00007efc434f1457
  +... sample_read:
  +.... group nr 2
  +..... id 00000000001acbe6, value 0000000000000176, lost 0
  +..... id 00000000001acbf6, value 0000000000001862, lost 0
  +
  +0xc620@perf.data [0x30]: event: 3
  ...

This behavior is incorrect as in the case above 'perf inject' should
have done nothing. Fix this behavior by disabling separating samples
for a tool that requests it. Only request this for `perf inject` so as
to not affect other perf tools. With the patch and the test above
there are no differences between the orig.txt and new.txt.

Fixes: e4caec0d1af3d608 ("perf evsel: Add PERF_SAMPLE_READ sample related processing")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240729220620.2957754-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-inject.c | 1 +
 tools/perf/util/session.c   | 3 +++
 tools/perf/util/tool.h      | 1 +
 3 files changed, 5 insertions(+)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index a212678d47beb..c80fb0f60e611 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -2204,6 +2204,7 @@ int cmd_inject(int argc, const char **argv)
 			.finished_init	= perf_event__repipe_op2_synth,
 			.compressed	= perf_event__repipe_op4_synth,
 			.auxtrace	= perf_event__repipe_auxtrace,
+			.dont_split_sample_group = true,
 		},
 		.input_name  = "-",
 		.samples = LIST_HEAD_INIT(inject.samples),
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5596bed1b8c83..080242c691969 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1511,6 +1511,9 @@ static int deliver_sample_group(struct evlist *evlist,
 	int ret = -EINVAL;
 	struct sample_read_value *v = sample->read.group.values;
 
+	if (tool->dont_split_sample_group)
+		return deliver_sample_value(evlist, tool, event, sample, v, machine);
+
 	sample_read_group__for_each(v, sample->read.group.nr, read_format) {
 		ret = deliver_sample_value(evlist, tool, event, sample, v,
 					   machine);
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index c957fb849ac63..62bbc9cec151b 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -85,6 +85,7 @@ struct perf_tool {
 	bool		namespace_events;
 	bool		cgroup_events;
 	bool		no_warn;
+	bool		dont_split_sample_group;
 	enum show_feature_header show_feat_hdr;
 };
 
-- 
2.43.0



