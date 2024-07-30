Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A171A617E;
	Tue, 30 Jul 2024 16:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357174; cv=none; b=pwlAgBrNXuk7idAbZsRJK5KTS7IzVJZcGensfj1Jjq0M3PG1W9C+wMNFNws3+2eXW8DaNZuXhQd13je+oQRma8W0mAMfrq2AX6Hify0tPx0EGXG530PY9sFxH6cFKnRx0RLfqyFk+p4LzZk3NOnY/yjdE1V0+DHFaUZxBLh4ask=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357174; c=relaxed/simple;
	bh=7Ro0TYMIChv1dWNu+o+0bp+BO6qcr0/tGVDoFgdOVEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSaBX9Mz9B7k0eQ1Mb2Afhy28YLbkKdGnmgiBWGhX/U4i9Jt1g3MtLgz8JjZQd+gxvM2nw/sd9M5+F8e1sg4KqUZe0lO4lL718W/w5Eijv8zI+pTEf62nNzpznS4SRaFHeWPag70gvNZf8M/QQZ1aWTXKYhGSA8oSwSYzkkKcxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8icXDqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8icXDqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF60EC32782;
	Tue, 30 Jul 2024 16:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357174;
	bh=7Ro0TYMIChv1dWNu+o+0bp+BO6qcr0/tGVDoFgdOVEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8icXDqquHrIzE2/U8N/htPdndbNMZIeDv6ufZMN7M0RJEi1+pqo+Xt1mNBPKqQU+
	 jjZTH3XEk/zUVVPN9h2LuTUEx4yd+m2BGwiua6b8bJtBKyG/4FjePVhC/WWdNyHyCT
	 rijEbMWs+1y1g1KktTgR+hCz5ekl2LRTK7xlED9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/568] perf report: Fix condition in sort__sym_cmp()
Date: Tue, 30 Jul 2024 17:45:33 +0200
Message-ID: <20240730151648.716750483@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6aa1c7f2b4448..6ab8147a3f870 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -332,7 +332,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
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



