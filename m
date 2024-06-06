Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE81B4C4D;
	Thu,  6 Jun 2024 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683450; cv=none; b=sKepcpMjeMotATzUekh+dgHmYMdDR1HZG/s7jMmD6ojECpBHOh2uqmU4+IL02g+3BgK4VtiZD8vErI9rt28aVsmsMCjgrG5HcFVNszhS85MbaE4dK0lpyiNKPVMxuiziRIxvh0ZfYtJobx5dvjzsOgLG/Cbdb6z1j4R5T7lYttk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683450; c=relaxed/simple;
	bh=iIdxwHVxTvDOSzQ4Ug2cpFlm3CZqOST5sLA6ywPdcIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA5cu6RavvJIsa3di1MKilcxR7ojTH+k3MFtA6x5b+u+Tu0tgjpI8EoU5SVAA/8POjxlfZXeSpczaTPdUPvVf0MpbEeIuOSJNuJN7FsOcaaURkmVUsUdC+9ZlPPRSiOMT/4Ju9EtuySjuiop8/73YyxcTqkKuY2EIN6qGl2iCeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zacf3qws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zacf3qws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63843C2BD10;
	Thu,  6 Jun 2024 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683450;
	bh=iIdxwHVxTvDOSzQ4Ug2cpFlm3CZqOST5sLA6ywPdcIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zacf3qwsBuBRiLqfE/PNvRT4n3yANUe/HH4cSOxew8RVJLZN7kVy/BtJx5rw2jEcv
	 Vk5OpzVF6sHFIMu9YUwvveJ2JGdA9OFBUMa78aIfbiBWCjxPa71Ybt8YixEeA9mabl
	 McdIYqhHsWsqSUU1xTJD+Y92C5eZFhBLrDYQWljo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Zhe <zhe.he@windriver.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 334/473] perf bench internals inject-build-id: Fix trap divide when collecting just one DSO
Date: Thu,  6 Jun 2024 16:04:23 +0200
Message-ID: <20240606131710.966475318@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: He Zhe <zhe.he@windriver.com>

[ Upstream commit d9180e23fbfa3875424d3a6b28b71b072862a52a ]

'perf bench internals inject-build-id' suffers from the following error when
only one DSO is collected.

  # perf bench internals inject-build-id -v
    Collected 1 DSOs
  traps: internals-injec[2305] trap divide error
  ip:557566ba6394 sp:7ffd4de97fe0 error:0 in perf[557566b2a000+23d000]
    Build-id injection benchmark
    Iteration #1
  Floating point exception

This patch removes the unnecessary minus one from the divisor which also
corrects the randomization range.

Signed-off-by: He Zhe <zhe.he@windriver.com>
Fixes: 0bf02a0d80427f26 ("perf bench: Add build-id injection benchmark")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240507065026.2652929-1-zhe.he@windriver.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/inject-buildid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/bench/inject-buildid.c b/tools/perf/bench/inject-buildid.c
index 17672790f1231..d1672be702f3b 100644
--- a/tools/perf/bench/inject-buildid.c
+++ b/tools/perf/bench/inject-buildid.c
@@ -361,7 +361,7 @@ static int inject_build_id(struct bench_data *data, u64 *max_rss)
 		return -1;
 
 	for (i = 0; i < nr_mmaps; i++) {
-		int idx = rand() % (nr_dsos - 1);
+		int idx = rand() % nr_dsos;
 		struct bench_dso *dso = &dsos[idx];
 		u64 timestamp = rand() % 1000000;
 
-- 
2.43.0



