Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565F74BD373;
	Tue, 13 Oct 2026 12:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893045; cv=none; b=aF+STiquu+7GMsAPeDDtZDRtVJVgRn6vyunWbi/2SPk7vw6HZJsqidb/goTMxvJD5eqC/gewox1BMC8cWmSyKDA79pABzm2dDfxb0q0CP6S4jploAbAWbtkHp08xRtZnFop2E3j1fivRrrHkO8Xv/xMu2TXEKZJzgJFbt99zUio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893045; c=relaxed/simple;
	bh=LeVdB/o6lB8eqNVZtsGZtJ3KRr3gmxSyxmPiXiafKYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI0FiSZ5lrsYW/SJEdMxZPO2586P1iDxWOavJX/YdNZ9IAA2AtqTCn7L1J1kbwSO9Jvkami1noih30nC6R1TQ2DXWNH1ZMMtdGw/xM3CX5BAns4B/WpTKqjXhwBc6pQ/gzZ9B+hrFjqDUah9DFVa2Wz7UThsanKfCf4wXo/mtmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yr2X3EUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yr2X3EUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A693D1F000FF;
	Tue, 13 Oct 2026 12:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893044;
	bh=caKPYQdovkUuHL9laZXrtQQUp3EIwPRjyJmM9ZmSmnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yr2X3EUZvemts5grBISWMais2a+LjWGKVdkjDS+x5Y2/hJlWnuUpXUdHTiwfXLGcm
	 RGPopUOidkguAKVK9Dm2Yipe+saBMaOY7iRKghx26QlT5WH54Up4jtCUNi2mEG3uzR
	 1t19yjl/pbC6quxOhU/od9oBeyWbBGBolxZJIf9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 093/621] pmdomain: rockchip: fix clock leak on domain probe failure
Date: Tue, 13 Oct 2026 13:31:28 +0200
Message-ID: <20261013112923.058345620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -823,7 +823,7 @@ static int rockchip_pm_add_one_domain(st
 			dev_err(pmu->dev,
 				"%pOFn: failed to get clk at index %d: %d\n",
 				node, i, error);
-			return error;
+			goto err_put_clocks;
 		}
 	}
 


