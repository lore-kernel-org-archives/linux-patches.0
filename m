Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B5030EF80;
	Tue, 16 Dec 2025 11:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885425; cv=none; b=Xs2icReGGPlBJ9ljMFgRXnFfRhOECEMbRl7pB3lTQRESzCUm8oMKw2aOrkuP3yjN8pEg6X+8USkcLOEFPnBb7BJySKdrc0IQRLjRZTdX+6NJEmfiZcplb1cPipXKAkYnu3+DAXA9S3pKTs9WPQsIGYoxJnJClzt36ca9nzea5UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885425; c=relaxed/simple;
	bh=aoEIya0OXSTMcXs8pkDizp4ZJwSMVcUJzDFSgbSXJ+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFHFNxhXK+GAqXXNmeEhRpVj+w5H2BYD105gbuvgm/qQ/uV8OU77OK3cMKa574WRnViddVjpRl4VlqQJD9FyiVwLU8ucpbGBt05gedFpQO5LnedcMol1avRqPlyYEJrrZ1kiYxlLb9q8ZN5Aply8DbWkzbdwN4YvqgnWSbtpFzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APBzYbTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APBzYbTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64848C4CEF1;
	Tue, 16 Dec 2025 11:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885424;
	bh=aoEIya0OXSTMcXs8pkDizp4ZJwSMVcUJzDFSgbSXJ+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APBzYbTvJ89QRkouXrOFHfwoT7aRGL7ThQVQVBJeu3yLXSvrP8f6ejT/K7mdcnb7L
	 2vgx/3FBFqnY7REYHnOVOtpbP5snAum/HXvEddFl5+f3KJhNxmHT2WWYWQGMF42rHZ
	 ajSYU/GxnMPkBVb6J8lq6uTiEYT1TWhcYc4nWemM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 102/507] perf hwmon_pmu: Fix uninitialized variable warning
Date: Tue, 16 Dec 2025 12:09:03 +0100
Message-ID: <20251216111349.233872848@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



