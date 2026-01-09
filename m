Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4181631E107;
	Fri,  9 Jan 2026 12:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961919; cv=none; b=ind0318VBRJ/jyfteqc3s+/DQ2e9I975peZyiLsSV2CONSxzO71szyaPeF0adhRjZMvbA6bfYWLvvBG7OFJO+ENRdknkIixiEVaNN6wwa641GBvR+97xcA4EknDjr5t3+dRQRN5ASsU6A1Eb4VxfdLdl6Alqco9oWpaxGcNY2T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961919; c=relaxed/simple;
	bh=REvPdTFikimdtVPW4cWz8/A2vFH0mfIqqPEeCrw8uUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNZ80w/bnxyMvWjwzx90XMT+j6aY6jxh7Q1RQptE2WvgW+D8V4XrGWlRA0fSWwSKklKmSYHNWtoAmhp6WRTeZqDkrwu7RqNpjSCNKcucC3NJJ8GczRroriH/wuv6+immkw3DZAb/Ruo1HvUdkiWyIViTJQLlZmZc0mIPFDeKe40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcBMUyCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcBMUyCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47A2C4CEF1;
	Fri,  9 Jan 2026 12:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961919;
	bh=REvPdTFikimdtVPW4cWz8/A2vFH0mfIqqPEeCrw8uUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcBMUyCMX5fDmhXG7Bu0g8oyhBBu9CnBByjQ5v96i5OVY4yvzjdw8tvirbbr5hiFj
	 Qy5m6MAnazeYq0lNuNtutrb/OiXk3mMVqSQWL1zVf8UBB78QeMvOH4Wu8lw6NmZTiK
	 Wihqs/3yipE6J8FNadkZTqbBndz2GFwCE0YWwJDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/634] perf tools: Fix split kallsyms DSO counting
Date: Fri,  9 Jan 2026 12:37:41 +0100
Message-ID: <20260109112124.327216561@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 98014f9375686..b434f2398df5a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -904,11 +904,11 @@ static int maps__split_kallsyms(struct maps *kmaps, struct dso *dso, u64 delta,
 			if (dso->kernel == DSO_SPACE__KERNEL_GUEST)
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
 			if (ndso == NULL)
-- 
2.51.0



