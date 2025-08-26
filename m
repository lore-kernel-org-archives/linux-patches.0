Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A432A34F47D;
	Tue, 26 Aug 2025 14:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216809; cv=none; b=K8KEMhmBIK1x7ECv3ENgtkg9ZeEkq8o2eTFCcL8bdLn8VjNMzm2tAtyiPGklYo4MyQb3Sw/cFXr6NmXgKsrRISHwW0yKgK26uSA6e3gRowXbx+erR4R/9fJj2fqziQ3UFBre2N1KZt0A/TRBoNG+X9zCgNdezVjHcoZ6ybemKiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216809; c=relaxed/simple;
	bh=3YHn6wJWKXiLXWMG6hlzRTPTG5d0JwcOcC3nKUQo6q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ht7o//n7XM53e4JFHT6tNq9VtrNRARls4m/XVyF+9DsexwFunAff760HOogJPnRNGS9gTh1CWB9klk4kGwgPIKKCusvrhEM2iH1XEMDLpq3uJsAING8oPz6mCn/ZrVi9OZIDVu8v/uHLHzLxxeWYZjzzYJflYBQBibXc/kypfUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZPYnSCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZPYnSCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37191C4CEF1;
	Tue, 26 Aug 2025 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216809;
	bh=3YHn6wJWKXiLXWMG6hlzRTPTG5d0JwcOcC3nKUQo6q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZPYnSCNwnPhYI05Ym8QMo7p4OMzU1B87AVR0bi7ifsQCk7siLbAmMhy1Qb4zZ7k3
	 anRXmUpEoKFRbjwRi9VAgwp99W3FWfX8WjhH/0Lfh/WguVi2+Lu2sJ1QeDQNC/KvEY
	 flVZc4kbr3HrHYEB/QecCg+3UlCG+Ga9E+fBVwkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiumei Mu <xmu@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 552/644] selftests: mptcp: make sendfile selftest work
Date: Tue, 26 Aug 2025 13:10:43 +0200
Message-ID: <20250826111000.205651040@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit df9e03aec3b14970df05b72d54f8ac9da3ab29e1 upstream.

When the selftest got added, sendfile() on mptcp sockets returned
-EOPNOTSUPP, so running 'mptcp_connect.sh -m sendfile' failed
immediately.

This is no longer the case, but the script fails anyway due to timeout.
Let the receiver know once the sender has sent all data, just like
with '-m mmap' mode.

v2: need to respect cfg_wait too, as pm_userspace.sh relied
on -m sendfile to keep the connection open (Mat Martineau)

Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Reported-by: Xiumei Mu <xmu@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |   26 ++++++++++++++--------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -451,6 +451,18 @@ static void set_nonblock(int fd)
 	fcntl(fd, F_SETFL, flags | O_NONBLOCK);
 }
 
+static void shut_wr(int fd)
+{
+	/* Close our write side, ev. give some time
+	 * for address notification and/or checking
+	 * the current status
+	 */
+	if (cfg_wait)
+		usleep(cfg_wait);
+
+	shutdown(fd, SHUT_WR);
+}
+
 static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after_out)
 {
 	struct pollfd fds = {
@@ -528,14 +540,7 @@ static int copyfd_io_poll(int infd, int
 					/* ... and peer also closed already */
 					break;
 
-				/* ... but we still receive.
-				 * Close our write side, ev. give some time
-				 * for address notification and/or checking
-				 * the current status
-				 */
-				if (cfg_wait)
-					usleep(cfg_wait);
-				shutdown(peerfd, SHUT_WR);
+				shut_wr(peerfd);
 			} else {
 				if (errno == EINTR)
 					continue;
@@ -666,7 +671,7 @@ static int copyfd_io_mmap(int infd, int
 		if (err)
 			return err;
 
-		shutdown(peerfd, SHUT_WR);
+		shut_wr(peerfd);
 
 		err = do_recvfile(peerfd, outfd);
 		*in_closed_after_out = true;
@@ -690,6 +695,9 @@ static int copyfd_io_sendfile(int infd,
 		err = do_sendfile(infd, peerfd, size);
 		if (err)
 			return err;
+
+		shut_wr(peerfd);
+
 		err = do_recvfile(peerfd, outfd);
 		*in_closed_after_out = true;
 	}


