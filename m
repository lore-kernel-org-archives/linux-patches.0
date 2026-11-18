Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053894;
	b=F69hyg++xRXjn5DrUftDRzfW0zRcgNvLzx85ZS95YGAyTiScV90qJZpwygahMYsYzyI3
	 vK6OysgBDfx57ZfOLOp10KdPHzHEcAbhkuRXYz9i4yzJhgXE1ypgT29AHfpYvwUyPe9B7
	 2pbmYGM77znu7E+6fd9ml47mvJBrUTw9aVe/ijNkNyGWwSmZbsxA40XhgLL4yIq+C4o59
	 jOlVudK94/YgUeA5iBkrNJLcrNH1gHWluWJ1SBVgl4QL+5HMzReDGQ2Sodu4vGn05DI7N
	 8dw/n/+cCncC5p5DXghF62jyW/ylN70DkMEg2vHOBbwtteiwrzfD7dhc++4xZ16dtQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gVr1373ex3d4wc9i1kEqCkB7UpU/LXhIj9U0otpfppM=;
	b=nZ9Hl6JvXpYWdrfnHafef2GC+uyccyjH2IdHRwmwCbacPjfCP9Uzp4Z/SZOY6hUd4pWy
	 bMaQ8V5a+tQWCSczeDBMeDFNzZH4iuHASU7c0XAeM1B/Dl8OuzY71jvoSRz4Y2O7FdOie
	 cVZmSShG9nhgHBRIPY7AW7mkDTGGRuCd/DMftdCi9MDmA5C2tf8HET/ae4unVilS/8N51
	 tR569D0k5nYQx8eOQTOmVn2fff/VaVb5Js0lVn82d7Il6oiQLMnoFQL6Vyhq26fVgbWG7
	 n+Uguj6KbVnyFK7Oo8+GSocy7SYyzhzaw7GosA1WkUhcM/E3GDkNVnquvuxRh5oykYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZvfDDhi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67038606A337;
	Thu, 19 Nov 2026 02:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZvfDDhi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2A71F000C7;
	Thu, 19 Nov 2026 02:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053894;
	bh=gVr1373ex3d4wc9i1kEqCkB7UpU/LXhIj9U0otpfppM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZvfDDhib8XbArxHjNRBRCWBwCVVt3xok4zcbwdpvqTr9KzoUJMM9vJ9G5iVw6DWG
	 ynxSINJZuk0CqlHQ876imMSrXV8utf9xL+835ahy6+5J6brlZ1znyDnCu9nQiyLhJm
	 aksMVI/H6R+QRFS7qFmt7YRVNgt+JMiNlGANT5Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1082/2214] mptcp: fix subflow bitfield misuse
Date: Wed, 18 Nov 2026 15:45:58 +0100
Message-ID: <20261118150055.527256095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
[ sashal: adjusted __unused from 10 to 11 instead of 8 to 9 to match the existing mptcp_subflow_context layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 7fd7ee90c0e50..0e1136783873e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -446,11 +446,13 @@ struct mptcp_subflow_context {
 		disposable : 1,	    /* ctx can be free at ulp release time */
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
 		valid_csum_seen : 1,        /* at least one csum validated */
-		close_event_done : 1,       /* has done the post-closed part */
 		resetting : 1,	    /* subflow is resetting */
-		__unused : 10;
+		__unused : 11;
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



