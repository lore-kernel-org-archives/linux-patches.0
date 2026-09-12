Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D211C3644CA;
	Sat, 12 Sep 2026 07:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198944; cv=none; b=AOz3pCiqM8/YPcjfeaV3Bv1H1CKl5glvZ4a0gtKxdA2jhbcTyMNT3V1gm+kI+uYS2cDkdJH/VqiH+WYqI+OkUYH4KmYvlD1ilkdzTA81TANTcXYBqvCcc1dXNQa4Yj2MsIPazu4XlGTkiC6enBO4KpkBfDr4h3NiLfDRPM02ems=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198944; c=relaxed/simple;
	bh=V9HQLf7fWG/lkhgqKV5aZYLGAju9af/usprueNIcSpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8CvTmuNclfFGLXEOtgscNhjuV+9v4gQLfVnWbWCqXIgr57i2GCPMBw9TNNdjI7hEoWXWDB/G97FuBqdzTL5R6tYei1l59PedinMEyglUVFu16r3xzjcNJ1KEbIdjkhlPMh5fKJ8loqsbZvvSI+8lTvernahBO15HdhoDzBgS68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z61qu/IW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z61qu/IW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5401F000FF;
	Sat, 12 Sep 2026 07:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198942;
	bh=h4cktJCLXEXzssIm5KCq72WWs0He109XrWLZEMyzWS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z61qu/IW+MMzZEqJ0qBqoEs37BXGRmxZgwVRRQ1Yv17LEA6DgzuMimahv/sCEiY2p
	 V5LtS5zCg96RZzyk+aeuD/XJo46EEUThDAsX9ZL1Ls9TgdHTEJk8PQhEvf5D1pS05Q
	 3NXxlmCwqbv9DWjbkSsbkvcDPdouveGQRcVEs65s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Swapnil Sapkal <swapnil.sapkal@amd.com>
Subject: [PATCH 7.2 0457/1815] perf sched: Free subcommand string after perf sched stats
Date: Sat, 12 Sep 2026 08:36:47 +0200
Message-ID: <20260912065659.616854999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit e1f522ac439f94d56cf0d9a3c82d1953646d377a ]

The first entry of the sched_usage is dynamically allocated in
parse_options_subcommand() so it should be released at the end.
Do not return from a subcommand directly.

Fixes: 064790a3d4a8 ("perf sched stats: Add support for diff subcommand")
Reviewed-and-tested-by: Swapnil Sapkal <swapnil.sapkal@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 11db64ac1c122..ca506cad0534d 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -5255,19 +5255,20 @@ int cmd_sched(int argc, const char **argv)
 			if (argc)
 				argc = parse_options(argc, argv, stats_options,
 						     stats_usage, 0);
-			return perf_sched__schedstat_record(&sched, argc, argv);
+			ret = perf_sched__schedstat_record(&sched, argc, argv);
 		} else if (argv[0] && !strcmp(argv[0], "report")) {
 			if (argc)
 				argc = parse_options(argc, argv, stats_options,
 						     stats_usage, 0);
-			return perf_sched__schedstat_report(&sched);
+			ret = perf_sched__schedstat_report(&sched);
 		} else if (argv[0] && !strcmp(argv[0], "diff")) {
 			if (argc)
 				argc = parse_options(argc, argv, stats_options,
 						     stats_usage, 0);
-			return perf_sched__schedstat_diff(&sched, argc, argv);
+			ret = perf_sched__schedstat_diff(&sched, argc, argv);
+		} else {
+			ret = perf_sched__schedstat_live(&sched, argc, argv);
 		}
-		return perf_sched__schedstat_live(&sched, argc, argv);
 	} else {
 		usage_with_options(sched_usage, sched_options);
 	}
-- 
2.53.0



