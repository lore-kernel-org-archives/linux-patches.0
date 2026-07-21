Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE172417D67;
	Tue, 21 Jul 2026 19:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661281; cv=none; b=OENxZAlIfWDif4Aq/1fHAjZ0eOycbgmCh0Tp3HBe9Ti29pLzh7OymBhMoNs3+gea5dhctGYebO3j73ccdSJIc/klHGlOv/coq8wTdgBg1xodW19fdbDrfLRiQZm+oUSIbki/dl9v1ayNzC6hUdQ+VsVCKkhg2s/FJU6HRe6PZjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661281; c=relaxed/simple;
	bh=jF/ej3NkWKz8eyPrmQMpZ50770RL5fbmu+xAqNSi69U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ng70KFiKJYPDkBMPnRq4ii20fugAq8ChbBU88TdI70RjaBaHFZ90Kdzerbk2A9WpJ02xHiC4ec4CzggROpSmsP26QGQswPIWo3QYqmpGuBa8T4vAB8vLKrFWPDz2OGzBFEl524RLzuq5HWY0hvldi0gC5PGDCLcui5tC5X5X3Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koxIwmv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koxIwmv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD101F000E9;
	Tue, 21 Jul 2026 19:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661280;
	bh=uvXXNQAPo3PjPLBTmJobite8YpSI+UX0iB1o371so48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koxIwmv+5QpEB6OsyuWtVEMHFJyJYFvOZwpiJdgINatRFQu4z3PzECt8Dpv/W+XIZ
	 X35xoct0NU+h2nbYFJ7VXsdePPqwBuk5R2ZX7u6Ik5nJrVMoaryqmFeNtUHVy7lZR3
	 Rl7wQ2IGX5wgXaEQxgH23w5ZlIBEQpcgTIGEVp1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1300/2077] selftests: tls: size splice_short pipe by page size
Date: Tue, 21 Jul 2026 17:16:13 +0200
Message-ID: <20260721152623.483312448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoyd@nvidia.com>

[ Upstream commit 3e52f56875c6fafee619b5c2b4ded25f2efbd2ec ]

splice_short grows its pipe with (MAX_FRAGS + 1) * 0x1000 so it can
queue one short vmsplice() buffer for each fragment before draining the
pipe. That assumes 4K pipe buffers.

On 64K-page kernels the request is rounded to 262144 bytes, which
provides only four pipe buffers. The fifth one-byte vmsplice() blocks in
pipe_wait_writable and the test times out before it reaches the TLS path.

Request enough bytes for the same number of pipe buffers using the
runtime page size, and assert that the kernel granted at least that much.
If an unprivileged run cannot raise the pipe above the system
pipe-max-size limit, skip the test because it cannot exercise the
intended path.

Fixes: 3667e9b442b9 ("selftests: tls: add test for short splice due to full skmsg")
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260624134416.3235403-1-nirmoyd@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 30a236b8e9f733..d805a7dfbdd512 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -997,6 +997,8 @@ TEST_F(tls, splice_short)
 	char sendbuf[0x100];
 	char sendchar = 'S';
 	int pipefds[2];
+	int pipe_sz;
+	int ret;
 	int i;
 
 	sendchar_iov.iov_base = &sendchar;
@@ -1005,7 +1007,11 @@ TEST_F(tls, splice_short)
 	memset(sendbuf, 's', sizeof(sendbuf));
 
 	ASSERT_GE(pipe2(pipefds, O_NONBLOCK), 0);
-	ASSERT_GE(fcntl(pipefds[0], F_SETPIPE_SZ, (MAX_FRAGS + 1) * 0x1000), 0);
+	pipe_sz = (MAX_FRAGS + 1) * getpagesize();
+	ret = fcntl(pipefds[0], F_SETPIPE_SZ, pipe_sz);
+	if (ret < 0 && errno == EPERM)
+		SKIP(return, "insufficient pipe capacity");
+	ASSERT_GE(ret, pipe_sz);
 
 	for (i = 0; i < MAX_FRAGS; i++)
 		ASSERT_GE(vmsplice(pipefds[1], &sendchar_iov, 1, 0), 0);
-- 
2.53.0



