Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E02D2C0261;
	Tue, 16 Jun 2026 18:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634925; cv=none; b=vCh9QmIHBiUtOKz6+Evl5eG7yYtnj0ybBlr7uJV/eFtsP9e7HyXMwWxKWs4HKWL6vdW7kWWYh7Sl6B7X/fnESqjm440MaNEt6BgJeHkhYWRaOqn+7jkLsWKV4/JW5I1gIH6XD9XI5KZkmQTAFNZWbAJ/ASBg9hjigLJkoUixo/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634925; c=relaxed/simple;
	bh=inVuewRj7By/roT0BhGW3w1YJLyYML1Bgf14sZTAMAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5zriJ+YCjR+kGIb+ch3j7KCtILi1UOEXpLJ6i8TDGARFyMPcefg677+zboCrr31b60abqUcPjk10GU5xcTb6cN82B8sFKLiY+dVvdfa1PoO/USd/Iymn0qB/LTEKe6suZEJVA5ENonzVzGOp4R4dKjkFK4MzK4soWqwipx0Ad4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7Z4Og4c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7Z4Og4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1824A1F000E9;
	Tue, 16 Jun 2026 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634924;
	bh=SzFb7VqTqCslZLEIVmKDXB+CYsXQWC56eXEWWZJE+Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7Z4Og4cm/Oi74lQSxLUmtopfOQANJNEpbWRETbQd4R2GSQmRqkOPJn/tSp8A9Jzn
	 W1QKVm15oGBcNM3oSVsYlygucvQkHFMurg7N6kNRfFj8KU8gjNt+sL2eX7FxAryZEP
	 Sk1yymVRi1hRHF+mCdYAqJmflQBnibLoC8Vhkg1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 330/411] mptcp: pm: prio: skip closed subflows
Date: Tue, 16 Jun 2026 20:29:28 +0530
Message-ID: <20260616145118.690972022@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 166b78344031bf7ac9f55cb5282776cfd85f220e ]

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
[ applied to renamed function `mptcp_pm_nl_mp_prio_send_ack()` in `pm_netlink.c` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -828,6 +828,9 @@ int mptcp_pm_nl_mp_prio_send_ack(struct
 		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info local;
 
+		if (!__mptcp_subflow_active(subflow))
+			continue;
+
 		mptcp_local_address((struct sock_common *)ssk, &local);
 		if (!addresses_equal(&local, addr, addr->port))
 			continue;


