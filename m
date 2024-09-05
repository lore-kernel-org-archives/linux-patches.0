Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6561494DB;
	Thu,  5 Sep 2024 10:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530580; cv=none; b=se5YR5ZcVyO48rYWJ/3geJVSe5rWfficnAJfUga6E0h0uSLvMl/1r0TZdCcjF1tAYxieYrTgkeuRO3PUqVJhAaBOsdLWXk+bzLAlQGP6hySdv0T8D4U8grQqMedSEMk8MdA5+8NamG9NRZUfxaJRbqmBFzXF6qI6q0DVSGKGOfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530580; c=relaxed/simple;
	bh=RjCqldgrfdq6/b4GcMc6S/CPcbRzJRcaaeDPJAksICs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxV5Rrz3lksYC1UEyvZL2PJb3rJk1zCnUr+HCjFDdGnUcBdg1s9BZ2LL8v08uFeAvIp7Vcy/lUw3DTxLhGY2tl4fVWYq/FsrIA+neCLK6pTkVkx4P+oPWIpll/+1czeS5kWVme4ztZuJ5HlbaeCOv3hxyK5+eZnD5Nl7DpPqivk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF0i9PCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF0i9PCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA35C4CEC4;
	Thu,  5 Sep 2024 10:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530580;
	bh=RjCqldgrfdq6/b4GcMc6S/CPcbRzJRcaaeDPJAksICs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF0i9PCVtflWko/1+5ECcrK4N4deZk83rNydNJ3OzHgR4BLFNQjjHmW2N6qVBMsbQ
	 kScjRr0Qcgj22hu3qq+b2XPlgUEsLeVqf+XGnDhpGdKYE2RxRoQOF+UnELisl/GTXB
	 umo6yzVcYo/zS05GDegDF6dGl7y9J5gDxkzRZEqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <quic_jkona@quicinc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/101] cpufreq: scmi: Avoid overflow of target_freq in fast switch
Date: Thu,  5 Sep 2024 11:41:41 +0200
Message-ID: <20240905093718.836380541@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 028df8a5f537..079940c69ee0 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -62,9 +62,9 @@ static unsigned int scmi_cpufreq_fast_switch(struct cpufreq_policy *policy,
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



