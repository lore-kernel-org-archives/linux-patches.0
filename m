Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1754149C69;
	Fri,  6 Dec 2024 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496563; cv=none; b=DF/VjfjivcXB+DlUnlGYMDsPDhwJky3Cil4ZeoQKENQmJf41Y+iBZU0uN4RRIk8zU/myhu7VlSIfUHGNI5Vh0vqeTAXXmWojY/b1iqoXY/XeF2eRa7AINcbC+99vAjPqqa/Cln+WH9MVVUi0cLQ0/wqgSUsB991JhLvwy8nt+pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496563; c=relaxed/simple;
	bh=+Mcn2nOUJESUeLs0vGaVdrd38rGW6rzzFwpOIuz8iVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPio57l+LkK6GxMFUcGCyEBCRT8D4LLeWeCAoXi6SLdV5Wa00whKWQ9vRWVNUm7AH+YRWvhYh04qIev38F0aa6KN/Zd933YD5uekFk20yZX0Jw59p+dOm88FFtfr5BUMKGROMCWUrFM7sBQV7nQJd2X2hA85hkMzAF8jmuvol9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8+VlbfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8+VlbfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272F3C4CEDC;
	Fri,  6 Dec 2024 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496563;
	bh=+Mcn2nOUJESUeLs0vGaVdrd38rGW6rzzFwpOIuz8iVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8+VlbfEINMp1tTdPEFPPs9BnEGUGcb3snhEwc6r1ySYyY0a60ioOVo5hyR0lRwm3
	 ayBFur9gSE8TapdLYoqjQx5Akt04G0SblpU/IcmMcYm2Bzf6P5BUYoai9kCgU0ouEH
	 XEfHvqldFA3Z4R1lc2HaZ3jgNPR10m/Ilvp8Vpss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/676] selftests/watchdog-test: Fix system accidentally reset after watchdog-test
Date: Fri,  6 Dec 2024 15:27:09 +0100
Message-ID: <20241206143653.760640315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index bc71cbca0dde7..a1f506ba55786 100644
--- a/tools/testing/selftests/watchdog/watchdog-test.c
+++ b/tools/testing/selftests/watchdog/watchdog-test.c
@@ -334,7 +334,13 @@ int main(int argc, char *argv[])
 
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



