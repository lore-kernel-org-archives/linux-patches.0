Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A0C35CB7D;
	Tue, 16 Dec 2025 12:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887103; cv=none; b=rm5mq1EhPfdOG/m2jO2/DTQhFOjA/T9GOlOMnesK2Di39oZ17C3/V+H54S6Qqcib0nD0nKfVEqKMzofGdALRw97jAHL8L8R2n9edn6S1SPcArUA88jGfx9sMhi2Qy4epWa0HdvWrMbpLAWTV068lHepK2fUha89gMrpvUWsj7s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887103; c=relaxed/simple;
	bh=QahoTZWlxQMmlBBV3NE7rTJE2n9u41PR6EsD+KO5Mkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jBAD8fO+29iHva8k2Aa4DJzM2FQsvxqEj0gkeFfgCUwPVx0SsQsWl2m/VPaye1XvjAnH35J1d2BS+gQLjCbqaI4bm4znnlE6kSOntU4Hgl2GIyh+uhpv0x9E2fsiW0fqeyOhyxWkGbUjIF7e2f6JB+4pXIDgqolDubXgyEtFAUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCBuslM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCBuslM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C52C4CEF1;
	Tue, 16 Dec 2025 12:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887103;
	bh=QahoTZWlxQMmlBBV3NE7rTJE2n9u41PR6EsD+KO5Mkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCBuslM3MkRWIfmAutpWJIFjZMwKL6T4xO6OcFH+jRr1PyQSMipW4dI1fEAxB12Ww
	 LiImK5s0Isj969j03+Uy/Cigan0E069+TUX5odG4+ufi3/H+eEvxSxTgv0vI603vML
	 NbX/ahdDF1T/RPbo4VhliW4gfcBBKm17afO1yhWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/614] perf hwmon_pmu: Fix uninitialized variable warning
Date: Tue, 16 Dec 2025 12:08:13 +0100
Message-ID: <20251216111405.902034066@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 2fee899c068c159e486e62623afe9e2a4975bd79 ]

The line_len is only set on success. Check the return value instead.

 util/hwmon_pmu.c: In function ‘perf_pmus__read_hwmon_pmus’:
 util/hwmon_pmu.c:742:20: warning: ‘line_len’ may be used uninitialized [-Wmaybe-uninitialized]
   742 |                 if (line_len > 0 && line[line_len - 1] == '\n')
       |                    ^
 util/hwmon_pmu.c:719:24: note: ‘line_len’ was declared here
   719 |                 size_t line_len;

Fixes: 53cc0b351ec9 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index 416dfea9ffff6..5c27256a220a5 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -742,8 +742,7 @@ int perf_pmus__read_hwmon_pmus(struct list_head *pmus)
 			continue;
 		}
 		io__init(&io, name_fd, buf2, sizeof(buf2));
-		io__getline(&io, &line, &line_len);
-		if (line_len > 0 && line[line_len - 1] == '\n')
+		if (io__getline(&io, &line, &line_len) > 0 && line[line_len - 1] == '\n')
 			line[line_len - 1] = '\0';
 		hwmon_pmu__new(pmus, buf, class_hwmon_ent->d_name, line);
 		close(name_fd);
-- 
2.51.0



