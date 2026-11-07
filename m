Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063461;
	b=Y0RX6kb0Qzq6lX8BgsyTCDqCU/8jo9rdQ41Bt5bQWTZx+KsZXE8aVOCCAggWjaZ7IIvj
	 ek+o9QJeJWzM2b/IbUp7lPhVlUC+bANrYOT8vlQRqTLVXBmtN/uEYG4vjafiv8p4iqOpS
	 REsOds/fiajjkP0y/UGQnshtEb2vf1WGNdSUR/q30M6kO86yftzTIqSStUoc3S5HqZujX
	 Nx2aytAp6eiIZ7VhMVx9xexQid3yG63C5JWlIYvxyUDQshrBUo0u13OL/SEAsFvnv4Vws
	 9szLVUbMEYx0g1h5D63e4UoFCQgaBUiBvF937xyT/KMPwTsDHHLCPA1i+67ZWBmmUzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M9Xgx20CJVgTPUu8VRqYAWKh5ye0V4ECiTWsK1L/vb4=;
	b=R9dluUDPYsnx4iHJHZto6IBwU7+Tjw0969eItjqxLYIhMHKrepI1momLKySTcAu1GQ2s
	 HXx9T+R8TbFiyv7G1bip4YNtDljVxflUJLSzIyRSyFyHrMJz5OXWBg8jFopB4wX9tXt9V
	 J448p+6BM1SoZbFyzMumlT8poJg2sbDoyRutHU6MF8B0NsF2QI5UYaUsLboVQa/vVjakk
	 29yCrJy0Ka1oEjLY/q/HKCK/PYlBJLOA9ci7IY331Z1l6GPCuJfqRAwOwaIA7/m8Qg+ra
	 kGxafe2cBeCO6CfsHYy52vb+ARaw/8o0HJi1USCzvA8MQdMQJ7KmYKo0pMtfx5B+Zmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6nhXRol;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B7A606EE8F;
	Sat,  7 Nov 2026 14:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6nhXRol
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DD01F008AB;
	Sat,  7 Nov 2026 14:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063461;
	bh=M9Xgx20CJVgTPUu8VRqYAWKh5ye0V4ECiTWsK1L/vb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6nhXRolnO4PQbywFra9E8GoDxB/+DH6DzkF3M3rFuCAvXvn5wOuMIHG0kfEpt6sU
	 yaqPU84Z+1/NKSIK/LixKTqUq6awx59Vjzv4wzHZaX2X4/6nXJvdu05KsyBEAiVJzk
	 ypbHhq0sahnw5PFTWpLVUMwTA1NqBXtksoND4jmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 617/869] mptcp: fix subflow bitfield misuse
Date: Sat,  7 Nov 2026 08:54:59 -0500
Message-ID: <20261107134913.968897462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index dc8920a6a90c3..184831b5b624a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -543,14 +543,16 @@ struct mptcp_subflow_context {
 		closing : 1,	    /* must not pass rx data to msk anymore */
 		valid_csum_seen : 1,        /* at least one csum validated */
 		is_mptfo : 1,	    /* subflow is doing TFO */
-		close_event_done : 1,       /* has done the post-closed part */
 		mpc_drop : 1,	    /* the MPC option has been dropped in a rtx */
 		resetting : 1,	    /* subflow is resetting */
-		__unused : 8;
+		__unused : 9;
 	bool	data_avail;
 	bool	scheduled;
 	bool	pm_listener;	    /* a listener managed by the kernel PM? */
 	bool	fully_established;  /* path validated */
+	bool	close_event_done;   /* has done the post-closed part,
+				     * protected by msk socket lock
+				     */
 	u32	lent_mem_frag;
 	u32	remote_nonce;
 	u64	thmac;
-- 
2.53.0



