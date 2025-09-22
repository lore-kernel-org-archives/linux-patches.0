Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08E51C1ADB;
	Mon, 22 Sep 2025 19:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569979; cv=none; b=QHplahUIllLn2Ty+GCt4ah5kb1zwyymeNj67hFfeKC+pyzXiWFRQPX2lXzbyOtEk9StbbBik4dVjqpabUdhK5U4zisoMqtFUcE4P5ZLJIN6gugG5C6n0jux+lYmaNKt9ik6wDtz792mzuk+b5sEGoz/oa5smZgZCxrYWWO8wo6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569979; c=relaxed/simple;
	bh=vB9ZZ3jJAwwfzhyKCC44K1qEE8i3xPs8FbBDU1ekoq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljE6KBd2InxV0HMnFA6xciFMxBWf+it7YkfKz80W0vApZsoCJtrGoTKq+8ie4zLhvunYjmLf/AYOK4QX/rIVWFDI3B80FbNdk3uugkYUbKQAHCeWgcXmMeniQZaKFrkH2E0wDtNe8k0aM9yR46rOXckcOcjaxBhL0JhliZcIYms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXX3M9hK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXX3M9hK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D324C4CEF0;
	Mon, 22 Sep 2025 19:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569978;
	bh=vB9ZZ3jJAwwfzhyKCC44K1qEE8i3xPs8FbBDU1ekoq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXX3M9hK2pFNonAjVStI292XWaRIgHN0MI6o20t3Et+D9FFmUQfAW3UuCMjBNwG5/
	 MfY8IWTNFY15KAnbPjpYLSYv3uaQPek1K0VCMOeL08MDQBK5QU5gG5b+osvcZZsUp3
	 wc70lZc6J8cw1ZN9JDA8dVcjmcYURnWCo/AlA+sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 063/105] selftests: mptcp: connect: catch IO errors on listen side
Date: Mon, 22 Sep 2025 21:29:46 +0200
Message-ID: <20250922192410.561908082@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


