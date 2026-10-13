Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA66B4F393E;
	Tue, 13 Oct 2026 11:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892220; cv=none; b=oKTBoMiSo/+LyZQpzN7GbTKY5/TmkHt4UJqT3THcaUGb5q2CbybcVSPHaXd1VqBhvMb5+crenXU41BE9/iN0S75YGx+uPEdgC/pzAJRwDy42RPpIifMOFmxXtnTbn1BDhoe9QZdW5S0qT5Ok/kQoc0/mD71DLpkCbQ+pFG8JtOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892220; c=relaxed/simple;
	bh=LoHphbPqn40UHCW6cWtMep8HB7qNiR8IKBsmm9ivTv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFuRME3za+xzu6lOKTV+hOdKfyjiJciRWAf53rkfAbrDB0dT5L4q+Hek9+D1xlha2JIV51K7CPf6WB9MetBhhHbIj1QcHYUmdt2ikDZ+F+HFckOEFTxTm22f8Y/errevDD9eP6GgoMxwkWgBO0yRaLocpE6ic0fqr1iDjoJjy0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRXNcbEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRXNcbEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEC91F000FF;
	Tue, 13 Oct 2026 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892218;
	bh=ABfcsU5pm/o5ED2kZTQEn/3aKBlLhJ7ovbNTXmObq8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRXNcbErb1EohaZlcvNNpLMxAgxXz9pwLwgw3xldgKF1F3hH+7BhoH0tL5PCjtQrk
	 TgvKb/eAia1HIt17ny2lcpf3TjuEAwIQfwsO6wppC7ReZVyMWL+Ymhd0PQz2THpe7R
	 sXfOU1zXHt7dR3qLp+7KpmRw+GUanmhHTNxBuw84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 100/281] pmdomain: rockchip: fix clock leak on domain probe failure
Date: Tue, 13 Oct 2026 13:36:56 +0200
Message-ID: <20261013112857.565103863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

commit d8b3847770661b7109146e6479eeadcdab9cecf0 upstream.

When of_clk_get() failed in the middle of the loop, the references of
the clocks acquired so far were leaked instead of being released by
the error path.

Fixes: d909072d0521 ("soc: rockchip: power-domain: use clk_bulk APIs")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -840,7 +840,7 @@ static int rockchip_pm_add_one_domain(st
 			dev_err(pmu->dev,
 				"%pOFn: failed to get clk at index %d: %d\n",
 				node, i, error);
-			return error;
+			goto err_put_clocks;
 		}
 	}
 


