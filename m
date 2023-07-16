Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FE78F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF01BC433C7;
	Sun, 16 Jul 2023 20:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539636;
	bh=QZUMSxlYRzhO4Lz+sWmdn0UADAYr27hwb1KIeP2fqbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJDNk7XhX1b/4LqMT/dUIpReDHaqj2L1LVSPCr3JEa+75R4goX/hXqv+aStkQBIXD
	 2kfYRLpqjvxfw3OWmzlPkACexicszozryxYWjKaKR4+zyTDp6p1OStTUD34DlILUYN
	 7+kYzU4JJSEyUzMr30F8NABxp5xzJqYO2qUNscYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/591] cpufreq: intel_pstate: Fix energy_performance_preference for passive
Date: Sun, 16 Jul 2023 21:43:09 +0200
Message-ID: <20230716194925.180507951@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tero Kristo <tero.kristo@linux.intel.com>

[ Upstream commit 03f44ffb3d5be2fceda375d92c70ab6de4df7081 ]

If the intel_pstate driver is set to passive mode, then writing the
same value to the energy_performance_preference sysfs twice will fail.
This is caused by the wrong return value used (index of the matched
energy_perf_string), instead of the length of the passed in parameter.
Fix by forcing the internal return value to zero when the same
preference is passed in by user. This same issue is not present when
active mode is used for the driver.

Fixes: f6ebbcf08f37 ("cpufreq: intel_pstate: Implement passive mode with HWP enabled")
Reported-by: Niklas Neronin <niklas.neronin@intel.com>
Signed-off-by: Tero Kristo <tero.kristo@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 6ff73c30769fa..818eb2503cdd5 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -837,6 +837,8 @@ static ssize_t store_energy_performance_preference(
 			err = cpufreq_start_governor(policy);
 			if (!ret)
 				ret = err;
+		} else {
+			ret = 0;
 		}
 	}
 
-- 
2.39.2



