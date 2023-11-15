Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6993A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsVhW9+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E514C433C8;
	Wed, 15 Nov 2023 19:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077514;
	bh=2DUWgx4grdJrUj8PD1+WXQXG5hasAqj8VscrpSQhRBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsVhW9+K2ehDKakVPORy9mbG5NykDrNRGoWAsYJeggtnrVtv4fZNWx/yQKaiPOkHy
	 JQj8nXyGnZfIU5kfv1yFifGDJ/Q3p0NTvQPKwrOLh4xW2lSpWUvblkBR0AkAquP8al
	 18uTBatkBUxiVWgt1yfO7mE2mu4K6xKR8NZjng1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 324/603] selftests/resctrl: Ensure the benchmark commands fits to its array
Date: Wed, 15 Nov 2023 14:14:29 -0500
Message-ID: <20231115191635.918382478@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 4a28c7665c2a1ac0400864eabb0c641e135f61aa ]

Benchmark command is copied into an array in the stack. The array is
BENCHMARK_ARGS items long but the command line could try to provide a
longer command. Argument size is also fixed by BENCHMARK_ARG_SIZE (63
bytes of space after fitting the terminating \0 character) and user
could have inputted argument longer than that.

Return error in case the benchmark command does not fit to the space
allocated for it.

Fixes: ecdbb911f22d ("selftests/resctrl: Add MBM test")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: "Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl_tests.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/resctrl/resctrl_tests.c b/tools/testing/selftests/resctrl/resctrl_tests.c
index d511daeb6851e..9e2bc8ba95f13 100644
--- a/tools/testing/selftests/resctrl/resctrl_tests.c
+++ b/tools/testing/selftests/resctrl/resctrl_tests.c
@@ -255,9 +255,14 @@ int main(int argc, char **argv)
 		return ksft_exit_skip("Not running as root. Skipping...\n");
 
 	if (has_ben) {
+		if (argc - ben_ind >= BENCHMARK_ARGS)
+			ksft_exit_fail_msg("Too long benchmark command.\n");
+
 		/* Extract benchmark command from command line. */
 		for (i = ben_ind; i < argc; i++) {
 			benchmark_cmd[i - ben_ind] = benchmark_cmd_area[i];
+			if (strlen(argv[i]) >= BENCHMARK_ARG_SIZE)
+				ksft_exit_fail_msg("Too long benchmark command argument.\n");
 			sprintf(benchmark_cmd[i - ben_ind], "%s", argv[i]);
 		}
 		benchmark_cmd[ben_count] = NULL;
-- 
2.42.0



