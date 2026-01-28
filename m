Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734BA352940;
	Wed, 28 Jan 2026 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614035; cv=none; b=LM3ydhiaq0itCsV9UzHZBOmoLfhgSJg5XOpCWIwe+grcoFfmLjjcjN4pXI5AYoeKI3GIiw0OkgkHSvAR+Ci2swzeabUUHdkfVp7fKUPOsLewBbbRDzEPA49Z6hyEhWvt+oNVBhUWagEKZPkHMx5vyoZEYw4sYJyclHkzJGtwr5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614035; c=relaxed/simple;
	bh=MYpDWDzAlrTFsHKCb/WAyAGdaIrrJ94qDmLIFlY085E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duumvZS4awQaX80czY+VnSUMnm+Zi/AN2J434ymHhoLXL/WuzvVQ/zUA5jXnTZzLllpQW37sOrYQ+eDK6y54HMAj/wJLp+VQ5EQC5ZmKFvGov1BVZ7Q+U1HqMcvthJMzeAmGes+Oq5SYTCPUOoMWLQOkHzMa6qKAiC+8UGI1cfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ol8BoKoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ol8BoKoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7059C4CEF7;
	Wed, 28 Jan 2026 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614034;
	bh=MYpDWDzAlrTFsHKCb/WAyAGdaIrrJ94qDmLIFlY085E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ol8BoKoNvNsBlsORJelU+0/fcoVa9/n5x0DkZEQCWlrY7PtqjUCgP8pZKK4yfK2Mo
	 bWKaVgxRow9/hPRFl4UJQPpYgl7lxoIaZ4A58TcIweZtlf3FqDaiIdk5+85hTnmSts
	 SlHuPC++NIH36h3/snu0bhapF3JoElpzsC4+MUMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/254] vsock/test: add a final full barrier after run all tests
Date: Wed, 28 Jan 2026 16:19:53 +0100
Message-ID: <20260128145345.326807648@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit c39a6a277e0e67ffff6a8efcbbf7e7e23ce9e38c ]

If the last test fails, the other side still completes correctly,
which could lead to false positives.

Let's add a final barrier that ensures that the last test has finished
correctly on both sides, but also that the two sides agree on the
number of tests to be performed.

Fixes: 2f65b44e199c ("VSOCK: add full barrier between test cases")
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260108114419.52747-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/vsock/util.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 01b636d3039a0..751fe7c6632ea 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -360,6 +360,18 @@ void run_tests(const struct test_case *test_cases,
 
 		printf("ok\n");
 	}
+
+	printf("All tests have been executed. Waiting other peer...");
+	fflush(stdout);
+
+	/*
+	 * Final full barrier, to ensure that all tests have been run and
+	 * that even the last one has been successful on both sides.
+	 */
+	control_writeln("COMPLETED");
+	control_expectln("COMPLETED");
+
+	printf("ok\n");
 }
 
 void list_tests(const struct test_case *test_cases)
-- 
2.51.0



