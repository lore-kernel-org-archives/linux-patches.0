Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9835039A80E;
	Thu,  2 Jul 2026 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009542; cv=none; b=nPxm5msjVd+rFPM/k8JfQ07C4gQAkBiRHKRf5VF3US5+h96XTEvDoOhd0lWak7zYJLe4okOqC+JEbJ/668e/gzCx/LACFZS2JknvZGt8fBMzvDpKhk5hOW08kel3fhCEsiuCLCRHIeokTjyAji6lfwHtUJNYKDJSHm5B2YCHX1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009542; c=relaxed/simple;
	bh=/5XXhTou12xkB23G6Rs8U9uky8NaEtqIY77bH+e1208=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEhlzq9n5+yqgucl2BR1vR265Fr9c+WLVYNxVI6JPDbFhngL++Bfcx+sPdQ6n4kzH0/vv4Obe8tRwJW5GCx4R7cNqsJC1bmzNXwlmfMQ5fhD0M3Pcmp0k4CGo1Bgnc1W6NaMN51hWJqXrfzE08xLkPlwd9KfHFZGP3ZQjHTMt5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMQ2R3az; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMQ2R3az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411591F00A3D;
	Thu,  2 Jul 2026 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009536;
	bh=xow4nQQ50N5VeZ9NOu4cRrs3fVYlYhph/VT3oRoScvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMQ2R3azg36HMG8vmT3NajrIMayIa0J2j1wnycIR3JfJNqyaCxtlRHsIZ/Dc1yNEs
	 hH84/u8uMputghPzQxOH/3vRIxRsX3dUZEaC+3yMf0RmrzxYsB6lYd6yZS6U0zPzDY
	 Dh9nG3jxrmtO3x9J7D5hm7qQLicvjxaCMoziYncs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 87/96] mptcp: fix missing wakeups in edge scenarios
Date: Thu,  2 Jul 2026 18:20:19 +0200
Message-ID: <20260702155110.810150131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 9d8d28738f24b75616d6ca7a27cb4aed88520343 ]

The mptcp_recvmsg() can fill MPTCP socket receive queue via
mptcp_move_skbs(), but currently does not try to wakeup any listener,
because the same process is going to check the receive queue soon.

When multiple threads are reading from the same fd, the above can
cause stall. Add the missing wakeup.

Fixes: 6771bfd9ee24 ("mptcp: update mptcp ack sequence from work queue")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-1-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1571,6 +1571,14 @@ static bool __mptcp_move_skbs(struct mpt
 
 	if (mptcp_ofo_queue(msk) || moved > 0) {
 		mptcp_check_data_fin((struct sock *)msk);
+
+		/* When multiple threads read from the same socket, the caller
+		 * filling the receive queue does not try to wake up any other
+		 * listener, which can stall it. Flag the data as ready and
+		 * issue the missing wakeup here.
+		 */
+		set_bit(MPTCP_DATA_READY, &msk->flags);
+		((struct sock *)msk)->sk_data_ready((struct sock *)msk);
 		return true;
 	}
 	return false;


