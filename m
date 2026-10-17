Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1593A6418;
	Sat, 17 Oct 2026 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257337; cv=none; b=kk5dtQdMNcPIHeVmsbyiTZ1wx4gpiVfMVViX4RvV9hf0EyR38m1kGTDehDY8a9onIYsoTQTLqD7H2wG6mbe7CgTQHp+r613uVFeEJ4hmpt0XFOIzUM74Zo88wxHzIX3kW6pNG7avLSXC249mLzO6kcAnPDIZc9NsIlA1ATw4tVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257337; c=relaxed/simple;
	bh=Uo4ukCMJl3GaKDdXWfgjGunH+jOh8eUeHLxST27UPUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyClYVmcAAM9mKRp9WbE2DfGXNT8s0EVcWh4ZjqfZouXoEkFEIA116DpJVlnW0KpPyI7KYEDvt0xxy/vcPo1egNDsx9gWR1tyR/XLEIGBwSYVIDpvvL0LZmlCKf+/RtBXmjmG/8CSI86F38Q1kTiT49StuffI3RdBNE9ohbxIco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZHygkrH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZHygkrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8581F000C4;
	Sat, 17 Oct 2026 17:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257336;
	bh=xl6Gay5tjatg6zZNgqza+RGVDKp9rec7ywPPNGVU00Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZHygkrHdwvWxrmzu3j6tVpl7EHQvNqhdIsq61dfzniQnuggC1YZbr+KrVob0F+LD
	 Rv3okjOO6EW4Wm26zmmvEUSyIVmAvlAQpYQzDlYmH0hM1XyUFZwJoHWn6szDB1G3yS
	 HtXzcGi/qQZgBYrwzBHUC0LfU/mgC7VyCXoYvvdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Hui Peng <benquike@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0485/1674] sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute
Date: Sat, 17 Oct 2026 17:45:57 +0200
Message-ID: <20261017160443.562946265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -7523,11 +7523,7 @@ static int sctp_getsockopt_pr_streamstat
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


