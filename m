Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590933;
	b=tmBsn1jNx06gEEetX2/w1/8hFt8AZjgTdVRbezNkcs8GI8zfVjARSZxEBgJWfF9hSHaE
	 7c1ZF4/q6Qc8qZzFZmciMGKNujhBPDTl8YtsZUNC0Y3NXzzUGa28l1BzdDxZEH4N1A1CY
	 trHqbQX+vRB6hgba9yW665rpL9uofStCs6lI3rkA+ZWQyrQ9X14n4TLP1eQRzhdjfNaNv
	 L0ysAboDaU9lx2pVni8upGweCudsKKUJ45g59mhqiBJuuNPA6ksQrJ+mbOopPh6cHf3fi
	 PWFOSxQZeoPfmtJC98tj+MoQSRoUuTtKpwf/iNgmxrvYYPiSt1qDSXKMMC68IWQdOEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kB3qQ7Q4ahVkMSGQBD1se6pBydU9ZetnlI6l2/2lcGg=;
	b=Kwqoo8/QdeYjPTgSkh1AUL8ro7gjwzE3NfHsPOQHJ0MQlG2IwI33d+mTqFpFl6XEECz0
	 Wx82E/imfcA2sb6+RP9y/WNCouwfI+HVGGpk9FyQGXJinYk8QNN99N+zQoDcYd6Pzb1Bj
	 Zuk6STHByLX8M+f7PSgReyXXZopWTvMZ6VWH8PsIIVriKZfn/GDbZjYaCvKAafEDqG3YX
	 mHYfVrJMo3wV8S32l4Hcq0GN1xI9Galczh7FGthjOV1IeVFZhl/U53y2mMVmWlo7qJFaa
	 AcYL3odT1bt/+hBllxkxYIZxzZYZgFK8GYuSN0oSn8NTiVI8IwWbulrXEy0drN4AGYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDTEdj7K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ADC606B348;
	Fri, 13 Nov 2026 17:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDTEdj7K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81851F000C4;
	Fri, 13 Nov 2026 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590933;
	bh=kB3qQ7Q4ahVkMSGQBD1se6pBydU9ZetnlI6l2/2lcGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDTEdj7K+9faSCRjd6Rg/3tqo86qi1HnY5Z2A/GPi2axhC2jrszt/kAZoSUUsbKTB
	 al+IV1DNnsrAVzgCiv1GDcso1MbrTzrfyhsQ0dIlZsfsvwERDMe0Wk8GjptnUI2Z1g
	 cwgFjqZwwl4LepSrXnbexZNCPRXVSW1PNeGcTB5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/670] ax25: free the copy of an IP packet that ax25_send_frame() turned down
Date: Fri, 13 Nov 2026 10:44:42 -0500
Message-ID: <20261113153815.822200438@linuxfoundation.org>
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



