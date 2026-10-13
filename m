Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB464F4026;
	Tue, 13 Oct 2026 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892929; cv=none; b=DE8ia9bWNxBV34c4JeAhALQrMULz7Afp1ooSE1bQqzRqDMO0BoPv+geVwzUc7wa3i17tfkCx4joNDmGqVNTBIGhicriE1yo9LHMf0o6/MlfhnWNcMbOeaKRaL878ss2xc6+kniujkiaJJaHlfXxsB4tCXYldOCIqp0EJFHkmXek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892929; c=relaxed/simple;
	bh=z29mv79GonsIIEJE3XwZWOUqnByt1UNO3iHBFwJ3hj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTtGY5nDHyMD21B9MiiKMB+1kVK3PYPTu+DdMWmBoRjCOewflkssHy5kcyOrvjBH76o6m9AY85n8CbRgPQxkYdTBye4XB63uvLU2Jut2HV7XVydFZZbkYqkcoWm8SpvGHWw9W2UB3hLaIjlduRed+Pyxzap257LyrnY/Ji34+Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5sxooz2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5sxooz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2E51F00893;
	Tue, 13 Oct 2026 12:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892928;
	bh=sMOeBNXUVQRjf8rrDhCWztVHAbZkpBkKkPjqSK9jMXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5sxooz2+vuI1+ovcD9yhwZ30GOoRItwDrtuspFmQ6d7phwJWGm+ltx2MWL6RioGc
	 vuuDNDPZDX7fdH/TfqgZbocG10SMOvK0AQFyejB2X9u7bjiBhEDd1Ah0H/qg+XzA5c
	 tZY85ql1N19WhMyeXXoISR7IYX1SGFX7LUYcH40I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Hui Peng <benquike@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 053/621] sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute
Date: Tue, 13 Oct 2026 13:30:48 +0200
Message-ID: <20261013112922.121692861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

commit 538b529509c7ab0d909cb65bb7264edca1788d30 upstream.

When an SCTP stream output extension structure (streamoute) has not yet
been allocated, sctp_getsockopt_pr_streamstatus() sets the local stack
variables params.sprstat_abandoned_unsent = 0 and
params.sprstat_abandoned_sent = 0, but then immediately jumps to 'out:',
bypassing copy_to_user(). As a result, when an uninitialized user buffer
is passed to getsockopt(SCTP_PR_STREAM_STATUS), the kernel returns
success (0) without copying the zeroed stats back to user space, leaving
uninitialized data in the user buffer.

Refactor the !streamoute check into an if-else chain so that when
streamoute is NULL, params is zeroed and falls through to copy_to_user(),
copying the zeroed stats to user space and setting retval = 0 once before
returning.

Tested in QEMU against Linux 7.3.0-rc3 using an uninitialized
sctp_prstatus user struct passed to getsockopt(SCTP_PR_STREAM_STATUS) on a
freshly created stream: on the unfixed kernel the user struct contains
uninitialized stack garbage; whereas with this fix applied, getsockopt()
copies zeroed stats into user space and returns 0.

Cc: stable@vger.kernel.org
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Hui Peng <benquike@gmail.com>
Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
Link: https://patch.msgid.link/20260930044611.204739-1-benquike@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7516,11 +7516,7 @@ static int sctp_getsockopt_pr_streamstat
 		/* Not allocated yet, means all stats are 0 */
 		params.sprstat_abandoned_unsent = 0;
 		params.sprstat_abandoned_sent = 0;
-		retval = 0;
-		goto out;
-	}
-
-	if (policy == SCTP_PR_SCTP_ALL) {
+	} else if (policy == SCTP_PR_SCTP_ALL) {
 		params.sprstat_abandoned_unsent = 0;
 		params.sprstat_abandoned_sent = 0;
 		for (policy = 0; policy <= SCTP_PR_INDEX(MAX); policy++) {


