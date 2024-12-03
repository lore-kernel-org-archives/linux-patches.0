Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5261F668D;
	Tue,  3 Dec 2024 14:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237593; cv=none; b=przMr7cbNeRMUF0TSfCWQUogsz5K9lVHOcldi2rzwzPYOwP6H4hMlPzTdkZZ2C9V5xgqe4mQrWtSXzmRk6rdkCRz8YcDdfu7AQ4sm/LtZEvguRRo7f3DUwTPBkymqt7LWeIW9mLdlRb7H2Xg7Or0Z7vsw2960rgGt6U1gocPOnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237593; c=relaxed/simple;
	bh=7isk8Cs+52i4SCaKfPQZKKSyOb/VSx+Lxfw10A7vVTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4wkNUSiZDrDCtkRKO7iW+ZgckKxsOfEZ7ho7t8PddmKmTeJmlVlW/Oa7MfoxRuNorgO3ABzwcTnaPFomzBafZWxgHRkqrXdEEWAt8T9sAXoyO5hAqafJ0jIGKck/T2gxnf9cZssGwsdGr+vuYTuSuvAKt5Ef3oZD7XFrjfmU+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UabQ4Jve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UabQ4Jve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CE5C4CECF;
	Tue,  3 Dec 2024 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237592;
	bh=7isk8Cs+52i4SCaKfPQZKKSyOb/VSx+Lxfw10A7vVTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UabQ4JveK+DbZMwmI0G9KBYbZ8DJzkXRmYwziDgmUrpz02YiwipdohML5mg05feRp
	 irzcu3oEYytFV+4EYNmUitV6C90G0pwQ9BinHZQ5Si2mBSBCIo9ZfRevuC8XcA2jjH
	 lvmDv0o6+Zb1OCHlQYmwKLo3HOes7CCjKaYDNGUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 015/817] selftests/watchdog-test: Fix system accidentally reset after watchdog-test
Date: Tue,  3 Dec 2024 15:33:07 +0100
Message-ID: <20241203143956.233765417@linuxfoundation.org>
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



