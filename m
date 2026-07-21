Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952313EEAC7;
	Tue, 21 Jul 2026 19:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661413; cv=none; b=BlNy064brLcCNktGmlgA114Z1VQ/9cx3t/iqRFyTwqRw512c3KdqtScc764nTA0CJmo7aZDiTMLjfP8CYUpYCSxiYyqDhhZ2R0OHiS62Hobgqetmyi8b0wmi56wCbyho1ug5n9hyQHtcBaciXkX1cjLO9oV5OgtgAIwhU9r2ijE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661413; c=relaxed/simple;
	bh=5BvU8D8HJw/b4z3AxvQw35SofNl3+Uy8lqQhqnbilcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPgyIO+3aIi1JvZIMT6dYvK7QqhkXXdAdFGxV6rhf0HUEIzOsuOfmBXeD8/yBGGAgoj4XCeDTUBMirNjrI+ov8DsuXNSeANz9tSqNvTN0Htpd1UaAWLWPCXE+aroTCO7CaQb3wrmDUmfSrCI700orpaAd53h/HpQgtkhEG1a+qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgWvpV7E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgWvpV7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFD51F000E9;
	Tue, 21 Jul 2026 19:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661412;
	bh=sGy4nuZ+SE41+QyRchlhu8DH64adHvT5VB/1M6Rsm2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgWvpV7E7CI/hXCVoRaJ8SOY9iMeMMXaMuJHqqH56xdLy3mY//QMqZALz9SUcrBid
	 nbt3CqFZOrI04REOsa8ZTYt0ZmvN6hFKC/yNDVLIRz1KHkNbQyi+0SnAqGA058F4lA
	 MyhlEpoOZaGPIMyVqPGOZOitVbvm//aiogZI4T10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0058/1276] clocksource/drivers/sun5i: Handle error returns from devm_reset_control_get_optional_exclusive()
Date: Tue, 21 Jul 2026 17:08:21 +0200
Message-ID: <20260721152447.381350127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit fed9f727cc3f91dde8278961269419083502b40e ]

The devm_reset_control_get_optional_exclusive() function may return an
ERR_PTR in case of genuine reset control acquisition errors, not just
NULL which indicates the legitimate absence of an optional reset.

Add an IS_ERR() check after the call in sun5i_timer_probe(). On error,
return the error code to ensure proper failure handling rather than
proceeding with invalid pointers.

Fixes: 7e5bac610d2f ("clocksource/drivers/sun5i: Convert to platform device driver")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260205084037.3661261-1-nichen@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-sun5i.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index 0d229a9058dad8..706a12a5759829 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -284,6 +284,9 @@ static int sun5i_timer_probe(struct platform_device *pdev)
 	}
 
 	rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
+	if (IS_ERR(rstc))
+		return dev_err_probe(dev, PTR_ERR(rstc),
+				     "failed to get reset\n");
 	if (rstc)
 		reset_control_deassert(rstc);
 
-- 
2.53.0



