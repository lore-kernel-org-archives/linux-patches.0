Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDD21E8332;
	Tue, 17 Jun 2025 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174449; cv=none; b=qKVL5yHSLvbXAmTUBEABGvM3OnUy5heve7yqCv2/aLt4uSEOT7RB+b83JtrYG8MZ73MYGSbteLFaZaDaz4b2ZysLsO78fdKvNUerqHn2J93S7izUjumipnWWPYw88RFEW3DU+LPkiWUNG+p/tuwSrB9phO2R+2X0vkl2IDB7FCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174449; c=relaxed/simple;
	bh=Rqq5eORjebg5VgroPGsBjZ/TBs2AkIA2MfR13HwmVxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mYPtZBHjstz9vN74Fl6U6TXvTxdkcBLYxouwo0qHMV/P4Avw0qdkYsrzvA7RgXPgsFk1nuAiR/PuHFT0yYdNif8L4ixf4acPZ1uW2q7SkmPYtA34x6FJ+ew4JgJLMgMggLiE+g7Ui0SxrVytxmIQ+6kdTlmHX6FBJofSJ54dgUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXLiOZZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXLiOZZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A323BC4CEE3;
	Tue, 17 Jun 2025 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174449;
	bh=Rqq5eORjebg5VgroPGsBjZ/TBs2AkIA2MfR13HwmVxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXLiOZZnWYUOQJMt4rgWjk8daO4/szJss7iBbtvWJpgVSMslal0xkrkJcRIYDyhiR
	 YzLPfaPNaTdJzICwMbRsAdIf57MU6D7+bVZXdlNY5/GiOIc4A17BPynzFqdZTynPt8
	 yHJJXDhxrAr4lEzyo5sXrzzmYfDTBif4t5NYQAGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/512] kselftest: cpufreq: Get rid of double suspend in rtcwake case
Date: Tue, 17 Jun 2025 17:19:47 +0200
Message-ID: <20250617152420.390392157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 23b88515a318680337f21d0a2fceee8038ccffc8 ]

Commit 0b631ed3ce92 ("kselftest: cpufreq: Add RTC wakeup alarm") added
support for automatic wakeup in the suspend routine of the cpufreq
kselftest by using rtcwake, however it left the manual power state
change in the common path. The end result is that when running the
cpufreq kselftest with '-t suspend_rtc' or '-t hibernate_rtc', the
system will go to sleep and be woken up by the RTC, but then immediately
go to sleep again with no wakeup programmed, so it will sleep forever in
an automated testing setup.

Fix this by moving the manual power state change so that it only happens
when not using rtcwake.

Link: https://lore.kernel.org/r/20250430-ksft-cpufreq-suspend-rtc-double-fix-v1-1-dc17a729c5a7@collabora.com
Fixes: 0b631ed3ce92 ("kselftest: cpufreq: Add RTC wakeup alarm")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cpufreq/cpufreq.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cpufreq/cpufreq.sh b/tools/testing/selftests/cpufreq/cpufreq.sh
index e350c521b4675..3aad9db921b53 100755
--- a/tools/testing/selftests/cpufreq/cpufreq.sh
+++ b/tools/testing/selftests/cpufreq/cpufreq.sh
@@ -244,9 +244,10 @@ do_suspend()
 					printf "Failed to suspend using RTC wake alarm\n"
 					return 1
 				fi
+			else
+				echo $filename > $SYSFS/power/state
 			fi
 
-			echo $filename > $SYSFS/power/state
 			printf "Came out of $1\n"
 
 			printf "Do basic tests after finishing $1 to verify cpufreq state\n\n"
-- 
2.39.5



