Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA9F3B1EE7;
	Tue, 13 Oct 2026 11:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892067; cv=none; b=n7eBqP64Y0lXdUG9kVCjlvBNTJpJ293CgAKSA57NC8//hlVEgbeq+HKag8JZ4FAZSIYFA7Vj1OJ5TlQgoBKJVJcrtqVvtDTwtLHswcAFNk2jeTSJATflcxMMlHv517e5+lUGPUpL5rM43uqaNJZdBsBYZmnXZKBDgdqn1w9Dzbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892067; c=relaxed/simple;
	bh=lWvJk62lbTVh+eTZsYEjyNkeuZuF0dhMtQw8uQy/l0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6xeMeJCYYetvUxRnxmRzCtH6r3ymxUHJYBH0E7U5z1v/AAo34ft8g6HOfxbLsM9lMHTVJxhzizx1sDFb7ZGNexyUCG+4SF90XzEdW52tDYA6Lz6JitmkLfC9w+tJRD4fh7OqU4+R0kC1lB7s6a+0W3D4GsH2wLwKD7UDi0at58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhNnMqtX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhNnMqtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09261F00893;
	Tue, 13 Oct 2026 11:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892066;
	bh=Pg11Im2o3SVePBt8MRnsIy5NFZdLBinfj7HUBNzil1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhNnMqtXZc3uerBUNWB1x2fMnSENTNO23D96JHISgH30uojGO/Rft81TXG0vr5/nD
	 DKha/I6WOts0vGsvtwGuhvDb8C4Dc8ulb7/TWJ3zl9Dt5Y+pye4ga/sE3tasHhZXrP
	 PP/5u2KomkS4fudboYAeeVg37dEZLgKQHOV6DKWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Hui Peng <benquike@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 049/281] sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute
Date: Tue, 13 Oct 2026 13:36:05 +0200
Message-ID: <20261013112856.241362539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7569,11 +7569,7 @@ static int sctp_getsockopt_pr_streamstat
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


