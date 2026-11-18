Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046988;
	b=takaWmhbH90RMue7KBwqc5d1Yzi8Tu+S5TepbvkvCrpWA2f5zxDQ/52t8qQOTZg6TcGF
	 HirJWFpF7mOTKw+oVqp2Rpz3Yb8RHyfcDkBqVuFZLu6drsF4lNa6eCoyQU/JOLtoWlNWQ
	 luZ2aipEMhz+K2apvak6LWzuhxxhLx59KrDB3+T1JG3fi2FjTH2LmDSCkk0ySxGAKWwp/
	 6h7CGJgiM6miqd2BMVhl0cbEEeBwIY4MJ/PeUhBYMahD2yOBArv8OyajazeENe5pKMMfn
	 W+cp+D1ZdlR6v4IHXC5nYbVZl574mLtspRJ8XF6k9j1k5C3cpHIhEd6veruQMovTSHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rO3dddopsSvbW36xRl/89V533ktOm1d+XYmAnF9EpAM=;
	b=FivpsIF9mpTQk3/SeyCHx7kgwg197G2fd4Ebbqbd5YoxoJRiALsrqU1WwA84UhTbypx1
	 QQUp0zXQ/7ueE/LZsa5J7d4vPQLF1JujmM87p9xSCyBIDidV3VLUVc3J60GUU9N07WVE6
	 5ofuWlolJN6fAiX5JAexd9ygmGcBnC24mRatUeOt3WytXBWiydqSALj6z06JoTHs/H9aL
	 7FOBrLNkzQgoAr561Np5oai62urtR7hY+sHnTBEJq54BuXnbAuzt0zA+EBuv/T7qbhKmP
	 DDbBHQv+qly9nVYqiB4Fu4GSWrfOio0dtOiLzGb3yCW7/X1dDIjAkYz4x0frVDIHJXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFrvKXr7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD83606A320;
	Thu, 19 Nov 2026 00:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFrvKXr7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8411D1F000C4;
	Thu, 19 Nov 2026 00:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046988;
	bh=rO3dddopsSvbW36xRl/89V533ktOm1d+XYmAnF9EpAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFrvKXr7txubc/BHovuAhj+yxX+YrpSLojZIU/7NlS8c8wXuVa3PUJ623dAFjR5N7
	 S6VtGoPoUPWJTC+1FgWC5WoUjzACgmGPCOwDeiNqwoiacVo9FGEQDJhwkCOJaAQZKf
	 0RzMUImEta4PqKO24Go7+A1rYE5tGxFn9oKjT3R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1479/2857] mptcp: fix subflow bitfield misuse
Date: Wed, 18 Nov 2026 15:41:53 +0100
Message-ID: <20261118150254.562862247@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 7538fa33bb2f66b8b809ff39d58308be48e197a0 ]

The subflow status bitfield is protected by the subflow socket lock,
with one notable exception: the `close_event_done` bit is actually under
the msk socket lock protection.

As reported by Clashiko [1], flipping the latter bit may corrupt other
entries in the same bitfield.

Move the `close_event_done` outside the bitfield, in a 32bit hole.

Link: https://lore.kernel.org/178959153492.22033.1944011998010756543@kernel.org
Fixes: d82809b6c5f2 ("mptcp: avoid duplicated SUB_CLOSED events")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-mptcp-misc-fixes-7-3-rc8-v1-2-932c9b182fc7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: adjusted context to place close_event_done after pm_listener instead of fully_established ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b27f672993605..ce852c8bc524b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -492,11 +492,13 @@ struct mptcp_subflow_context {
 		disposable : 1,	    /* ctx can be free at ulp release time */
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
 		valid_csum_seen : 1,        /* at least one csum validated */
-		close_event_done : 1,       /* has done the post-closed part */
 		resetting : 1,	    /* subflow is resetting */
-		__unused : 8;
+		__unused : 9;
 	enum mptcp_data_avail data_avail;
 	bool	pm_listener;	    /* a listener managed by the kernel PM? */
+	bool	close_event_done;   /* has done the post-closed part,
+				     * protected by msk socket lock
+				     */
 	u32	remote_nonce;
 	u64	thmac;
 	u32	local_nonce;
-- 
2.53.0



