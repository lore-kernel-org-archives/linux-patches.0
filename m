Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD54B318ED6;
	Tue, 21 Jul 2026 20:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665587; cv=none; b=T6i6+dQMYwqE2dkw/Gqi+t1s2jNHT+cEtkdPaWt8YzwAdBzkUQDaY5O/rpVB/Qwt/o99p4Cw5jhO5tWZ7lkO3g786kuuLjUQtp1FlYoQy0rTgdWfwD3trbXQz6CFnGCxOIbA5QF8t1DXOEuwYJz1A6qUM2V9bAuxss1T/2uyFRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665587; c=relaxed/simple;
	bh=WKa4qMPBQZIvIGE10492cXsGtO3bxgyN43WQTr4m7+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBkxsiiJGQu+oOWPHYiCGU/+hJLzmnBTBUJCBzFtUwSZicKsZM54MTRk3j2S7NMpiqQLt7L4lis3qo9vV6TeG8o37wcpfwgXckScQcnGrix/CYI92Wpnn9hofXRIxlGj3AxjHGClFdkm5JBVQMb9Hq7iPJ+wUuT3TJsdWsEHT/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyr4V97i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyr4V97i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74951F000E9;
	Tue, 21 Jul 2026 20:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665586;
	bh=O8U6uPNhC0Bvzc5OAt2Rvsk9kRvPaP3/MmDmMDuwAZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gyr4V97i/Hn6QPBylk+uudOsuFJUevIvw1AiQOPvAjkL8tnfcsseO5y1VEpC1wQIs
	 WBGgFnVzpJEu+xgP2gwwrOjzeFHpsH1Lszcj2QUom2MHEPpUORa4hQ9ZQ4pyuLxOJZ
	 w2loRZ2o0jrqlQbh93MFM0YK6jz8CIPo3PeAgRxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0358/1266] clocksource/drivers/sun5i: Handle error returns from devm_reset_control_get_optional_exclusive()
Date: Tue, 21 Jul 2026 17:13:15 +0200
Message-ID: <20260721152449.840071266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 69fee3540d375f..e9efe03dc126be 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -286,6 +286,9 @@ static int sun5i_timer_probe(struct platform_device *pdev)
 	}
 
 	rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
+	if (IS_ERR(rstc))
+		return dev_err_probe(dev, PTR_ERR(rstc),
+				     "failed to get reset\n");
 	if (rstc)
 		reset_control_deassert(rstc);
 
-- 
2.53.0



