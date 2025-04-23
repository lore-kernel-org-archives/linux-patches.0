Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A222C1796;
	Wed, 23 Apr 2025 15:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421887; cv=none; b=pjcvOXrMssqLcQezQDOOA1R9sIyHTpBt06+b1lJgF9HFhDAf7gyDoWXcWsjYfcPCCy58b7/RIBAtxIPBWB0kDtgenP04I5SWLvteUU+r76cmrIpKqQ7riXzTe8BvrySSLLi+WgczvvimzkCzanaKz9mkChCO7N+wiynNvGI0QJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421887; c=relaxed/simple;
	bh=jPdPreuQGGv+t8Cy6Rd2/IOPO+xUozwidzKKkBRdkw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb0XZdh/rn5vz47hPa9zJHbOuxGJNlYbQIYNATv0s2jp7+O/xihlkGx3ZiSCSsKTC/rjPiaj/quoHnnIGn5CSDRMAb8DKq6AIzHzHhHG9WR8qfHD2PLYD1oqtnszefFuR3b9UxapUmmigfG11i5kAPgxRDe0OhlbDb84hufFE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwTIQ+it; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwTIQ+it"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7906EC4CEE2;
	Wed, 23 Apr 2025 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421886;
	bh=jPdPreuQGGv+t8Cy6Rd2/IOPO+xUozwidzKKkBRdkw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwTIQ+itQk5e3MKuOrpsQdfbIn9Of4428HFfs94eRcJ8jzYZ/vJjhD2WBD18aQ1Du
	 VBV+0nA5ObxdGLNBX++nLMKxr9CavkF2OJvMM1qXWbgjj2DUaPjvB99+11MVO7Xetv
	 tTPoLlacwfwerv3rAnQiLKGtcSkiC1nNPmpVK2Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Maimon <maimon.sagi@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/291] ptp: ocp: fix start time alignment in ptp_ocp_signal_set
Date: Wed, 23 Apr 2025 16:43:02 +0200
Message-ID: <20250423142632.269247893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Maimon <maimon.sagi@gmail.com>

[ Upstream commit 2a5970d5aaff8f3e33ce3bfaa403ae88c40de40d ]

In ptp_ocp_signal_set, the start time for periodic signals is not
aligned to the next period boundary. The current code rounds up the
start time and divides by the period but fails to multiply back by
the period, causing misaligned signal starts. Fix this by multiplying
the rounded-up value by the period to ensure the start time is the
closest next period.

Fixes: 4bd46bb037f8e ("ptp: ocp: Use DIV64_U64_ROUND_UP for rounding.")
Signed-off-by: Sagi Maimon <maimon.sagi@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250415053131.129413-1-maimon.sagi@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 87b960e941bae..b6f66a9886ce2 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1654,6 +1654,7 @@ ptp_ocp_signal_set(struct ptp_ocp *bp, int gen, struct ptp_ocp_signal *s)
 	if (!s->start) {
 		/* roundup() does not work on 32-bit systems */
 		s->start = DIV64_U64_ROUND_UP(start_ns, s->period);
+		s->start *= s->period;
 		s->start = ktime_add(s->start, s->phase);
 	}
 
-- 
2.39.5



