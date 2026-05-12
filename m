Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B023EDE48;
	Tue, 12 May 2026 18:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608894; cv=none; b=f/Yubke5ta8mdRX6AtyUK++mTgPf5sJBS5X8saNzNG7fL53QaKYU+zvLinXY8PcnvN52h0BIN/oYqBY9FsgSTHY428O2BQOyPmVvGGGYXYFrF7aWfwrozcm5zstLnCHvdwX1yxv57XEOdRCJMppcafMKHsbvPpasmvT2XeZlBLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608894; c=relaxed/simple;
	bh=DnIhuzFIBaOMQJuH/DJW/cACocbPZeSXSnKyHMf56uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjbhDchf4Iew8qauk12WlGuyB8//AOM9J/0dUA2SQS94ZQPldfWGqF/b2us3X1dn60pBZs1MWePVPJIyr03sZyUD7i9yzU2HpLJnsrzW4DApX9ebB5LAH942W0Oe4gurL7p4YIPm9IdGW5vS9I5PGU6f6s650g9Mku2qHC0RXXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OG/8wuj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OG/8wuj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C707C2BCB0;
	Tue, 12 May 2026 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608894;
	bh=DnIhuzFIBaOMQJuH/DJW/cACocbPZeSXSnKyHMf56uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OG/8wuj8Ls5q0+0SwYbOB2DNlMNA4R887TCA+Ti9QZYsv8JsF5FRJTb8qfb5aHPwc
	 4OX9+4Y9fZIh7hIGHqfLv2aAyjNYWcC3Ks9yQCZCTxVWbqrT8U9lDjBOhsi387/Qqs
	 cuZQ2UQGnMa/kKa5E33KG3HGImwkeNYV7CO3xlVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 215/270] mptcp: pm: prio: skip closed subflows
Date: Tue, 12 May 2026 19:40:16 +0200
Message-ID: <20260512173942.972636696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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


