Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAB827FB2D;
	Mon, 22 Sep 2025 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569635; cv=none; b=Je7N5axtzzG7EqlJXRIq2TSykv9KzPUlNP5l/Qjbq3YUulffLyyI3E8LDqy6AuY2ty4A/t1E9+rP6IxN6mhPDBo81hqrtEsb08ASkfEpLYWh+8i27S/MnAxwLOAYn/Zj/XUfMQ42BF2mL41Idp5IsH6ozMA35b5nwtZ5ZnjQx14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569635; c=relaxed/simple;
	bh=1kUSaPTar/QedIT4qIdXwhnPQPWHnfgQsnspIgujXbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvJvhRHPNfhOokWpTVcSB8xp9pYUi+C01GNM7uj0sBBPBIlIV68vjX0SF7ygPIAeVqf6WiK5tuycks8yGYsEyrSHadNJ/h+AMySrO1CahKErTg2QsehSNrIqyqn0hRQGOFx3EZngcxgZO7OzNw8hMPCQFnYfkoqaf/aO3hCJvnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZKcO04y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZKcO04y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8E6C4CEF0;
	Mon, 22 Sep 2025 19:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569633;
	bh=1kUSaPTar/QedIT4qIdXwhnPQPWHnfgQsnspIgujXbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZKcO04yZrIfrXUbeOaXV5PpP/gvVAaDna0seii6aXRkQW51Ew15IvJVBiMHBQpye
	 7Hq1z/bYbu8azJmG7GgQMKa7s56++SG9E4b96OkZICYQRgmQ3h9ypKR0TIIkhdq39X
	 eFXIoZYLwliakmQqmWy89WdvjYqYie7M435OyVNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 54/61] selftests: mptcp: connect: catch IO errors on listen side
Date: Mon, 22 Sep 2025 21:29:47 +0200
Message-ID: <20250922192405.116510779@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 14e22b43df25dbd4301351b882486ea38892ae4f ]

IO errors were correctly printed to stderr, and propagated up to the
main loop for the server side, but the returned value was ignored. As a
consequence, the program for the listener side was no longer exiting
with an error code in case of IO issues.

Because of that, some issues might not have been seen. But very likely,
most issues either had an effect on the client side, or the file
transfer was not the expected one, e.g. the connection got reset before
the end. Still, it is better to fix this.

The main consequence of this issue is the error that was reported by the
selftests: the received and sent files were different, and the MIB
counters were not printed. Also, when such errors happened during the
'disconnect' tests, the program tried to continue until the timeout.

Now when an IO error is detected, the program exits directly with an
error.

Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-fix-sft-connect-v1-2-d40e77cbbf02@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1005,6 +1005,7 @@ int main_loop_s(int listensock)
 	struct pollfd polls;
 	socklen_t salen;
 	int remotesock;
+	int err = 0;
 	int fd = 0;
 
 again:
@@ -1036,7 +1037,7 @@ again:
 
 		SOCK_TEST_TCPULP(remotesock, 0);
 
-		copyfd_io(fd, remotesock, 1, true);
+		err = copyfd_io(fd, remotesock, 1, true, &winfo);
 	} else {
 		perror("accept");
 		return 1;
@@ -1045,10 +1046,10 @@ again:
 	if (cfg_input)
 		close(fd);
 
-	if (--cfg_repeat > 0)
+	if (!err && --cfg_repeat > 0)
 		goto again;
 
-	return 0;
+	return err;
 }
 
 static void init_rng(void)


