Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1264F1922D0;
	Tue, 10 Sep 2024 10:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963383; cv=none; b=Xw2u1Su1oGa4bh7ybXXSg78xfZogOs5hPIKfdzK4jQdcSoNlGyszT95HX2IXYQD6DggZ3kFTK6J8y82lNfaMJBfmj9jt67l2jgcZa1lRWMBR+TQrE0qSEQaj95gTENOsoNxxN7ACrSDZppTBvzSMN2rCffW7zRJ/qwMWeSznAUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963383; c=relaxed/simple;
	bh=BXkCwMOkQzaOnzNMb9+HWdSZ2DaVKIgHQQjeaJYDTV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTy3/a2wdJhD4/MBMVIPDb0BiwhfD/O5AHOUE/NjIesqI4a6xaTMWsWvB/dfSoIfq0tYX+Er+cM1AJe/4zTSQhrFh6KSmwYYIjZzarS4JO7MWd4RFNYfQT7L64fjqOk/fCQHF+fq/KzlDGYW70hEXmluLgz0ax+5lzEue0qHRJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mc1VobAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mc1VobAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC3AC4CEC3;
	Tue, 10 Sep 2024 10:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963382;
	bh=BXkCwMOkQzaOnzNMb9+HWdSZ2DaVKIgHQQjeaJYDTV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mc1VobAoULflx3qk88Kj+8hWlZtbvTpckpCrIQchaTEuhsh1sl5PuycZ7n40eJp9r
	 hhTimsSn4TwuhwfZGwtAdyL6ZiVkCIC1g7/dwu1ggm22xOL3OnZ00+hnFcoHLcBg3k
	 9JHPIAHsqJ2Pf7HuyknbA/DeRc0quhT0aQT0Ac4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <quic_jkona@quicinc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/214] cpufreq: scmi: Avoid overflow of target_freq in fast switch
Date: Tue, 10 Sep 2024 11:31:01 +0200
Message-ID: <20240910092600.369728796@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <quic_jkona@quicinc.com>

[ Upstream commit 074cffb5020ddcaa5fafcc55655e5da6ebe8c831 ]

Conversion of target_freq to HZ in scmi_cpufreq_fast_switch()
can lead to overflow if the multiplied result is greater than
UINT_MAX, since type of target_freq is unsigned int. Avoid this
overflow by assigning target_freq to unsigned long variable for
converting it to HZ.

Signed-off-by: Jagadeesh Kona <quic_jkona@quicinc.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index c24e6373d341..eb3f1952f986 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -61,9 +61,9 @@ static unsigned int scmi_cpufreq_fast_switch(struct cpufreq_policy *policy,
 					     unsigned int target_freq)
 {
 	struct scmi_data *priv = policy->driver_data;
+	unsigned long freq = target_freq;
 
-	if (!perf_ops->freq_set(ph, priv->domain_id,
-				target_freq * 1000, true))
+	if (!perf_ops->freq_set(ph, priv->domain_id, freq * 1000, true))
 		return target_freq;
 
 	return 0;
-- 
2.43.0



