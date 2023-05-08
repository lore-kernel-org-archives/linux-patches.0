Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA115171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338B0C433EF;
	Mon,  8 May 2023 11:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545626;
	bh=id5MpoUwytcHW9sNnELAw8lRJjKZw4pOuKZi3J5POP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQmO7l+eDsQH+kkRCUK/SwQ3fLbTIswG6ac7+uY8X7K1LWQ+BBFGKHPfLkgcYg8Va
	 klFYkC7X1RFSMTv8RPxnF9UNEMEcrH1+8Tg1/QVF0I7TOGpGfQ9J/pAJcAleH15ImV
	 R/SZ8UJDgdRUnoyKhL1lP0CSxT1wwcFihDJBMUeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghua.yu@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/371] selftests/resctrl: Move ->setup() call outside of test specific branches
Date: Mon,  8 May 2023 11:44:23 +0200
Message-Id: <20230508094814.537663542@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit c90b3b588e369c20087699316259fa5ebbb16f2d ]

resctrl_val() function is called only by MBM, MBA, and CMT tests which
means the else branch is never used.

Both test branches call param->setup().

Remove the unused else branch and place the ->setup() call outside of
the test specific branches reducing code duplication.

Co-developed-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: fa10366cc6f4 ("selftests/resctrl: Allow ->setup() to return errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl_val.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 95224345c78e7..dd907809d0b29 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -733,29 +733,22 @@ int resctrl_val(char **benchmark_cmd, struct resctrl_val_param *param)
 
 	/* Test runs until the callback setup() tells the test to stop. */
 	while (1) {
+		ret = param->setup(1, param);
+		if (ret) {
+			ret = 0;
+			break;
+		}
+
 		if (!strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR)) ||
 		    !strncmp(resctrl_val, MBA_STR, sizeof(MBA_STR))) {
-			ret = param->setup(1, param);
-			if (ret) {
-				ret = 0;
-				break;
-			}
-
 			ret = measure_vals(param, &bw_resc_start);
 			if (ret)
 				break;
 		} else if (!strncmp(resctrl_val, CMT_STR, sizeof(CMT_STR))) {
-			ret = param->setup(1, param);
-			if (ret) {
-				ret = 0;
-				break;
-			}
 			sleep(1);
 			ret = measure_cache_vals(param, bm_pid);
 			if (ret)
 				break;
-		} else {
-			break;
 		}
 	}
 
-- 
2.39.2



