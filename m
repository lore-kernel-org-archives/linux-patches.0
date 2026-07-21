Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668434314A3;
	Tue, 21 Jul 2026 19:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662656; cv=none; b=Jky88wY5NaLPVDEIiIVi4sBDO2u1gDp4xTCGNIW1z2qMfJtefTTlilcxlPUX66e+GCPQclP+GKjzwG0fiQnQ/EDFSl3Fo2SPimKbzTRYuaT3xo5PmHLSlF7w2dfmj8VAfZGs/LIto691CmX44BXOmOYR5OwDtcIAC7wlKjeR2o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662656; c=relaxed/simple;
	bh=4RnEBYCZPvfFKfMQAkfo/uaZiaWcPzA7Ipc1tqPn9rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zp8R81VrD0bWVNiY/WPPuIq9WV66OkZ3Q3xLMTTtv5qvJlGrqpyd0gRGXryWWy8w8B31l5NwBclPGwzoc7T9U750OH6ToQoiBdbbPsq29gUt/oOdcsPb7in5qLmadmr/+x77MwXbS3PAj1LTMazzV8Zc9YbN/e/IrudtELrOLoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQIvB198; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQIvB198"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7D71F00A3A;
	Tue, 21 Jul 2026 19:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662655;
	bh=/xrMVjlQKo0Yzmq1/BBKEXfPI1vl+E1DeVAJMxn1uB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQIvB198dQPgbXkDRI1KrMTiVrBmCMiikdY8qJxdGQqqbVcf8FPXE4RRdq6dLB9Ah
	 kjS2o3gA86jx9qRyEMC3xBEe87He/8mmlEynnieYl1J4lPpo+c8l2jQCUNFp0lBbmg
	 /pkSwHq+aSVN+OGphn6m+qxGu0QGPd6xbA9j5s9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0527/1276] perf tools: Use snprintf() in dso__read_running_kernel_build_id()
Date: Tue, 21 Jul 2026 17:16:10 +0200
Message-ID: <20260721152457.913635476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 2ea64782a428bed74f595961e651ceb8c4c5bf22 ]

dso__read_running_kernel_build_id() uses sprintf() to format a sysfs
path from machine->root_dir into a PATH_MAX buffer.  If root_dir is
close to PATH_MAX in length, appending "/sys/kernel/notes" (18 bytes)
overflows the stack buffer.

Switch to snprintf() with sizeof(path) to prevent the overflow.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: cdd059d731eeb466 ("perf tools: Move dso_* related functions into dso object")
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 9792c8d38a314b..0c8492ea530fc1 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1676,7 +1676,7 @@ void dso__read_running_kernel_build_id(struct dso *dso, struct machine *machine)
 
 	if (machine__is_default_guest(machine))
 		return;
-	sprintf(path, "%s/sys/kernel/notes", machine->root_dir);
+	snprintf(path, sizeof(path), "%s/sys/kernel/notes", machine->root_dir);
 	sysfs__read_build_id(path, &bid);
 	dso__set_build_id(dso, &bid);
 }
-- 
2.53.0



