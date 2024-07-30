Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DFA189502;
	Tue, 30 Jul 2024 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358377; cv=none; b=H7LCkGPSXrN8CGFLp+reYQzu22nLoEm9NpNSZuNQg1mj5nDCMAnqnv+NMOgmK7Rlv79wcOLs1qUkeEqUzKAATXzSk2fipyhBX4D8ol0YmDZb3XpoeUaYrmtB+Q5WkDDg2RYL758qMEwRXEzAnyC2BoqSlNvmEsxDFm+7s5Tpo9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358377; c=relaxed/simple;
	bh=DU9PdZ6M3qRHVGhWiGr1BBgMHTeSFwMQWqU4LcJRzHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvXSNxuoH2k3fIy/vMytjz+m6Sk+/OCRgu/CroCQ7DDRN/gM4C9eX4ekkbl3fK8k9RfWQxheivgLGT9g4fhOzxRImiLgk6DafRDO9u9ArpwJcJFZknaLXJ+dstItAnmrRaSnlryDdwrr37chOI1H3CtLiejUpO+PvwkQG3emZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FohXil6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FohXil6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F3BC4AF0A;
	Tue, 30 Jul 2024 16:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358377;
	bh=DU9PdZ6M3qRHVGhWiGr1BBgMHTeSFwMQWqU4LcJRzHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FohXil6vqk9/xgdXm2G4zrExRZ08d81mipdjolGiPO2E7FFiS4hBM2az7cuezDjIm
	 pT/dXXRrLU2JQhuqfbuV0Bm41bN3zRSmUwcmOP4dI0P62TDfpPuiUAJq5xv5KHmZhC
	 V1TrMqXJSobh/u/ZyeQfaXHg2SpRSaJuTkFl7W44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 347/809] perf report: Fix condition in sort__sym_cmp()
Date: Tue, 30 Jul 2024 17:43:43 +0200
Message-ID: <20240730151738.339509772@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index cd39ea9721937..ab7c7ff35f9bb 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -334,7 +334,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
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



