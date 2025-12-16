Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0703563D0;
	Tue, 16 Dec 2025 12:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886523; cv=none; b=nWRv3BhNcC2RSE7UtmVEaHGYePRMZscL4vJVBxgSQuXCxeVZHysXahCpZAZ0B8IcTAOg+aXOgsZ21+63bS8HIaf5AmCBBkHh4wcRNApxRvhTdxc7FdLj8hZAWw3WvPwQobUof/2aCQcCQOIrtuc///XDOE2PwStTPPEcfpd0UAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886523; c=relaxed/simple;
	bh=neBI4C6mfhGo2YwbAD1VcK3dZXYeBcs9f3MQ9hjc6Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJ5Tv2RIpaEnxNLBFQrG4shjEnZMJ0+RDbb36m6oAnFk5qGfweEW8zsO+4grO4i+R6tVShl5qeR9w52zFd22Vwf6OHxLHVCNWFUiMs07VUHbpu4FZLk+qHy6ZbsM2C3Jsd9UUwsndLf+V4K/+56FUuje3g0tVBlLPtkxoefoC7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jleOrCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jleOrCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC89C4CEF1;
	Tue, 16 Dec 2025 12:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886522;
	bh=neBI4C6mfhGo2YwbAD1VcK3dZXYeBcs9f3MQ9hjc6Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jleOrCzbNpqyhq2SNGM7ZSSCjj6xcuqF02mQhqQyRS7WilfvrBg3Z6nFxOuU01TU
	 AwLkwUIlYq3vNw1SDmYYNEYRQPB9gSmfjzKy1/vIh/kBUf14c4xA7LCE0l5IGXejmD
	 mDT2tsL5z5v2URr5NFaI+dTZFAFYgT6/TOFTfT5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 428/507] perf tools: Fix split kallsyms DSO counting
Date: Tue, 16 Dec 2025 12:14:29 +0100
Message-ID: <20251216111400.966961171@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit ad0b9c4865b98dc37f4d606d26b1c19808796805 ]

It's counted twice as it's increased after calling maps__insert().  I
guess we want to increase it only after it's added properly.

Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 2e538c4a1847291cf ("perf tools: Improve kernel/modules symbol lookup")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 93c81c65b6c40..dfa8340eeaf8c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -955,11 +955,11 @@ static int maps__split_kallsyms(struct maps *kmaps, struct dso *dso, u64 delta,
 			if (dso__kernel(dso) == DSO_SPACE__KERNEL_GUEST)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
-					kernel_range++);
+					kernel_range);
 			else
 				snprintf(dso_name, sizeof(dso_name),
 					"[kernel].%d",
-					kernel_range++);
+					kernel_range);
 
 			ndso = dso__new(dso_name);
 			map__zput(curr_map);
-- 
2.51.0



