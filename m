Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171F846D08F;
	Tue, 21 Jul 2026 19:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661655; cv=none; b=mL2NDZnaiYjt3wfN+jiTsljL4d9xAnkNlzel2LDClxxG59dQtcnez+sLMhUwqzXubk4o049BrBCSuYMKb67M41ClFS8EcAOt6UEZSWml5P6xa0QD705vn92zBeuNCtnzZFqV9roxjBFT4iPp8jd4q4JzH4CX6qn8dSmoK0yFb4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661655; c=relaxed/simple;
	bh=2DUEu5osU0Pzp7V4bfTj4T+dRel4zF5Kxn4ZZcSUHm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiC1EMwxCzzCez9RaDP7Ihsb5kd6ReQERSnET2yL41Q+1TlPcTVdOnBy3SqGi22JFz3CPh4b+t0CyDla3Zmsz2wNrYiZLjX6AU0gWo+pr0BsaJ6P/pqHQulZLytZaww1E/u8PAHf6YeXtHK5o0QRHohg3VRgX8CakZGX17Q96N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmH/Tjjk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmH/Tjjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9DC1F000E9;
	Tue, 21 Jul 2026 19:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661654;
	bh=4sGBP4SIBx0bTAs14d4CMlfnMPxbK4+JHPh/wS/3TBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmH/TjjkpbO4Tmmz2QvvVd34FpJECJMSCK8rO3sm8e1olAW5R9XG3T7+gk6xhnqpP
	 htjs3b7h7t5XDLdU+/rPbmA7ZdIMgHfBpzc3rngnudHeRqnrasd/JVxOCY8ClF5FkF
	 srtidmMTFxfnwn1gB/KT2U1BPW1ee7jbB81A90eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0149/1276] cpufreq: conservative: Simplify frequency limit handling
Date: Tue, 21 Jul 2026 17:09:52 +0200
Message-ID: <20260721152449.437511536@linuxfoundation.org>
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

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 3494dff89779b73a6c70481c982e0e96d336454a ]

cs_dbs_update() performs explicit checks against policy->min/max
before updating the target frequency. These checks are redundant as
__cpufreq_driver_target() already clamps the requested frequency to
the valid policy limits.

Remove the unnecessary boundary checks and simplify the update logic.

This also fixes an issue introduced by commit 00bfe05889e9 ("cpufreq:
conservative: Decrease frequency faster for deferred updates"), where
stale target comparisons could cause frequency updates to be skipped
entirely after deferred adjustments.

Closes: https://lore.kernel.org/all/20260421123545.1745998-1-zhenglifeng1@huawei.com/
Fixes: 00bfe05889e9 ("cpufreq: conservative: Decrease frequency faster for deferred updates")
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Co-developed-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://patch.msgid.link/292e6d937890f135e30ec0d2107eaad47cb9a976.1779423281.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index c51b6d1ebcd562..3550c22e5d839e 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -103,10 +103,6 @@ static unsigned int cs_dbs_update(struct cpufreq_policy *policy)
 	if (load > dbs_data->up_threshold) {
 		dbs_info->down_skip = 0;
 
-		/* if we are already at full speed then break out early */
-		if (requested_freq == policy->max)
-			goto out;
-
 		requested_freq += freq_step;
 		if (requested_freq > policy->max)
 			requested_freq = policy->max;
@@ -124,13 +120,7 @@ static unsigned int cs_dbs_update(struct cpufreq_policy *policy)
 
 	/* Check for frequency decrease */
 	if (load < cs_tuners->down_threshold) {
-		/*
-		 * if we cannot reduce the frequency anymore, break out early
-		 */
-		if (requested_freq == policy->min)
-			goto out;
-
-		if (requested_freq > freq_step)
+		if (requested_freq > policy->min + freq_step)
 			requested_freq -= freq_step;
 		else
 			requested_freq = policy->min;
-- 
2.53.0



