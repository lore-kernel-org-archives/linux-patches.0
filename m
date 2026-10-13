Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9624F4030;
	Tue, 13 Oct 2026 11:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892775; cv=none; b=Tm3WZrP0rhdr2Fj1MQmt86OWioRg3eBdLQL7/yrfckarF9dGBomFyK8JGQL8qXFQIakcLU8XGStq1qwO3+4kQUfZNhbjbx6UVU+zj3YzqjEMuv2QE2Vgq1fLnY9PQzJmahoGrwaZkzJ/eDcN4Qctfs+fJnOpy2MKqvzvY6G2QFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892775; c=relaxed/simple;
	bh=/A+BPrP6EZmapPtoCWo7mjcbg846MhKO9KxDpMdx34w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfPsNi/+Z5vyfxUxQwj4I6P979M4L4lb9qsJ1e2+MiCp2WcQJKbXH37fwGyl0VHzlUGRujPf8vxcUq2BNHxLxbNpgIZMFjqJW2D2/4nDaCD/epHCewNLUzcSTidehLy74oacYnwfL2Wqta01qJLdvpdEVipn0zMH7SNzCox3c84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+f5yL6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+f5yL6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5BE1F000FF;
	Tue, 13 Oct 2026 11:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892774;
	bh=RQabD6ZH6gAVpW0IJQdXBzHNynO/Nve/YqEqX66l3kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+f5yL6ildn4QZAxpSEwoG24zK2mvncghcp8lu3QFSmqN6srpn/viCTUtN11NFT97
	 Chrsc82cPVurDtKmHF0JlHPmKP/UqDkLmx3JLM4JYtse3kMchUWhF7z7EDkNH576Ou
	 9GXLiXj8Ij7HrgFFVpE0lr+q9E+Z8e/QDYY07GsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 270/281] ptp: ocp: fix PCIe delay estimation calculation
Date: Tue, 13 Oct 2026 13:39:46 +0200
Message-ID: <20261013112901.691518410@linuxfoundation.org>
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

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit f8c8bd159a9bf626dd4921b7746ff481fce8c758 ]

The commit in fixes introduced a high cap for delayas U64_MAX value
while ktime_t is actually s64. This is wrong cap as it becomes negative
value and any comparison to a real delay will fail to update delay
value. Use KTIME_MAX constant as correct max cap for PCIe delay.

The issue was hit in production (a negative value is observed):

  # cat /sys/class/timecard/ocp0/ts_window_adjust
  -3

Fixes: aa05fe67bcd64 ("ptp: ocp: Improve PCIe delay estimation")
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261007203359.417270-1-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 3d26ec1f7b9ec..a8cba2f64b98a 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1825,7 +1825,7 @@ ptp_ocp_watchdog(struct timer_list *t)
 static void
 ptp_ocp_estimate_pci_timing(struct ptp_ocp *bp)
 {
-	ktime_t start, end, delay = U64_MAX;
+	ktime_t start, end, delay = KTIME_MAX;
 	u32 ctrl;
 	int i;
 
-- 
2.53.0



