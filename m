Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181F037E2F3;
	Sat, 12 Sep 2026 19:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240773; cv=none; b=cNF366v1lVsrEQLcovC794a6ej3ztq4UoW7d+cR9EwaEHyDOPVSfBqWEB66x21AuTPB3KeNFEjqB3P7QBL1fMfozzCdAtAB+d4WG6Vd/kW5gGit2yE/L8lxkIzQZYQp8UP2u+w7Rm5p/KdWNb7XNcTj1rQSbgzBoJrtbxqwh+6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240773; c=relaxed/simple;
	bh=5HMfOWMo0IlSAIDjaMi6ysrpO/bBFkSDzNECeZW/Wes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5HZrMBJW2C+Uo7/FOTP9IvaQbFt56RjoxEvMTNJ8TNeRUW+2gBbfpshaRaBSCUr8jDoCWIEZZM6Xdd83TfMgXGqEN4fUce9VLTuvYb6fwPs49WrLQbVk9s+B8KT/mt56jR4U6PChOn5tMsd19sd1wXGU/MWq7ZwrYEUv6Kadw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKsGxc5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKsGxc5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAA81F000FF;
	Sat, 12 Sep 2026 19:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240772;
	bh=nTGOgZ8XYz4MAL1BE9UlJyJt6DfGH1MRrZeYPEkBCCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKsGxc5DlliEB6PWsH8+ys86SWLz7Tnvk4HPOCmmyzqYiOaosCufGC4VsykZaUJ3H
	 DfbfWHle48nthxcILF96cfNMA7JHJpQ7uhWOSEjKUVY6Xd8gTBzYNvWwDvA5DgZ/DA
	 kxWrMavwy9+mo6PoybPYgHzrqzAHWEI6dXCiT/S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.15 935/935] clk: qcom: gdsc: Bump parent usage count when GDSC is found enabled
Date: Sat, 12 Sep 2026 09:06:05 +0200
Message-ID: <20260912065548.263459240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 41fff779d7948147f2440c4bb134cdf8b45b22d7 upstream.

When a GDSC is found to be enabled at boot the pm_runtime state will
be unbalanced as the GDSC is later turned off. Fix this by increasing
the usage counter on the power-domain, in line with how we handled the
regulator state.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20220713212818.130277-1-bjorn.andersson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gdsc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -427,6 +427,14 @@ static int gdsc_init(struct gdsc *sc)
 				return ret;
 		}
 
+		/* ...and the power-domain */
+		ret = gdsc_pm_runtime_get(sc);
+		if (ret) {
+			if (sc->rsupply)
+				regulator_disable(sc->rsupply);
+			return ret;
+		}
+
 		/*
 		 * Votable GDSCs can be ON due to Vote from other masters.
 		 * If a Votable GDSC is ON, make sure we have a Vote.


