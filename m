Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591560;
	b=PnCdaMZqXNnpDZvQ/biqJ2960lfDDfy/PezopYA9Ii7f1G8HMEO/xFU5CZpxZDUd9msa
	 wRuBme73fxpaQ/GkPotMUjamOWkGSyViu0Fz7rMkhUMgBKCfNFXC4TjVrr9S6uCTOLR0n
	 tIsVh163GNiJoQwO/9+hhDm/m8BmPEwe2NATLWq8W3ngOFbZ7KkxQYRWRgRTOsNlHNugv
	 t6iJvNDZj6Xd8DORGQA7ssiFj+pD0bpp4SgJfXg1sTTUC6fDGNBnXKvzq5bz7BHMqCt67
	 yKCy0cFrx+QPPBEHsvf6ympdq3CfxyrXMj3Hkipr974LC0GU182TsfznEHON7+vNopQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U5RPID00kXL9eyoQ5eslQ98SGravAOhM15LWs8AZdis=;
	b=XqRczawDZSanZuCvyqwKpLounGWp9bmtuV3yh6D4Tyr+RJzWzRPopufkFApGhrvBjtGc
	 x5Vk56JWmvdJoJiNfXQwJJDoZqOwohzFCVWzk0whXK5OyDZlALcOh+IqEirzFi0JhY3IT
	 mmY9vLow2iUJ4ZMEh6R9H+NFzLFfFgoYhNm/+xQqEmxvI+zTE4qHUehs6CX7cqpoPi39E
	 LYfqugo70h3w/kPtUf0TjrmR7e1rVFj5i7OSW7/43bZHRNzy0x/fKEvt46Ox79UJnAcoA
	 +AJ7H8TJFBoibq1MGhHMfzUQOsIkNuMmaYksVOkG46xqjELu1jfBnOc8c8uYVuZzoAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JT4QgsP2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6761B606D4BF;
	Fri, 13 Nov 2026 17:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JT4QgsP2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145D81F000C4;
	Fri, 13 Nov 2026 17:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591560;
	bh=U5RPID00kXL9eyoQ5eslQ98SGravAOhM15LWs8AZdis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JT4QgsP2wziqnS6S5xuRjtVS3Uj7ThodsC8uXdRwuXgRqxDFx2sDkguddchG3vV6H
	 1Wk3mHtUyelUg1jYAa7Wwe5AR5+NtR/RKfzQoFGRUD8jxiT1ItJZgnIXGMf3Ydlwda
	 1yQZR+bqFwkd7K0fPCMERQ5qEipSIJEWAjP/P+EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 569/670] mptcp: fix subflow bitfield misuse
Date: Fri, 13 Nov 2026 10:52:13 -0500
Message-ID: <20261113153831.148032343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted the unused-bit count from 7 to 8 instead of 8 to 9 because stale remains in the bitfield. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 28dd7dd08c150..d9c20de69dc55 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -544,14 +544,16 @@ struct mptcp_subflow_context {
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
 		valid_csum_seen : 1,        /* at least one csum validated */
 		is_mptfo : 1,	    /* subflow is doing TFO */
-		close_event_done : 1,       /* has done the post-closed part */
 		mpc_drop : 1,	    /* the MPC option has been dropped in a rtx */
 		resetting : 1,	    /* subflow is resetting */
-		__unused : 7;
+		__unused : 8;
 	bool	data_avail;
 	bool	scheduled;
 	bool	pm_listener;	    /* a listener managed by the kernel PM? */
 	bool	fully_established;  /* path validated */
+	bool	close_event_done;   /* has done the post-closed part,
+				     * protected by msk socket lock
+				     */
 	u32	remote_nonce;
 	u64	thmac;
 	u32	local_nonce;
-- 
2.53.0



