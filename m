Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7730C224234;
	Tue,  8 Apr 2025 11:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111711; cv=none; b=k0X2WAPFVxF1cnqY9S1COQ0O1Jh+9N+JRmY4Sg75NeJc6UZznST3KKkhMYSx9yg10nm/nyrJXdrtsqIORO6mEe9s265QIPBgR0QXfaicWtojA9iwouk974ePvlXtJvkaRsm/SLIz1Hevt2aiHkORxKz7qJ/WuUJbE/KzAqnQGFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111711; c=relaxed/simple;
	bh=32HxJG92hOYpj2vCRJ8TSb+hQkK+R9GYQ/cAK4sRimk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu8+UiEX6lYBrZcOIaeOMlE36Z/eUWCI/DAURf+t2rtdoPr3DbOaj06c6jYBXybTbcWAmzsST7UnfNVkZXQrACKF3PjsZTV5qfe0AaO/JXX+soWW3leTN3wwD95DZ6sRfJ7VQaztGDTbXPn4jA60mHldHLAqTyh2lhuanQ0glsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1vboluu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1vboluu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2991C4CEE5;
	Tue,  8 Apr 2025 11:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111711;
	bh=32HxJG92hOYpj2vCRJ8TSb+hQkK+R9GYQ/cAK4sRimk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1vboluuFA+QrpGN+adKHvtDvr+GxgjvjJ2bgJL+tZ5EPGqprxZhgTrhSSltyg1E5
	 YBmuSaCvhJFBMNMzk6WmXle4BmACJzKiwuqg4XL5gCj49MimemA7+EE40tBEbiK+M+
	 WBPabHJyVoI+XgiWi+J/YU8ko1rVwHwwZ/nvePEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 531/731] perf: intel-tpebs: Fix incorrect usage of zfree()
Date: Tue,  8 Apr 2025 12:47:08 +0200
Message-ID: <20250408104926.626608400@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit 6d2dcd635204c023eb5328ad7d38b198a5558c9b ]

zfree() requires an address otherwise it frees what's in name, rather
than name itself. Pass the address of name to fix it.

This was the only incorrect occurrence in Perf found using a search.

Fixes: 8db5cabcf1b6 ("perf stat: Fork and launch 'perf record' when 'perf stat' needs to get retire latency value for a metric.")
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250319101614.190922-1-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-tpebs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/intel-tpebs.c b/tools/perf/util/intel-tpebs.c
index 50a3c3e071606..2c421b475b3b8 100644
--- a/tools/perf/util/intel-tpebs.c
+++ b/tools/perf/util/intel-tpebs.c
@@ -254,7 +254,7 @@ int tpebs_start(struct evlist *evsel_list)
 		new = zalloc(sizeof(*new));
 		if (!new) {
 			ret = -1;
-			zfree(name);
+			zfree(&name);
 			goto err;
 		}
 		new->name = name;
-- 
2.39.5



