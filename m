Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D314337CD21;
	Sat, 12 Sep 2026 07:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197834; cv=none; b=Qr7Z2g36ar7rBlTzTD571PZRH8ytdfY8wTSMAQ9NhY0EYL1jydx2rj7qC8QAjesnzm0Xf58bVO4YnXFcvc8ZHVh46X/1eQKrPg812jLNk7NN3foyMq1zqg0ktLkyZKCS9w3OErpT2kAPhyXoY/BFUNyR2xFkFlyAwbcy58MYUKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197834; c=relaxed/simple;
	bh=8RVRmGuCm58mwoyD/YjzGOCgMDtaFFl3qshAWiwvYQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9+vHtbT9MduPTRNJtnwhc0jTSWoD4s5jptpnaUnBjpGYibYqnPchqR72VB5dhGpbMZJn1RPIV9nHTKtWdSrsAcYhJzifO5l4L/DG9I4UpZQHQEAy3H6YjL3b5rysn3XVAE8wlf4dZE1H7Y95qt5H64mJUQW1CZFOLwElc217dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vc4rCu4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vc4rCu4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D77E1F000FF;
	Sat, 12 Sep 2026 07:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197833;
	bh=fsAKO39oJd0gl9DcWx0yP3KVdGzDtt0t1zMHG4kseHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vc4rCu4oWgOyvxaa9jnE7IF+ViW5DljrO9eteazCgqX3765KqLKqtDZsnptpHWVvd
	 uUiqkxrHrk82BPC3MKGFxPiny7919p0QXGH+gktbzxQwE1Tpfws6ljiZNNWUxBBK3n
	 +XCw6DErlNULwulaJyfn2OKfDPyqsDnboj6rxh2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0255/1815] clk: qcom: gdsc: propagate gdsc_enable() failure for ALWAYS_ON domains
Date: Sat, 12 Sep 2026 08:33:25 +0200
Message-ID: <20260912065654.965513683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herman van Hazendonk <github.com@herrie.org>

[ Upstream commit eea55fc694e132aacbe2cf4be7f345115e3d1801 ]

GENPD_FLAG_ALWAYS_ON requires the underlying domain to be on at
genpd_init() time -- the framework will refuse to register the domain
otherwise. When the cold readback in gdsc_init() finds an ALWAYS_ON
GDSC powered down, the driver tries to bring it back up:

	} else if (sc->flags & ALWAYS_ON) {
		/* If ALWAYS_ON GDSCs are not ON, turn them ON */
		gdsc_enable(&sc->pd);
		on = true;
	}

but discards the return value: if gdsc_enable() fails (regmap write
error, the long-form sequence's status poll times out, or the
HW_CTRL hand-off errors) the code still sets on=true and falls
through to pm_genpd_init(..., !on) -- which then registers the
domain in the ON state and sets GENPD_FLAG_ALWAYS_ON, even though
the silicon is actually off. Subsequent consumer probes will see
genpd report "on" while accessing dead registers and hang or read
garbage.

Catch the failure and surface it: returning the error from
gdsc_init() makes the provider probe fail with the underlying errno,
which propagates to consumers as -EPROBE_DEFER (or fatal if the
hardware really is broken) rather than silently lying about the
rail state.

Signed-off-by: Herman van Hazendonk <github.com@herrie.org>
Fixes: fb55bea1fe43 ("clk: qcom: gdsc: Add support for ALWAYS_ON gdscs")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260602140934.796697-3-github.com@herrie.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 428d638657986..17717b7fe6a0a 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -500,7 +500,9 @@ static int gdsc_init(struct gdsc *sc)
 
 	} else if (sc->flags & ALWAYS_ON) {
 		/* If ALWAYS_ON GDSCs are not ON, turn them ON */
-		gdsc_enable(&sc->pd);
+		ret = gdsc_enable(&sc->pd);
+		if (ret)
+			return ret;
 		on = true;
 	}
 
-- 
2.53.0



