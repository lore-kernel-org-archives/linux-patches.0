Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938361F4707;
	Tue,  3 Dec 2024 14:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236412; cv=none; b=pOZK39kp9kxjAVZazypIGjAfnIeMUHIKFuS7+TU+E3S5PA4J7uJHCgc8Ybpvk557YvBIbKvp0GnVscgn4hICnd8bj+mFu/fi/enZaN5dYeEjeQiXaz/b6FOb4NjZAuWZvrl/8/LD7M+BeeQJfH5DvsPR/vPDaHsI330qbbur4PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236412; c=relaxed/simple;
	bh=1C09LX5XBMpY5kKIb7dzhheXoNdjyqIkWSpWltvRZZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjXP8FuE712kT+A+K4O+Hvnm0qwn/0YCBVkaWrrP4b394OA4E4jvvYgo8dHly7hwEghDorZllCSoz05vLgd6VPA+ab/Ad8aJAu6thMB0tzrJedKTCT1VQ786pdX+5cbd0gts/zhj3vzlZvJEeOBSvjtDr/jPBP9qx2luB1dARgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doeAt//P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doeAt//P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626F0C4CED6;
	Tue,  3 Dec 2024 14:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236412;
	bh=1C09LX5XBMpY5kKIb7dzhheXoNdjyqIkWSpWltvRZZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doeAt//Pmug7bV3HErUc7cTgAocRPxA447b/5leNhKzS1xCDbc5O88hiDFiAFbDID
	 vwrunFk0hmhUlz7jVm+/rKHDdbOUwD1I/oAlpjl2i43ymW2cTpVBHIhwUC3HK0ODBw
	 PC9+QYbrfJdVtnG5+ijwwJCQ+W5Q0CZrN3fSimRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/138] selftests/watchdog-test: Fix system accidentally reset after watchdog-test
Date: Tue,  3 Dec 2024 15:30:41 +0100
Message-ID: <20241203141924.012077948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f1c6e025cbe54..561bcc253fb3e 100644
--- a/tools/testing/selftests/watchdog/watchdog-test.c
+++ b/tools/testing/selftests/watchdog/watchdog-test.c
@@ -152,7 +152,13 @@ int main(int argc, char *argv[])
 
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



