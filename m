Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211615;
	b=EZrUaKJXwNAIvKqtopZLDHelox3g8YhyE5LaRS/QV/bMiG2cm0hYEwHb9aEqiOWy7C63
	 D9d5hFG6c802AXG0wMNwGdhr7S0fIVcwgVfcvW283KTZX5H2l/VxFKABQ+bGzrjaqcnIL
	 yemzJUOdkrhmTAF0T+7sjuXpxyFSuD5Hdeto65HZW/vrmROZAapgGHScfghI47RtiHqSy
	 VAUt6xt5S5boMp9oGbtiRnHdhDLO5wjFglZj9eYjmPWODqOiYIgIuTCOAe1QWzi78Zjia
	 CFxAlQUzeBDCnBYZe2MJMp3WBy95m+Y+cXkzqnvOaScIjELw0j9q0LX1B794sTdSJhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PV2kQEV57V4KfJ1oSdyYHZXnGH+vCpT7lxpUDQBxgJY=;
	b=1LDoKKWrRhA8ilg2zfehu1NoQ+J/Oo184mbnokaTzwq7Vf+3JKvk/uhsDPw+7JIguahy
	 3kfWsnBfTjNwkKEheFBDIoghj1i8tIX++AgMwh9RIpibPdbCYV+7jTo3k3kESLUniJiIs
	 gPVd1bQCNP27N0c92swuX8vFVYJR88c3bF/Qmv8hzVznbV4RH2B53qAzTW3tjQ7BOLxbm
	 edNasOBX2gr018ohMD+WBSr2VbLwICJXKT2BToGwjBdO72j9CG88gzLdaQXRDEqs0AFrD
	 PrfPR994PMj9WN9BWLq/Bug4jp3kveRZ/CHg2oOIn/vvFvoLaXHQ/vspHWHgYejomyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pvu/4sog";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6563606A31C;
	Wed, 28 Oct 2026 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvu/4sog
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30FF1F01825;
	Wed, 28 Oct 2026 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211615;
	bh=PV2kQEV57V4KfJ1oSdyYHZXnGH+vCpT7lxpUDQBxgJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvu/4sogSILtStGCsiqbuMgSX/gtElxcWsnHZ8SemDC8gq5/AztlFItGGjeqHVYE3
	 CKMyPyXRmHItYrC+EoEnWHmBcmdKK+atfu2K+SymuV7Dn9FlkGwKL5ZEaPC2XRVOFy
	 q/05xgZ40v0ERpKbZstNfv0TpNGBUBz4napqua5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/571] pmdomain: rockchip: fix clock leak on domain probe failure
Date: Wed, 28 Oct 2026 17:59:47 +0100
Message-ID: <20261028170018.464350609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit d8b3847770661b7109146e6479eeadcdab9cecf0 ]

When of_clk_get() failed in the middle of the loop, the references of
the clocks acquired so far were leaked instead of being released by
the error path.

Fixes: d909072d0521 ("soc: rockchip: power-domain: use clk_bulk APIs")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/pm_domains.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/rockchip/pm_domains.c b/drivers/soc/rockchip/pm_domains.c
index 0868b7d406fba..67f78378d7f13 100644
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -443,7 +443,7 @@ static int rockchip_pm_add_one_domain(struct rockchip_pmu *pmu,
 			dev_err(pmu->dev,
 				"%pOFn: failed to get clk at index %d: %d\n",
 				node, i, error);
-			return error;
+			goto err_put_clocks;
 		}
 	}
 
-- 
2.53.0



