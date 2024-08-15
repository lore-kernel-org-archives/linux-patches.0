Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1D01DDF5;
	Thu, 15 Aug 2024 13:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728557; cv=none; b=ntIBA9ndJfHSX+mGa6k484+mSzdGp2DBfMaNC60HN0rAd/m1rlTt0Osd8ZHl+rGBlNXS9bYe37Mc38quB7Ar300RVFwU/WYU3QTVFsgHPBdFT/m/HoSwxeQdcsr72UqQ7G1TbwlxDMhWKP8TBrE8A2/99kkY2Qiko5KCvKGPh7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728557; c=relaxed/simple;
	bh=46/6/4JuQR+RJtY76M9IfNf0SpDQWxWN1zrqZr2KUNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCoFwU6BGF5KoAZfjaWfhAEIKS+6oP3qs6JIPGdaTMaI6MuK6uPVrBiIja3wphl1puxFgf1vPU3wZKE2ug9ygEsfulzVNaV/tcDYlKIGOBCG08oN5ip6qeeTfaR4VWwXmbgDWmFYaul2z21HnEgvsy7S7xh1RGr/HfC5M+zuh+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWk4zzK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWk4zzK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193ADC4AF0C;
	Thu, 15 Aug 2024 13:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728557;
	bh=46/6/4JuQR+RJtY76M9IfNf0SpDQWxWN1zrqZr2KUNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWk4zzK8oT4gvJzSAinf8qq/czlOZQyT3n8F+mZPlG8b44HWeplgE2agQ2jdVo2I0
	 ByKnTAL4QOSlDB9+TNC29MWLK4v4GOkcwAjdAZAM1z4T0u8WkMO7Oi6D7aJUMZIfHI
	 5czUY7TZZap8wHn8r3qRBpQX9ZYzb7NCTgAmyuC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/196] perf report: Fix condition in sort__sym_cmp()
Date: Thu, 15 Aug 2024 15:22:34 +0200
Message-ID: <20240815131853.506137953@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 66e11e6bb7197..a9a10cba8957e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -256,7 +256,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
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



