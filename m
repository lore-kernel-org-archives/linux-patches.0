Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04207DA9E;
	Thu, 15 Aug 2024 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729551; cv=none; b=evRV5QF8cgvtwyikGTLGvQ2g+P1S0aSsuhNFBGy5bFl7CgV8rPB3d/moX9kOLWneUxA3EaQISKyK5BCg2ZeM9NW/YrM4CV2SIOaP+jZ3FDuFAt6cNdhS4LQyds0dD60TjqyO59qd3O6XTgTDnCf8BLkMLpe7ewAxYy1027anwIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729551; c=relaxed/simple;
	bh=uOAbyTAIuq+dzUxFQf8QolYu88ThFg14u86tfGtFEUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bf+tOrmYuj9LqOfc1jRjgTzvr9PPu5ugnlDEVpylHHSZbBlcWvMGs9yJLixqNtBj89q6zcOPuTeTd+ZwDdQhDKzBFX9MpgCi9Smpm6tLREsV3oK6gmYhwq2jE4jSfhrEYdFd9EQw+unbzVQxq1N3eioA5hE2Z0IO6CnsSRWQmQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymhZQ5lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymhZQ5lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BB1C32786;
	Thu, 15 Aug 2024 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729550;
	bh=uOAbyTAIuq+dzUxFQf8QolYu88ThFg14u86tfGtFEUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymhZQ5luwZkCkIwTkq7FSG7eyMPUueRmkPdT16CkHgE9c2zPtoQ01FAV+qHOVQNbP
	 124sUqGPZBK3LZvHXy8IdROkBF23h/jdCTq67jyGZxIOPdZXY9pXAwA8zTw7G+yWyK
	 2AC6mfr694lsFURdUrEHp2+qjqoLwIt2XReciKZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/484] perf report: Fix condition in sort__sym_cmp()
Date: Thu, 15 Aug 2024 15:19:20 +0200
Message-ID: <20240815131945.236298204@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit cb39d05e67dc24985ff9f5150e71040fa4d60ab8 ]

It's expected that both hist entries are in the same hists when
comparing two.  But the current code in the function checks one without
dso sort key and other with the key.  This would make the condition true
in any case.

I guess the intention of the original commit was to add '!' for the
right side too.  But as it should be the same, let's just remove it.

Fixes: 69849fc5d2119 ("perf hists: Move sort__has_dso into struct perf_hpp_list")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240621170528.608772-2-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a4f2ffe2bdb6d..d5133786d3e17 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -275,7 +275,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	 * comparing symbol address alone is not enough since it's a
 	 * relative address within a dso.
 	 */
-	if (!hists__has(left->hists, dso) || hists__has(right->hists, dso)) {
+	if (!hists__has(left->hists, dso)) {
 		ret = sort__dso_cmp(left, right);
 		if (ret != 0)
 			return ret;
-- 
2.43.0



