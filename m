Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD0340B360;
	Thu, 30 Jul 2026 14:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421396; cv=none; b=Ip36oROD+yX3D1pwDv/VS4w4tZg0AnwGzunJr6V77zzkuX+Xl9GIggjN3Q5puwYmnL7x4WJYb/IK3aZIM5lYDg3IEnxjg11cr5D/udjs2CNSaGSlsT/rSR1GL5tDkxMorcGa93OrTJ4/fwqNVqe1vJLUkRMQbdxeZmfhG4D/uU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421396; c=relaxed/simple;
	bh=Glu+/FTHnTJ5vkmezswJI3e/Lj55v860FO/Q+yadGOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEbqC2YjWRZHs/VGcBbjqofQLE4yMr7AguCLr3/EbsZjW+PvKiucS2u2TyZQy8GMNKkFJNdlXSkrP4SIpZATF0tfd3aV8S07oINpp+PX0nOw2dWGJOTeIjeqTa+zCW5ysNCJmPFJBgTvGzAZ9gd2zclf8HLnb1gglJ+/cA9Huko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVg5R0Ko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVg5R0Ko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2551F000E9;
	Thu, 30 Jul 2026 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421394;
	bh=LJ1u4nXaHKxhp7+Qirx7lTP1+RJYvu2km9itLKgQ8ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVg5R0KoayAmtG/GEN6v3jZuoYatjW6mj+5CIT3+Tf02IV6xBt8Qn2+9JD22vMmTp
	 4eZQ+etieNxcaG/i0FY7Zi+aaa2K6dMREXa2n83Nr5RJ1CGWSScUZbRheslx+rgFFD
	 BpkQeJVy7aUZ9BwWpdv0rlbou3BROxbepuPNm6Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 090/744] net/iucv: take a reference on the socket found in afiucv_hs_rcv()
Date: Thu, 30 Jul 2026 16:06:03 +0200
Message-ID: <20260730141446.180584697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 4fa349156043dc119721d067329714179f501749 ]

afiucv_hs_rcv() looks up the destination socket under iucv_sk_list.lock,
drops the lock, and then passes the socket to the afiucv_hs_callback_*()
handlers without holding a reference. AF_IUCV sockets are not
RCU-protected and are freed synchronously by iucv_sock_kill() ->
sock_put(), so a concurrent close can free the socket in the window
between read_unlock() and the handler, which then dereferences freed
memory (for example sk->sk_data_ready() in afiucv_hs_callback_syn()).

Take a reference with sock_hold() while the socket is still on the list
and release it with sock_put() once the handler has run.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Link: https://patch.msgid.link/20260705-b4-disp-fc79c0dc-v1-1-d2cdcb57afa9@proton.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index c2dc3338670e83..126b58bbc2a5f4 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2091,6 +2091,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 			}
 		}
 	}
+	if (sk)
+		sock_hold(sk);
 	read_unlock(&iucv_sk_list.lock);
 	if (!iucv)
 		sk = NULL;
@@ -2140,6 +2142,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 		kfree_skb(skb);
 	}
 
+	if (sk)
+		sock_put(sk);
 	return err;
 }
 
-- 
2.53.0



