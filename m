Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F9636B043;
	Tue, 12 May 2026 18:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609597; cv=none; b=fJE4Loc1Zl7NJr9oMlTG/UF67vMmxFajZeC9cncXgZwjouWZ7EHrYIOJ7wMWr4fKI2eh1757OXgc0VJB2rqknxwQ978NyMxXXCpH0y+keg49XRktr8MQDSqsBXfDSRoz3/DWrVcFUT2s5WugLNwtdKAO3a0k7HyWzjcLFtp3ZGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609597; c=relaxed/simple;
	bh=b+NECFNAu5phWEpEGamdMirVM5I7unoBSyzlXp67Rqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFFCQthaEiXTyFZ/GqGiMa+lMXa+jWqWjSPdKGe4s3V7aEfmzuiDn877ZGaKXxLC16kTNcosmJJpJcd5PHnZMe98FE9+RlJemj0+4EUYtBWX7E7obq6YOGE6U92COExPUSFymmsGZMEGdAexnlCjT0bHQWSETCxOFKFijY17Zts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njQ69AEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njQ69AEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC07C2BCB0;
	Tue, 12 May 2026 18:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609597;
	bh=b+NECFNAu5phWEpEGamdMirVM5I7unoBSyzlXp67Rqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njQ69AEvoqA4lOr2eb+o24rhot1YqU5ZTaMYhdYz1AD0G0vZV9cLIysIdj9SFsaVJ
	 jux/k9syMM5HlIs9MpQeeR6FD2fINCzqyrDUg4guRzdRn0QUelJkSceg+Qfek04LCA
	 Uo2rrTTPn/O83R0euBmKpk0z87FJryApKG5NTtR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 258/307] mptcp: pm: prio: skip closed subflows
Date: Tue, 12 May 2026 19:40:53 +0200
Message-ID: <20260512173945.572318563@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 166b78344031bf7ac9f55cb5282776cfd85f220e upstream.

When sending an MP_PRIO, closed subflows need to be skipped.

This fixes the case where the initial subflow got closed, re-opened
later, then an MP_PRIO is needed for the same local address.

Note that explicit MP_PRIO cannot be sent during the 3WHS, so it is fine
to use __mptcp_subflow_active().

Fixes: 067065422fcd ("mptcp: add the outgoing MP_PRIO support")
Cc: stable@vger.kernel.org
Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-9-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -283,6 +283,9 @@ int mptcp_pm_mp_prio_send_ack(struct mpt
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct mptcp_addr_info local, remote;
 
+		if (!__mptcp_subflow_active(subflow))
+			continue;
+
 		mptcp_local_address((struct sock_common *)ssk, &local);
 		if (!mptcp_addresses_equal(&local, addr, addr->port))
 			continue;


