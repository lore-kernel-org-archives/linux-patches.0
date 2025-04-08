Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E64A267731;
	Tue,  8 Apr 2025 12:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114856; cv=none; b=Jx5u+nKy3Ln7ENCrm5AMnq2kU0a/AoXLHL+pWhpV9QQAM2Kas3ecvVG1/kgQI/6i3fsSXfWDj9IpfK46aDCKoNcIbEzlcBy7itQKv9lZDnU3rRLP3QU5xRuhe/QUxKs5UjOs0Fct2NgAJUwtwo10/ZM8haZksKJVID9mp5NLLQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114856; c=relaxed/simple;
	bh=2q29jxExubdqLbHAGl1rFaOchh+kNnbxAjr/OyhMS+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0b2/DR6FCmg6B6xnmm5+MjuYP2S0c/U3uYSe+9iPCS9/rGXnQ5bkZ5QiyTJB1smBPHJ2GoXE8cZ4yUk2LOLYHoortjEBW2te23L1/J5CBs3bbKquohfpnzPe4K+j6V4tm/UCmkPOW8UxyD2R/zdv/gKT46YStKncJDaU4RVVDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pc+oBnuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pc+oBnuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96040C4CEE5;
	Tue,  8 Apr 2025 12:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114855;
	bh=2q29jxExubdqLbHAGl1rFaOchh+kNnbxAjr/OyhMS+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pc+oBnuKCXyrt3bPJvT850euB0BHlCC5RQcgSr7Hpo676L8B0OG5sLcPc38nhmZPP
	 LbmghsitlFJU9NYDNWYmE9qv9VKb08x2UE5f2DqEiqrCTl80r9c7HxOj/dqvVLk/GJ
	 mejFrDjMEB3TVPB5ashkfYQcZ9NJwMFj+813xzi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 261/499] perf: intel-tpebs: Fix incorrect usage of zfree()
Date: Tue,  8 Apr 2025 12:47:53 +0200
Message-ID: <20250408104857.722962410@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



