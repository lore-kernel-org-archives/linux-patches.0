Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752D846EC75;
	Tue, 21 Jul 2026 18:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657903; cv=none; b=i0vOlQT5ZFahfR8q5X3vSOSVCHUgB/3sUThddzF+clpPKDqLKvjEuBKkMbSYN3qVYT+RUFgPw07cGdbNxvY1djuaENDK/BiNnH0wBldiQHC0FnBAUp8l7yYRhDt2yfjYOguDASP+e6959U58f7TRmB2Cr4fVIRUzH44sbDXzmRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657903; c=relaxed/simple;
	bh=ZAxo6xgx9+MeAdxoV29u7OvKfsmCBP4HxbHuNZY9deE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgEW/NcBq4b0FukJ0ixKIjQiZSY7PLclh1tm17Kdnazeq9MjkYtWMycLfJ0474K5rveivJePWL7Ic5m3ZkCZokd1Lu2dJlno6PBnny/VF3kbd+4LytWGHeBP1FrrXKSYBHQXuouNO46HsLDRfcFdiaLGtNJX5Y+dVzPTHQ/77HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcWd75tG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcWd75tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E481F00A3D;
	Tue, 21 Jul 2026 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657902;
	bh=HEpeODjPmTKq6b3ow/hapBplwjC/o8bjjuZtgofIWcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcWd75tGIBhjg5P2JExwvyDCwHBjCwU6VMxaJLIyH/GI2KdRUFcddCrwMGs5ZLriJ
	 268Gps+fzUFVjWaP4NQCjfuQHNbkdwYrL9dXVnKQD52ByORB4Bg+rEB3momCBFxJM9
	 RCGlkWRo9UByjpHibAHMO7NzO0RkNMngCq+gft84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0942/1611] selftests: tls: size splice_short pipe by page size
Date: Tue, 21 Jul 2026 17:17:38 +0200
Message-ID: <20260721152536.573528619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5c6d8215021c9c..6dc9b5da738c82 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -954,6 +954,8 @@ TEST_F(tls, splice_short)
 	char sendbuf[0x100];
 	char sendchar = 'S';
 	int pipefds[2];
+	int pipe_sz;
+	int ret;
 	int i;
 
 	sendchar_iov.iov_base = &sendchar;
@@ -962,7 +964,11 @@ TEST_F(tls, splice_short)
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



