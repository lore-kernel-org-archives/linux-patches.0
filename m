Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1684E2D29C2;
	Mon, 13 Oct 2025 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366874; cv=none; b=aPLCIOZ+3JhZao21SOtOPKYs4kHT5yPuu3eQgUo/4kOvv6Z92eigx/xPgUtZ40J6JXb7k9JswiGDZvUn5XW7FmBfVjPAxY5MhrLh4Dta1mDpiG0l6hUPtvlexUyuIOnsLhaZVi6J0juG3ietisjColpIz9XLOlbnNS+huQblSjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366874; c=relaxed/simple;
	bh=04PAQtjj1saLq56q8HUCE92E6/dieKN5QiBto+ia5NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLaq1Pn2w7fpru95s2IsqLOLhXWUEtQmKoF3dKMFJVjCAjcSgpd2/GVut5rxA3H3fZPfRkBPwzY3dqCs6Q7qs5fkR9uAHYBe5v3dZZJH7DO4L2sRR5zpT10A1B1pqy2GJjZZo0OJcyDUSTiNO4f8xK2O4ESbh7KFc2G3v7zoKY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6IDrX5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6IDrX5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7FAC4CEE7;
	Mon, 13 Oct 2025 14:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366873;
	bh=04PAQtjj1saLq56q8HUCE92E6/dieKN5QiBto+ia5NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6IDrX5Ejle/uLx/10k6SlwLCG3J8XMywLYNShlDHj37Ea9IItWifsoV+KUlV3FZs
	 Z1H+TF8vcQUv8QkXgsOe2hHPcFgFzb01+reoI0FrYM14Tqf1ib5HZR8xxWrIDc4wsH
	 7EmuE5nsvgZdtB+cmofod1vx1exexVjr9zpDOsnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenta Akagi <k@mgml.me>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.1 002/196] selftests: mptcp: connect: fix build regression caused by backport
Date: Mon, 13 Oct 2025 16:42:55 +0200
Message-ID: <20251013144314.643604935@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenta Akagi <k@mgml.me>

Since v6.1.154, mptcp selftests have failed to build with the following
errors:

mptcp_connect.c: In function ‘main_loop_s’:
mptcp_connect.c:1040:59: error: ‘winfo’ undeclared (first use in this function)
 1040 |                 err = copyfd_io(fd, remotesock, 1, true, &winfo);
      |                                                           ^~~~~
mptcp_connect.c:1040:59: note: each undeclared identifier is reported only once for each function it appears in
mptcp_connect.c:1040:23: error: too many arguments to function ‘copyfd_io’; expected 4, have 5
 1040 |                 err = copyfd_io(fd, remotesock, 1, true, &winfo);
      |                       ^~~~~~~~~                          ~~~~~~
mptcp_connect.c:845:12: note: declared here
  845 | static int copyfd_io(int infd, int peerfd, int outfd, bool close_peerfd)
      |            ^~~~~~~~~

This is caused by commit ff160500c499 ("selftests: mptcp: connect: catch
IO errors on listen side"), a backport of upstream 14e22b43df25,
which attempts to use the undeclared variable 'winfo' and passes too many
arguments to copyfd_io(). Both the winfo variable and the updated
copyfd_io() function were introduced in upstream
commit ca7ae8916043 ("selftests: mptcp: mptfo Initiator/Listener"),
which is not present in v6.1.y.

The goal of the backport is to stop on errors from copyfd_io.
Therefore, the backport does not depend on the changes in upstream
commit ca7ae8916043 ("selftests: mptcp: mptfo Initiator/Listener").

This commit simply removes ', &winfo' to fix a build failure.

Fixes: ff160500c499 ("selftests: mptcp: connect: catch IO errors on listen side")
Signed-off-by: Kenta Akagi <k@mgml.me>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1037,7 +1037,7 @@ again:
 
 		SOCK_TEST_TCPULP(remotesock, 0);
 
-		err = copyfd_io(fd, remotesock, 1, true, &winfo);
+		err = copyfd_io(fd, remotesock, 1, true);
 	} else {
 		perror("accept");
 		return 1;


