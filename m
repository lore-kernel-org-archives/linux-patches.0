Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD1F39D3D0;
	Tue, 13 Oct 2026 12:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896074; cv=none; b=mJPKqcUFk1oVAINNR3vDFoNirotIpUREdkLYGnVczWg+HMCoVr7jnCPKVXp7DrKmBz6RPRAHD8ysFJD6lS05myDv1XUgG+Qk8KmB4WRACa7KZFehljvc86I94cmfd+B5Ozr8y7/b82w5RzldyW5ErAAYihWECJMGugLswE9l8sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896074; c=relaxed/simple;
	bh=/mWqQqVo8vFCTirNj+dv8N2jih69chpD8CNYGQCz8cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Drjbd+tqKeZ+JyPnhygvJxrhCLLgHWYYS6sZCWvfMgsBsGnuCE/g627LXjASSJ8DKMvNCp6fv83SKFJ1FL+kyzPFnT+6Sn0VKGXRdfplc2YvhqGFdJa3kBfaVHTPmbnVCOBLXbgN0T6eZSTH6uUZXt+h8I74vn2axl1BoSgzAgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFV5W11M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFV5W11M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787DE1F000FF;
	Tue, 13 Oct 2026 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896072;
	bh=AHLL/52g8Xakuh3x7S4udIaU5x9XaQaES493epZTHpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFV5W11M9p0oPQiRFthRmZjFifEYlQz4/Dadu0/eDEzzehQPbmCMQXGfzP47NuvoC
	 zxyclMxXJOLziob94McpuIdqw+l9s2h/fTEi3KcEi/u3ak+Uc30QNVYdtMZR8pWBfh
	 Ab8sKT+w5T1lOII/4DNCDZTmyjajKxYEU7SyLQno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 488/497] ptp: ocp: fix PCIe delay estimation calculation
Date: Tue, 13 Oct 2026 13:40:55 +0200
Message-ID: <20261013112919.459827773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 27d2f009a51b9..42263c68d5e0d 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1562,7 +1562,7 @@ ptp_ocp_watchdog(struct timer_list *t)
 static void
 ptp_ocp_estimate_pci_timing(struct ptp_ocp *bp)
 {
-	ktime_t start, end, delay = U64_MAX;
+	ktime_t start, end, delay = KTIME_MAX;
 	u32 ctrl;
 	int i;
 
-- 
2.53.0



