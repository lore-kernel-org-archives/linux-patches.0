Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6EB223320;
	Thu, 12 Dec 2024 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018781; cv=none; b=r+e5hKZKNvUZhqCP2dHmJTeO+r2uK+24ehGDOPuLP0Ks64Qwur4CxwwSLD2fUUPP3c1d+QyjAOJpKL6/XPA0GgxzSjMaawWYVGeHwMzK2BGoXd54A5ppYwqzpiOcg0s6vAwDx6AcL3xCy+Y2gkyP95wi+YVo/1QHodRatNmOY1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018781; c=relaxed/simple;
	bh=y0ybwP3DXUtsLKGlz+ogD9ajeeHPJkBI7gxIuJ36iRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5agnd4jKtkfszeFQVwY7KdV3yuYy+bVxp34Thl3TFRTYCJyidARKa7azKr9jfBKpg5V3L8Z0DbbbKoBDfZJKHFu3LAlUMz4nZcqeviW1xJ9AVHBMavxJWTJ+5/mY4wjFvEZgN6y0jRT7k7OyY7/J9tziE3TJADFincynHLtN9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EodMNV50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EodMNV50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9F5C4CED0;
	Thu, 12 Dec 2024 15:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018781;
	bh=y0ybwP3DXUtsLKGlz+ogD9ajeeHPJkBI7gxIuJ36iRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EodMNV500G/UJYUS5M+vbkoLgD9catvozeQnoi/2V5/iQqw3sCh5e4Jpb0wC2xJCD
	 VnXc/kP20m6zqZHAhvh3wxl7Pt0hBgfylqHFUf5LAGJd7fXfFt9eNqkSA+ockoTTYs
	 GpPM1uounToT+RkgKcLJi3FmaiTM1gOXU53soXGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/772] selftests/watchdog-test: Fix system accidentally reset after watchdog-test
Date: Thu, 12 Dec 2024 15:49:12 +0100
Message-ID: <20241212144350.244426615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit dc1308bee1ed03b4d698d77c8bd670d399dcd04d ]

When running watchdog-test with 'make run_tests', the watchdog-test will
be terminated by a timeout signal(SIGTERM) due to the test timemout.

And then, a system reboot would happen due to watchdog not stop. see
the dmesg as below:
```
[ 1367.185172] watchdog: watchdog0: watchdog did not stop!
```

Fix it by registering more signals(including SIGTERM) in watchdog-test,
where its signal handler will stop the watchdog.

After that
 # timeout 1 ./watchdog-test
 Watchdog Ticking Away!
 .
 Stopping watchdog ticks...

Link: https://lore.kernel.org/all/20241029031324.482800-1-lizhijian@fujitsu.com/
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/watchdog/watchdog-test.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/watchdog/watchdog-test.c b/tools/testing/selftests/watchdog/watchdog-test.c
index f45e510500c0d..09773695d219f 100644
--- a/tools/testing/selftests/watchdog/watchdog-test.c
+++ b/tools/testing/selftests/watchdog/watchdog-test.c
@@ -242,7 +242,13 @@ int main(int argc, char *argv[])
 
 	printf("Watchdog Ticking Away!\n");
 
+	/*
+	 * Register the signals
+	 */
 	signal(SIGINT, term);
+	signal(SIGTERM, term);
+	signal(SIGKILL, term);
+	signal(SIGQUIT, term);
 
 	while (1) {
 		keep_alive();
-- 
2.43.0



