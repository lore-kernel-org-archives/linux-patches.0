Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8B73BE62B;
	Sat, 17 Oct 2026 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257293; cv=none; b=rCNWgUEL86DNp3STmc8ItC64HbuLBCgxulyVzCj7hPxxQ1DJA1tOme35Zzccr/Yq66Af6IrSH+/mL0D9OmkiBXLORXCR/mgnyMbUtqZ0WUpiBJmJckrkK2XwHV0H1k6h9GLYZUgc+sxD9jNnPZn6mA2Q5dinfMET7at3JOBhHEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257293; c=relaxed/simple;
	bh=fdaz54ysNjjhgHyqJ1FDzR7abmPEfauRAR7/Jbe3z9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGh8zJxdwU7u1oZRprfbJtgxy51Mak4X/5M5dQKJ52Vwzd65FgdKvmghQ6o725J79vDhg1cQBMXgHaldGpGPHI88H87tJWG9V0o1hrfGHvEYPqUNKsUXC7rMqoGfubftH82wquGO46++wdNNoRK5DQLrOfZXykd+Ez4ucUjP0HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nd85+fkc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nd85+fkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC751F000C4;
	Sat, 17 Oct 2026 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257292;
	bh=kkKbqn2C9+WGIbpBuOxd5Pp0jWBDqTAgguotYoNZUxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nd85+fkcCT+RnLvFUZt86EhqGjPiNLbnhvg24Y9UhUrrF6iWrGt4JPjm63kBNNPxO
	 ttT5s2jQ5jOvBHZDM+fMcvTjRFqu/EWovSqqqku/XyTZEoTiXsBilkI8linkhT+Cca
	 eomeFkIJ7sZN0r1zVtpL2dqq4JI4iecxv9p6Nln8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0512/1674] pmdomain: rockchip: fix clock leak on domain probe failure
Date: Sat, 17 Oct 2026 17:46:24 +0200
Message-ID: <20261017160444.246880508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -686,7 +686,7 @@ static int rockchip_pm_add_one_domain(st
 			dev_err(pmu->dev,
 				"%pOFn: failed to get clk at index %d: %d\n",
 				node, i, error);
-			return error;
+			goto err_put_clocks;
 		}
 	}
 


