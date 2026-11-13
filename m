Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590097;
	b=Yd49se3SErEwarDIY6HEGG0V/FTCf9XIdEMI+6UZhhjwpmq9hNZFDSGfSJ8vRxDB+dxW
	 Hio0pDHs0sdC7prOSyb0yZWQMsPgT/9r7dgIkNJm6+TAv6AmKrm0fSKnq5R/XT7SVk7TO
	 IWRofYXYn4qIuEOh4rlsR8ddvZaQ8C+4DcifX1IaHTBwAS5noFmwoK9Gcj4byluF2BQmQ
	 f9H9C5Uq82Sode92cwpRDkJ09MuudM+jaK1yzWTBvmJ7H70rzIWlqKLJlg+oe9ZLJ36SV
	 76qizegDHxp2ACPkvA726+FPDGO6DUGewjpNZDWFabBHTF1upjqtzdP8wHRAymMSeog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kL3nBPR3LtJdt7hfsNtROSg8HjNNZqq58+1cNLKM7Jw=;
	b=RzYvHVYs55w4cWoDe7JLrUCCKVexZaXjqUxHFZAeigMAdRk9o91JPuMNKeSIl7Em46FG
	 IesDlQ9ZViJj29NXSHAItwZF+pPtldwSe0GdHlLeAo8NEJvBkZ7NYdNLu3ATgB9heNXQc
	 BhNhNJyl2lXlCWTjsw9tnI0hKy/z/JItXfsBg2yyYKuVq2MB6nUwj9at6wSmO0HlgjK95
	 /HuDnrdmgSPorVltYzwabjbFOCBiqsMNT1GzAVQOacuQDa2YShWUc2F6bEJu99F3NH+J3
	 8H9nzNxrixYBslDe80z73nfAnkYEKXLvHrEht3wBbae+hLfGgLZkj0SpEl0aVOf88kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVq4O3wK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148A960A2606;
	Fri, 13 Nov 2026 17:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVq4O3wK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42A51F000C4;
	Fri, 13 Nov 2026 17:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590096;
	bh=kL3nBPR3LtJdt7hfsNtROSg8HjNNZqq58+1cNLKM7Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RVq4O3wKWIILz5oHq4iO28eLRFl9Zs3AUu+RZ5UqHd3KfEyR2yIhQuxPBrIEE8Nms
	 bc8FOMrk4rnHlS557X+N8Qi/IUxH392hORs0Y2HrQ3EdQx11pk0JYcRWfE7s8rAfaL
	 SJXbipLqFD/1xtCMhLggTnFwJzl5KCXI00psa7Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/686] ax25: free the copy of an IP packet that ax25_send_frame() turned down
Date: Fri, 13 Nov 2026 10:44:14 -0500
Message-ID: <20261113153824.926133619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

In virtual circuit mode, ax25_ip_xmit() copies the IP packet, charges
the copy to the sending socket, frees the original and hands the copy
to ax25_send_frame(). When ax25_send_frame() gives up, because the
device is going down or the connection cannot be allocated, it returns
NULL and leaves the skb to its caller, as ROSE and NET/ROM expect.
ax25_ip_xmit() only handles the non-NULL case, so the copy is lost,
together with the send buffer space it holds on the socket.

Free it when ax25_send_frame() returns NULL.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, ax0 on mkiss
with IP 44.0.0.1, static ARP entries to DEST-1 and DEST-2,
ip_default_mode 1). The ax25 module of the bench has a parameter that
makes ax25_create_cb() fail, as on an allocation failure. A UDP socket
sends 300 datagrams to the station behind DEST-2 with that parameter
set, and its send queue (SIOCOUTQ) is read 4 s later:

  before: 222 datagrams accepted, then the send buffer is full;
          213120 bytes left in the send queue for good
  after:  300 datagrams accepted, send queue back to 0, five runs out
          of five

A control run to DEST-1 without the failure, where the connection
times out, empties the queue in both cases.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 4bb41115414921c65cad999bd7d7b84cc67360b3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_ip.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ax25/ax25_ip.c b/net/ax25/ax25_ip.c
index 215d4ccf12b91..b24cb88d75de7 100644
--- a/net/ax25/ax25_ip.c
+++ b/net/ax25/ax25_ip.c
@@ -176,9 +176,14 @@ netdev_tx_t ax25_ip_xmit(struct sk_buff *skb)
 			    ax25_dev->values[AX25_VALUES_PACLEN],
 			    &src_c,
 			    &dst_c, digipeat, dev);
-			if (ax25) {
+			/*
+			 * ax25_send_frame() leaves the skb to its caller
+			 * when it gives up, as ROSE and NET/ROM expect.
+			 */
+			if (ax25)
 				ax25_cb_put(ax25);
-			}
+			else
+				kfree_skb(ourskb);
 			goto put;
 		}
 	}
-- 
2.53.0



