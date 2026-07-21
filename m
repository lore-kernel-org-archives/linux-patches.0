Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6543EBF02;
	Tue, 21 Jul 2026 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657238; cv=none; b=rYOFnb/54BgLZOxPWbYBjieOAidssky0nZXPk2m9Is7L0hboqBN7211ELC6/PHftlbNd5oegWexGOJwpR6kUUUUXZQlEdDhe+idP5jFRbCRT+88ttjIaopPNM4tVw6IkiLv+NIWxg01DDOktE91oa8LOkLw6HI/Ld1D5yosJVZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657238; c=relaxed/simple;
	bh=ejCf9URF1Fh9nwki9j63OSXDRbXi8g4L84592e2f3xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Awu01Mb3ur1dZ9BrzYZHb7tz9FcskIGmLzN3jR4L7nvg3vKDF6DLWqxCLUqyNeYAJ5g4Rv64UKNmOT+omRPZE92eVa5+8Lz9WZ8d9TtP0FbhHowDUR1yZ/JBW47w8HA+ov/nX3ukh1oSl4oeu4aByLAZn/GL1oI8jGJQOAMlHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFf1FtXp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFf1FtXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705881F000E9;
	Tue, 21 Jul 2026 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657236;
	bh=iF7ctUEm70Mlohx64fcrQJZeZaQjja9v0R+/brp7qTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFf1FtXpZ4Ty7uYrGX7SoZTvi4DEPlfNCLNxquftlh+x8MkpAiarwF1ok3rxM0Wyq
	 pRQit/OrqfecKwyFgPi+xIQuKcNggswVNw80DgW3s9VwKko1JuozJGnzLmnvb8IERV
	 UYzOwphfdqGHNFk7fXk+MTBtY6Cw7gjveEo1I5Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Don Zickus <dzickus@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0688/1611] perf tools: Fix get_max_num() size_t underflow on empty sysfs file
Date: Tue, 21 Jul 2026 17:13:24 +0200
Message-ID: <20260721152530.856323007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 0a012113bb3a44482c163f16f4db03ccaa37a339 ]

get_max_num() reads a sysfs file (cpu/possible, cpu/present, or
node/possible) and scans backward from the end to find the last
number.  If the file is empty, filename__read_str() returns num == 0.
The loop `while (--num)` decrements the size_t from 0 to SIZE_MAX,
reading backward across the heap until a comma or hyphen is found
or unmapped memory is hit.

Add an early return for empty files before the backward scan.

Fixes: 7780c25bae59fd04 ("perf tools: Allow ability to map cpus to nodes easily")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cpumap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index d0516797a00881..bbf959b443ab1f 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -420,6 +420,12 @@ static int get_max_num(char *path, int *max)
 
 	buf[num] = '\0';
 
+	/* empty file — nothing to parse */
+	if (num == 0) {
+		err = -1;
+		goto out;
+	}
+
 	/* start on the right, to find highest node num */
 	while (--num) {
 		if ((buf[num] == ',') || (buf[num] == '-')) {
-- 
2.53.0



