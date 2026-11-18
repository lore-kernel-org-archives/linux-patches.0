Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046946;
	b=hBIF7isZ3SCPgUsDfwKz508Pujh4Ri0uSnz4CuWbRC4cTKIDW3B/WtZKOtM3iGrmJpgY
	 mPQUt0VWEF9wlpDmydMA1cTRu+5OcCMPU0cNGhPYFKAqheEoPUeQ01qMQWolowVTIEF9s
	 URxMV+45BmkHak0mEaNp38KWMkaOeZH9iVDjR9dxrPUTFjqICdpEIiBl+iCWPeD4zdncX
	 UR9kVAe4JahwyvTchul4nusVCPxOBCHz5Gchg/5vHJkFK/stZtmObDpYiyASwN6Fv3//k
	 ulcFydPNnbPt8r2WJBbhwy7/wKtCeAjwChvBUNxajUdlAnruZI1cMEOhKfactB7vunQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uZIX1u+eUeYNrhuxzT6NtVX1RClHSvpQ0GzqIkel4Uo=;
	b=Cd7MoFDcb29Z4mEI6P4goVeXTAJNh2l0NTUJKP6ZPRsJo7pPpGZkokdPl7BzBHd0klZk
	 bwowFylR4oVVOwt5JGhTHPc7YKfgHXz4F5+bKwdUCYzT9wxA+fsc52+s3g1yP+N9IGq2w
	 9iYbruvHg+zyfZXdKI556lA6GbrxuGEtDMPuN6i4mVdjzeIEcATy+vis1wNNMfow13DkP
	 L0YKMtEK2/gz9Gr/1DyoZqgsjVM2J0rH98cSzUe7mur+HNcfuTIB42rViDTCD4CMgiNss
	 BACKqEOj8pyrxGzUEcGH2UNIzRJFTZP0/FYhb5+4D7VtUR6IOllU/qF6hdgZUaNKTPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N47oGGlV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B608A606A325;
	Thu, 19 Nov 2026 00:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N47oGGlV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CE71F000C4;
	Thu, 19 Nov 2026 00:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046946;
	bh=uZIX1u+eUeYNrhuxzT6NtVX1RClHSvpQ0GzqIkel4Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N47oGGlVKY3kP9ogbNZvr2RGCPPIQg0hKu7NrNSmYWTiPvsIJw5WlrrvHyOlHeAE8
	 VnM0rEy9HN2xKgOGwlsY0LlykIX5vGdCdyCp9tk+CVdKBgYIUE/tRz2rpQ1Zv6+QG7
	 SVsFhKHRl3XmhoMrOPIBQodvaS/zwDrOiM8YuKEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanye Yang <quanyeyang@proton.me>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1461/2857] mptcp: reset msk state on early connect failure
Date: Wed, 18 Nov 2026 15:41:35 +0100
Message-ID: <20261118150253.918835769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanye Yang <quanyeyang@proton.me>

[ Upstream commit 29afe67082b2d33ab2e90c56c337235d725f023f ]

mptcp_connect() can fall back before the subflow SYN is sent, for
example when the netns is in an MPTCP blackhole, token allocation fails,
or MD5SIG is in use. If the subsequent subflow connect() fails
immediately (EAFNOSUPPORT, ENETUNREACH, ...), __inet_stream_connect()
returns while the socket is still SS_UNCONNECTED and never calls
->disconnect(). This was reported by Clashiko [1].

The error path only dropped the token and moved the msk back to
TCP_CLOSE. MPTCP_FALLBACK_DONE, allow_subflows and
request_mptcp were left as after early fallback, so a later
connect() on the same fd stayed TCP-only.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/633 [1]
Fixes: 0235d075a592 ("mptcp: mark as fallback even early ones")
Cc: stable@vger.kernel.org
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-mptcp-misc-fixes-7-3-rc8-v1-1-932c9b182fc7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: retained the -EINPROGRESS exception required by the existing inet_stream_connect() error path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index bdace644dbc6a..2084503567789 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3937,6 +3937,14 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 */
 	if (unlikely(err && err != -EINPROGRESS)) {
 		inet_sk_state_store(sk, inet_sk_state_load(ssock->sk));
+
+		spin_lock_bh(&msk->fallback_lock);
+		msk->allow_subflows = true;
+		msk->allow_infinite_fallback = true;
+		clear_bit(MPTCP_FALLBACK_DONE, &msk->flags);
+		spin_unlock_bh(&msk->fallback_lock);
+
+		mptcp_subflow_ctx_reset(subflow);
 		return err;
 	}
 
-- 
2.53.0



