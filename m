Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CAD1F76CE;
	Tue,  3 Dec 2024 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240041; cv=none; b=aV/no++AAGIpQB15RlESAqQw+meDJQdG9ZY98C57YP/hr7hkITCUc+FLdjDIVTqE4HtwCAEDxp22dHigxDpwxMMNFTv6XT0rdHKXgI9SNnLCEqsPMrbzbqCF/9WY5G8PC8Apxa87BnSEyvcSQrYZAgzQnOwhxsiJ0gzBuKtZEMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240041; c=relaxed/simple;
	bh=xi3OpyQN02erjHC2Z138Pa8dXteOxTgQppeeHjmyGFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUH0mHQfAUjUxOMCMuDYoNmnimafE04KUNp/qmNjXFLvftZkuyZAFvxpPJ251YnmtsTZiVfltdzLkvVkY00ppXW76U4TPHjEJw5rncX2pKwWeNHvjlg70Jxot32Wyw+zA8mOFLT2wmIQzkA40Fy4GNeYIc8StPFstS9B7KJBJKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yr7Yzvrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yr7Yzvrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EC6C4CED6;
	Tue,  3 Dec 2024 15:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240041;
	bh=xi3OpyQN02erjHC2Z138Pa8dXteOxTgQppeeHjmyGFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yr7YzvrpytIXvVD4nkBc2NPVx34f9/fZhJJqgRXj+MkwSvNCIne+jvWn99ahKbpMB
	 3Cdn7qTVzCzpYxDH4uEWUmrQzdfYCfF/MJ9gf4Es+OuDNRqj0H5TGQovOM8qourIIX
	 GLnempTUTPS7tFO/3fxIzY9tMgAjeUsnE2xEGz7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 814/817] tools/power turbostat: Fix trailing \n parsing
Date: Tue,  3 Dec 2024 15:46:26 +0100
Message-ID: <20241203144028.228912848@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit fed8511cc8996989178823052dc0200643e1389a ]

parse_cpu_string() parses the string input either from command line or
from /sys/fs/cgroup/cpuset.cpus.effective to get a list of CPUs that
turbostat can run with.

The cpu string returned by /sys/fs/cgroup/cpuset.cpus.effective contains
a trailing '\n', but strtoul() fails to treat this as an error.

That says, for the code below
	val = ("\n", NULL, 10);
val returns 0, and errno is also not set.

As a result, CPU0 is erroneously considered as allowed CPU and this
causes failures when turbostat tries to run on CPU0.

 get_counters: Could not migrate to CPU 0
 ...
 turbostat: re-initialized with num_cpus 8, allowed_cpus 5
 get_counters: Could not migrate to CPU 0

Add a check to return immediately if '\n' or '\0' is detected.

Fixes: 8c3dd2c9e542 ("tools/power/turbostat: Abstrct function for parsing cpu string")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 089220aaa5c92..aa9200319d0ea 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5385,6 +5385,9 @@ static int parse_cpu_str(char *cpu_str, cpu_set_t *cpu_set, int cpu_set_size)
 		if (*next == '-')	/* no negative cpu numbers */
 			return 1;
 
+		if (*next == '\0' || *next == '\n')
+			break;
+
 		start = strtoul(next, &next, 10);
 
 		if (start >= CPU_SUBSET_MAXCPUS)
-- 
2.43.0



