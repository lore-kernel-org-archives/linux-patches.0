Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6ED2CA9;
	Tue, 12 Aug 2025 18:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024374; cv=none; b=CN0gG1YUdVkQWp7CdTE6b4qoGgWE9eH/9Kaoo/EzhFaTMCUbz6cGt2TRLu1JHk50VpKmz7KrPM+SBUKBfBvTbIbOfGcZTu5Hsa6B/+nEer0DT4FeIy/wCD5lg3EI2Q42j+czlPRzJj+d7Pm6Kn6R1/gAc9z6b9G80jFxjmYggE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024374; c=relaxed/simple;
	bh=OfFbBPxvXS6FRWxBwZVw0EF68ohsJmVHvvQdLVwpsQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ok2LRMFJGezaWHlYv/BKTYxa7Ae3M+hKFXVXE6SYaJ3JzssUdajYtrHOlmapyvbMkeRa8A0hD5IrMbBIxyE3nbeX7ebMjkoarF0QvXKioKsqInaGmbEnYLzu+qhf6tmVhNIBMSHknVgiBx1lKVrWaQZFXyC6K+8BeuLu8r0jGKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Of4TPysE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Of4TPysE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C3AC4CEF0;
	Tue, 12 Aug 2025 18:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024374;
	bh=OfFbBPxvXS6FRWxBwZVw0EF68ohsJmVHvvQdLVwpsQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Of4TPysEQlPYAX11ncwLXP9Tfm8xqnvmkDhJaVzdEtzPJDDm5EC6aogzlx9uT+mv9
	 Zcr4GSpR2OWmYA0orVn/2RfloL71280b4XUJ3nxndxcl1s0zF8CtoPhtx4zB7YwJhJ
	 mU/v33OiO81M1TB8ZW0LCDKnVV1+1EISVl0Au0iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 355/627] perf dso: Add missed dso__put to dso__load_kcore
Date: Tue, 12 Aug 2025 19:30:50 +0200
Message-ID: <20250812173432.796910710@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 63a088e999de3f431f87d9a367933da894ddb613 ]

The kcore loading creates a set of list nodes that have reference
counted references to maps of the kcore. The list node freeing in the
success path wasn't releasing the maps, add the missing puts. It is
unclear why this leak was being missed by leak sanitizer.

Fixes: 83720209961f ("perf map: Move map list node into symbol")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250624190326.2038704-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8b30c6f16a9e..fd4583718eab 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1422,6 +1422,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 				goto out_err;
 			}
 		}
+		map__zput(new_node->map);
 		free(new_node);
 	}
 
-- 
2.39.5



