Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54C433A9EB;
	Tue, 16 Jun 2026 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629957; cv=none; b=rKrlVMRPVtxBxvU1o0/CepAJ7/XrFa8JP2iAkVze4JTPR275Ksztkwpuo89DX1nR/zEif+7XXzQBcSAwcnCydnbz9JVumnuvz4cz53OQ7OatSXdhYDiT0MleqDVZ5eILHK9AR3L/mlpr4/HbPf6xnaDFpvF2Kg1q0KlYVYSVm+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629957; c=relaxed/simple;
	bh=Qw0WwwIvu7bEvm3+LKDU3DWIArWB7ncRtYWqOXo8JWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owK3VRl/UZsHWCw1QKf90ggOwylfXPFEO0Mmvlp3PeXGPU7J6r9nMq0zl+9vOGtbwDNxIhATO7IhvzFK3xggcTftIqE+fn8fP3TuUAca22L8k7LMulrKIt9mK2d1Tw2b8usaBNdZC9P97h+SEo459zHCllCyDH24SEtRtoq/a+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxuMHY2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxuMHY2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBAB1F000E9;
	Tue, 16 Jun 2026 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629956;
	bh=ETD45T3oczGSSAOGbjw/OZVjf8lSJiopvQgBa2GvDn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxuMHY2QwbIZXTqjll9kqaK7ZAG96ESR0qn9BP8qmOKezr73k2NNN9BA334RpGW1U
	 07t7lWwtYOFWs3QNlf2gY98NcfPL5vkghJW8lSRuPSV+pyTS8GJJnWpxYd8olEMEi6
	 b4p8RCAG9fQczvElrplt41XuINfdCKsH87WeZvHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 385/452] mptcp: reset rcv wnd on disconnect
Date: Tue, 16 Jun 2026 20:30:12 +0530
Message-ID: <20260616145137.162796372@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0981f90e1a05773a4c29c6e720f5ea1e3c8f1876 ]

If the MPTCP socket fallback to TCP before the MP handshake completion,
the IASN remain 0, and the rcv_wnd_sent field is not explicitly
initialized, just incremented over time with the data transfer.

At disconnect time such value is not cleared. If the next connection falls
back to TCP before the MP handshake completion, the data transfer will
keep incrementing the receive window end sequence starting from the last
value used in the previous connection: the announced window will be
unrelated from the actual receiver buffer size and likely too big.

Address the issue zeroing the field at disconnect time.

Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260515-net-mptcp-misc-fixes-7-1-rc4-v2-4-701e96419f2f@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3333,6 +3333,7 @@ static int mptcp_disconnect(struct sock
 
 	/* for fallback's sake */
 	WRITE_ONCE(msk->ack_seq, 0);
+	atomic64_set(&msk->rcv_wnd_sent, 0);
 
 	WRITE_ONCE(sk->sk_shutdown, 0);
 	sk_error_report(sk);


