Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211388;
	b=XVX8a60WysQPqfCZgQo0+hdA2Du3tzATf9jNLR6g1AKkgrkO7bUyqxqG3S7buS0r+oxM
	 IvQcXHRF9wgUUwhqwe2kipdNHN3rzvSKki92s5dx6zcttN1JpxGmpA1lmsSY+QrKzFYnh
	 mEVeiC6fWCi5Ou/wlghxVKK7xQsmtH+knrK1lFD7BFzpeeLbXjQHMmuRgKVzyJqlWVDjc
	 N7d/D+Nm3LPHaq3/phYln4kL5qB7LDzQ/iH5QsAHOZBg14uQnksns8id2Egu8pen3Zxq6
	 efIRZPNyhceR9jffTVmCWRCFOBnnbz88QZy1y18DUVO5wnsccjAqQnWGeVPlEkkucNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qlrHhgSmxOJiJoABwrt+pElNeLJYw7dAKBe6ArTTzDo=;
	b=dyNQeVKyNYXl8fo3kio48snVlxbkeVZoB0yW+nQF/GZg+HKzToaRz82jsE1ItDTXgVmO
	 Zr0Ef9mEFed/3TQj3q4bVYFmtA5mt8Wg1fXC41TzfeFSzVf+f9zs+u4U+IoTPnzUB/ZQk
	 h3D1WCuD4WMgg3rdhm8ihzlGrpHj/0wvK1GdzqlgrQAVqTh7zs+OYNrmSR3PNftKdAenR
	 F9cQa9C4AwOZ1sg+IaXlm/85msYES0Br29pQE8njRHYq4zCdlDrdHmAgEXWBzti97e3Xp
	 G3vHN7TXgRFU6tjryKj+pQ2CKt6guhqb8QzDm4tWiuqC9AhkuzJq36T+5p1kFtdzviw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GnimR8ON;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC55B606A325;
	Wed, 28 Oct 2026 18:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GnimR8ON
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272E11F01825;
	Wed, 28 Oct 2026 18:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211387;
	bh=qlrHhgSmxOJiJoABwrt+pElNeLJYw7dAKBe6ArTTzDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnimR8ONTtF4Jdw0pUcxQ3g3nismUixbl8MlVBXsa7neUd3EJXIeyuk3mER0/7BXn
	 /uAi4yr2H6lszwys1/slMyJrg8r50hPHkJsuSXp29831dAN4ipe30yemLcY4YkK/+3
	 An2y/lJH1LJh1atOwuNsMnZjjg9iaUfAW8M/qMXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Hui Peng <benquike@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 358/571] sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute
Date: Wed, 28 Oct 2026 17:58:25 +0100
Message-ID: <20261028170016.510916651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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


