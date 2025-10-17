Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CE627B33B;
	Fri, 17 Oct 2025 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715027; cv=none; b=dvYI24RJs7TDkS0rdu3YhmCoY+sD6icICDGmTH1l96kLr2a33w2LYm0F0uTrMcoNcEAVyG8bDxZ00bO2JBigd83BrdnZH9MnjHoITpm7PszxKFWHVDqhW4H8fUz5mEGwJUKNCSv0l0VuOzunIr9uYSVvEBp9e8zDN+nH5a8QnLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715027; c=relaxed/simple;
	bh=3BiFqtjLotVhipRdSCX3x+JOjbOikjtbYCMQUmW4uWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THKGol404HxKuiulZM6YVEPn1W+cs5f7a5NZDuDIEoFXDhDkfODrMIXjENaygZzSjrM7pn8yiTQOQf69XWCU3vOMMIQOC2xz05OJHzU7lK+s/1xSQwA4kFBNzHUvlMU6R0ge1BF7ovxYy7bzuQ8eEwRdNBl+Rj17iOSJSS2QWYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4ip5PwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4ip5PwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6578C4CEFE;
	Fri, 17 Oct 2025 15:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715027;
	bh=3BiFqtjLotVhipRdSCX3x+JOjbOikjtbYCMQUmW4uWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4ip5PwWwtQftxtZdbjG54HT4lvzqLo3lz6Q6m3dj+2mjtNt0nY+1IQgGnk0TO1Xw
	 9F0AgIdH2nACIv498fXNR0apbqykZHO+w31fZVJ6EGq0ITIf/9foGJP3C+qD6M2hU7
	 M26LX2xmuO0uRrmquTA4NpWrUWqH+sOIIjMkIKtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 055/371] clk: tegra: do not overallocate memory for bpmp clocks
Date: Fri, 17 Oct 2025 16:50:30 +0200
Message-ID: <20251017145203.790860488@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 49ef6491106209c595476fc122c3922dfd03253f ]

struct tegra_bpmp::clocks is a pointer to a dynamically allocated array
of pointers to 'struct tegra_bpmp_clk'.

But the size of the allocated area is calculated like it is an array
containing actual 'struct tegra_bpmp_clk' objects - it's not true, there
are just pointers.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: 2db12b15c6f3 ("clk: tegra: Register clocks from root to leaf")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-bpmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-bpmp.c b/drivers/clk/tegra/clk-bpmp.c
index b2323cb8eddcc..77a2586dbe000 100644
--- a/drivers/clk/tegra/clk-bpmp.c
+++ b/drivers/clk/tegra/clk-bpmp.c
@@ -635,7 +635,7 @@ static int tegra_bpmp_register_clocks(struct tegra_bpmp *bpmp,
 
 	bpmp->num_clocks = count;
 
-	bpmp->clocks = devm_kcalloc(bpmp->dev, count, sizeof(struct tegra_bpmp_clk), GFP_KERNEL);
+	bpmp->clocks = devm_kcalloc(bpmp->dev, count, sizeof(*bpmp->clocks), GFP_KERNEL);
 	if (!bpmp->clocks)
 		return -ENOMEM;
 
-- 
2.51.0



