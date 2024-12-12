Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D146213CA93;
	Thu, 12 Dec 2024 17:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023653; cv=none; b=Ferl2CQzoo3+8uhZMR46jLiAvvA5c7tvnpXwKqAfQrH4T42a5heVSQDqq2HvkxC0poDEXwlpeHsEXIsiU1+BdbZkWZYBrgNIducVyq1S2sicgVUBJkVfHDROAPQM/abDYKjmt8WS6NRVeHnaL8I5bE7WYPBchz+9OibNMKaTD8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023653; c=relaxed/simple;
	bh=oExNaZldSXpeKNjc9AoSkW2hjtEMRid1TlEoF4CpNYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbEbl/yxsGech8fIFfx6DQ6/GfyQNuzJ5kSV+o8/BF3TsqWvgOytGRot/JmFuOjrbJ576qMjwZ6usK7M74GA+7E4i3gu4prmC1eNjVyrMVOicw9+mZ36C5Tg5l2jH1h7AQ62h+nYQCe6/Ixba8MC+rFXDF3AY27HiNcmbMIz8AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6pH3sXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6pH3sXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C20C4CECE;
	Thu, 12 Dec 2024 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023653;
	bh=oExNaZldSXpeKNjc9AoSkW2hjtEMRid1TlEoF4CpNYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6pH3sXV7MXFn1U1nobK7dIhZ21ZSeU8Zyt+kU1i68ze/YxvdDsDpWXmJK3nBPQDk
	 MA1gCZ04RHzhWeoMmTPw7HwpuT1OTfECbouiFU9hk5PYavI1gtDBqsSPe4gd6qHvnd
	 qh3EJM17Cyqn3i5gFi0HXDvRydKQ3Mt2pfzkp7OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/459] selftests/watchdog-test: Fix system accidentally reset after watchdog-test
Date: Thu, 12 Dec 2024 15:56:16 +0100
Message-ID: <20241212144255.030971151@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



