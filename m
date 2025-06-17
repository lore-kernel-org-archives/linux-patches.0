Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97E128E8;
	Tue, 17 Jun 2025 15:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175134; cv=none; b=bellIs9vhZl2gBePqkyCiZPScDKHsqt+v/UTctwnzFUO8B6tlebkxrfLsW0lrP4I4Bv49hlKIi//ySuE3AutPnV0e4p9n5APK2bhJx+HlZBVRERc4TCkZsvx3v4LyUaPx937YnYVmJsycAIjBRjT53q0h7s35yAQyHpXEBWhHEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175134; c=relaxed/simple;
	bh=f074JPNfSXQwER2axyecsDc0xuu83vn9Xqg5B0W/y4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mrirk6llI2d//eQ1kiGBzn81mDY1C1+gX4W9Op8djHisbAL4zpFj7Zv77IVFogbzT1+7IIjxOGYiOYq17RQGAJ6eGz6FVDEcCU5KZ4B1obUnnWjev8fCovTKg5/recg5MSmrEDaNuiCypmgePMAnPvAjyZOPy2DvrNezrMn1lXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwWAV/wm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwWAV/wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDD4C4CEF0;
	Tue, 17 Jun 2025 15:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175133;
	bh=f074JPNfSXQwER2axyecsDc0xuu83vn9Xqg5B0W/y4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwWAV/wmUst9QYZle0LRQVY5bl2XWWb3e4HMOE4aoyjtl/xbm0c0Let3xT101HljD
	 TN4R49zbwubyD9lI/CEhdBm52nNFxq6xEdLX6ikutlnayMXBTA9kfwCQ1ducykVPP7
	 dFeRbA9BETow1DNEgiZiew0+LreR28E0eoDN1ZVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 034/780] kselftest: cpufreq: Get rid of double suspend in rtcwake case
Date: Tue, 17 Jun 2025 17:15:42 +0200
Message-ID: <20250617152452.891948965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



