Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE5D2FE598;
	Tue, 12 Aug 2025 17:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021560; cv=none; b=CaZYnUyENeM/8Lhtbp/MDTe7+F4PC5itowTnnJP3RMctGNV1N4XVZ6etXhbEdCI0jhVABmzghLS/aYHKIiZjfDeNropllzBsiLrGO5PEV1Fr9vgLw7hBZFfXlEiXwLX1HZX4ZoXh6afAzoT7enhBz2Uc9dHD+X47f7IOBTE4BCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021560; c=relaxed/simple;
	bh=5ZO34abCiuwurgN2E4EK4DdqmVWzpHEiNHhWFSJI3ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzX6c+iddEGzk8AGl2oXjcQ3iYkYSENWS9Wwo7O41/Nj1Ipm9lY/WksT4SiKCngubOKCLRLu8zJu5Su5lqI+FEKrX5OC9+Ml7lP5R9Ls0Caehm4yDzqmUkZfxXWJjiswHUzRlxqlW/BLT+VhpSMpq0wqZIr1Be5xQRl+4M34tB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSLxZWst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSLxZWst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB5AC4CEFC;
	Tue, 12 Aug 2025 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021558;
	bh=5ZO34abCiuwurgN2E4EK4DdqmVWzpHEiNHhWFSJI3ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSLxZWstCHpI+Lbo8O3ph2MtbrACBpcQ6kJY+aGxaQ/Nxo1t6CqPzfsGSjBxZv7c0
	 ts78QCJlNpvBW9m32KtoO1HW8xWGVDMc0ZBd0f5mIlw+CWMvgQ8VTr5QI5EjVHrAMe
	 yiBdxIiEAxPO3oec0HXnvK/ooynenz5zxI+qvv6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/262] perf dso: Add missed dso__put to dso__load_kcore
Date: Tue, 12 Aug 2025 19:28:32 +0200
Message-ID: <20250812172958.386771625@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ea24f21aafc3..4f0bbebcb6d6 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1366,6 +1366,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 				goto out_err;
 			}
 		}
+		map__zput(new_node->map);
 		free(new_node);
 	}
 
-- 
2.39.5



