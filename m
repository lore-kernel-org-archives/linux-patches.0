Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852D06AA0;
	Tue,  5 Dec 2023 03:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxdnNUZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE532C433C7;
	Tue,  5 Dec 2023 03:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746504;
	bh=dBX7VQWnKIUTzEbn5EitQKgqG7AZY/Hk0FfZRuN9914=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxdnNUZeI7fgAVwRpBt031x1e5Yo0QFOAmg8Tn2G5Wc3+YStkN6aqnURwNGoogj+T
	 +UdyjceR6fGXEKPpPEylWbH7kH8qJvQybi2zaH2iBasbYEbuXHsh8eqDj3fye41rCm
	 oRhd3jeF9FVh0IGPJW9IvjPM9g+vzd8geHUPtNMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Rui <ray.huang@amd.com>,
	Wyes Karny <wyes.karny@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 047/134] cpufreq/amd-pstate: Fix the return value of amd_pstate_fast_switch()
Date: Tue,  5 Dec 2023 12:15:19 +0900
Message-ID: <20231205031538.554630109@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

commit bb87be267b8ee9b40917fb5bf51be5ddb33c37c2 upstream.

cpufreq_driver->fast_switch() callback expects a frequency as a return
value. amd_pstate_fast_switch() was returning the return value of
amd_pstate_update_freq(), which only indicates a success or failure.

Fix this by making amd_pstate_fast_switch() return the target_freq
when the call to amd_pstate_update_freq() is successful, and return
the current frequency from policy->cur when the call to
amd_pstate_update_freq() is unsuccessful.

Fixes: 4badf2eb1e98 ("cpufreq: amd-pstate: Add ->fast_switch() callback")
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Wyes Karny <wyes.karny@amd.com>
Reviewed-by: Perry Yuan <perry.yuan@amd.com>
Cc: 6.4+ <stable@vger.kernel.org> # v6.4+
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -518,7 +518,9 @@ static int amd_pstate_target(struct cpuf
 static unsigned int amd_pstate_fast_switch(struct cpufreq_policy *policy,
 				  unsigned int target_freq)
 {
-	return amd_pstate_update_freq(policy, target_freq, true);
+	if (!amd_pstate_update_freq(policy, target_freq, true))
+		return target_freq;
+	return policy->cur;
 }
 
 static void amd_pstate_adjust_perf(unsigned int cpu,


