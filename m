Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620837;
	b=vRds/03TwaNrxeO7SpqHWaNSD3jCRoKvBghawWBxobonKbtKXfCCLqhjgWc9TVMKQzE+
	 OXKAzPumG4QZwp+t9GVtkG43DPLTIZYs+y3Tv644sJsyTgnDaz2MaO0oi3uepc7PNgeRX
	 oW60j8S7QRtKE6lMcx7h04e8vUeFIX7koOVe41GiHzITqAwRm4gqKQFQSAHmfcMrzy1j8
	 lJWGMDmjbn9MGfZktQA2+HOUiPhg5u2cmzogvlSt3uAAxqVR9uq3qtqKhkHedMAYxnxP2
	 KhJ0FoBuGZfovAZVF6l8opNdETIKIq39LoleMOCbkEUGpm8i6Sqb+iUma64KgLdwT6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I95tmY3nng6SC62ztDazEth6cMm4Qhfs7Mnr/MyAoBo=;
	b=nK36CEHxkK96BqH/23pN13oqu3dNea5qvLI338HjfB+CNMCSblevsFbtSFCLb/poSnq/
	 swBgVnD797ExKdgG4MbVRKl1n8GrIsGXts6Rnnfqhsm5dUzgmFzsRbx0cNV3ZemzUc+3i
	 TW6cCNlaGRmB9f2sM66pW94moiDqBYoqj5yXh930pHnu5PwNNxvJnrzsevcc8LKhMJOIw
	 6cKaBkQxC6CSpQxVM7lglwDB3UVcjXO3OV3zNPmP0SLc7WrnS9yz9xfPG88q1ZpS5X0iD
	 Rg93zG1zsAmhAl9MYKXVwX/jfHOlJ5ySOxpTf3m7EdtK6SyFqO1O28JfCM4+Tg39SFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dyx871e7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2885606A329;
	Wed, 25 Nov 2026 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dyx871e7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F191F000C0;
	Wed, 25 Nov 2026 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620836;
	bh=I95tmY3nng6SC62ztDazEth6cMm4Qhfs7Mnr/MyAoBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyx871e7WYhgZPnj+/b5FM1N/3rlWH0UQ0tbgjevOqSyfedN9i7j1/oAONG8yGm8t
	 cMuXUOiWhbwgu4QwEPPJM8s0kUmQrUWKBIAOHHgUze8T4sNky40xsnWefTufAKcopF
	 4Nrcaj5DAtJmkfm8cWsno+A45Lu86dSOSEgGOClo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/990] netrom: keep T1 running after answering a NAK
Date: Wed, 25 Nov 2026 15:23:25 +0100
Message-ID: <20261125143822.980902589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When an INFO or INFOACK frame carries the NAK flag, nr_send_nak_frame()
sends the frame at V(A) again and then stops T1, although that frame,
and any sent after it, are still waiting for an acknowledgment.

If this copy is lost too, no timer is left: nothing is sent again, and
the circuit is not cleared after N2 tries either. It stays stuck until
the peer sends something or the idle timer, if set, closes it.

Restart T1 instead, as nr_check_iframes_acked() does when part of the
window is acknowledged.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit e18a382a74b93a3c0ab52e0fedc8343d9d4facc9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_out.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netrom/nr_out.c b/net/netrom/nr_out.c
index 150cb4263d314..1c6b4386c86b4 100644
--- a/net/netrom/nr_out.c
+++ b/net/netrom/nr_out.c
@@ -135,7 +135,12 @@ void nr_send_nak_frame(struct sock *sk)
 	nr->condition &= ~NR_COND_ACK_PENDING;
 	nr->vl         = nr->vr;
 
-	nr_stop_t1timer(sk);
+	/*
+	 * The frame just sent again, and any sent after it, still wait for
+	 * an acknowledgment: keep T1 running so that losing this copy too
+	 * is noticed.
+	 */
+	nr_start_t1timer(sk);
 }
 
 void nr_kick(struct sock *sk)
-- 
2.53.0



