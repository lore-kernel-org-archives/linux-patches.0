Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E5263D5;
	Thu, 15 Aug 2024 14:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732230; cv=none; b=VXQo4eQlOlC8AQQqV4zqIaYu90zr8FtweiWPuo86tSAwjMPlx4ClM2Smupii7fba1az7XU79egfM1JsS9PGWOgOOAsAJ3CJdb0bJG2sRPIwEMcMUesTTjurrVURtNIvv0qD9ZNNDagLBXWAIaNVI4eFaopITU7ZlHg7Gg4doXAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732230; c=relaxed/simple;
	bh=KjZTHbZMkmSxzeDiWiipFrP0m705ML2UBWSbq56PwXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfggxTOWSZQZ0+8ovMr0ceMrqIs3oKbO7buiZAR7JqrGUNuVKmKkP/LP/Cj3Z3fGKY046y4E8/cvyGvZfx4HjjLliYtNo0roFvRmBCqEVFjSfMP5jiUw/UiyZI1JRW0rPoNSjri8pWF3MmCdLcS0OHx3NDOyfZ5D3t9bUN1Oy0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8D9z8xE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8D9z8xE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15149C4AF0F;
	Thu, 15 Aug 2024 14:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732230;
	bh=KjZTHbZMkmSxzeDiWiipFrP0m705ML2UBWSbq56PwXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8D9z8xED6iA+d/62cshbe+82HZaR+jX0RrrEspprn8xFfL0nCTqg0jpMibwlDv2y
	 H/cLzLDyfYw32bP4Jk5IqP+98GnUZUQN3zNXVFa1cZGuOPSFu1LbEvzzgki+Hg248e
	 ehKhXQyXNbAvycwBI6RidEGLbJGRtSmcToQ0LF/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/352] perf report: Fix condition in sort__sym_cmp()
Date: Thu, 15 Aug 2024 15:22:29 +0200
Message-ID: <20240815131922.455622531@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 42806102010bb..bbebb1e51b88f 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -272,7 +272,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
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



