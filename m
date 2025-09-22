Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279D6285C92;
	Mon, 22 Sep 2025 19:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569755; cv=none; b=DeqqgM90R/qeU6BYoblqy3iw9NUR3HzEZYYE0I6ScCc6kGlRS0KZR1OpxFm6F81Nb8TubX5dKvgjsl6vTu7B2Mv4FDfJLMnOmj9Lv+/H11089XRvMLcLbAt/yONpOvs5mqKiMRg4kEQmtC2QCAY9gO+3pGrsQSov4yP1IynUNMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569755; c=relaxed/simple;
	bh=MIkqEtTCGoanBmSMEDkj8hI8UJbFa1dlivIZdgtoswo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EibkKtDdFILSzd3sfzxHuF23L9MTvdLob5KuI+vV0/VoSnBUj4p4KRcr8Le1BWxEHuNWgX31/vZkdHEysx2XmXf1qmhwBuX793sTENuZnjaRhSkbzM8AfQ6bNDw0Jp5lZk6UVHxs+Y0OkPB05OIaFxwgaw8eDG8+RlHPfXuXvIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qg0TW5Ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qg0TW5Ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D6AC113D0;
	Mon, 22 Sep 2025 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569754;
	bh=MIkqEtTCGoanBmSMEDkj8hI8UJbFa1dlivIZdgtoswo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qg0TW5HtagqxUcFIttkfHu9FeTvqdBI3C95an7koM4xJ6dpx8hNo6ynyCaLTTGH8p
	 oE3c/O3IubZ0ZPd+33ztLSYmsrQ9Pof2ywgfCTHqgjeFO70aEAkFBJx30nHWj7DhTx
	 y57iXAS21q4+QeIUETwIfzMzzl2fNEwCjhYhxTLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 44/70] selftests: mptcp: connect: catch IO errors on listen side
Date: Mon, 22 Sep 2025 21:29:44 +0200
Message-ID: <20250922192405.797143176@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 14e22b43df25dbd4301351b882486ea38892ae4f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1079,6 +1079,7 @@ int main_loop_s(int listensock)
 	struct pollfd polls;
 	socklen_t salen;
 	int remotesock;
+	int err = 0;
 	int fd = 0;
 
 again:
@@ -1111,7 +1112,7 @@ again:
 		SOCK_TEST_TCPULP(remotesock, 0);
 
 		memset(&winfo, 0, sizeof(winfo));
-		copyfd_io(fd, remotesock, 1, true, &winfo);
+		err = copyfd_io(fd, remotesock, 1, true, &winfo);
 	} else {
 		perror("accept");
 		return 1;
@@ -1120,10 +1121,10 @@ again:
 	if (cfg_input)
 		close(fd);
 
-	if (--cfg_repeat > 0)
+	if (!err && --cfg_repeat > 0)
 		goto again;
 
-	return 0;
+	return err;
 }
 
 static void init_rng(void)


