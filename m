Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590922;
	b=OnTRVFinfA3MtwEGc640AjWoahNmYqiHGNPnjw+hMIuR4BuNMIrVQYV4e15eEfHd3IJ1
	 CXYXFVp/pnbb6aY2LElAOKltPc1v75OK6p4ve08FQ8zh0UEAFStiYHO7ggK+sQE9lkoVQ
	 4mt4sr1G63XYkw0sDeGDX5f5hxWpFGC6lbj3oJCoF2mn1fwGtoDpY91LpVSEREWGpSQ27
	 3dGIydrQMPonJ8ZXJSp1eqSY8dNJeS95jAj42tCVKz1Dgq50snAQ25pl9Padihxm4Om2F
	 uMDFlay88PgGG0Z628R06oihLxOIUt+cpJT16TJOJ6A7ezYk1pwMvFsl4TP8bNvsL6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Cz0vlahcXVP2FkjiXAX87uPoSEj20c5cC0XEbZvBqs=;
	b=z5vfatzeR23G6rss7RSc5gma7mj4MQ6EyRwPzDMh0y8HNxflieAa7LUePk9SoSGfdb1r
	 nbHJ6TAzeO1XZXWzeYobvi8rC9C03Muhg3jOawSCsUSIN8nP/F1ow93e2O4IpSA9JMvoH
	 2pJr06fXTq61uoghhjvykn9jhnSZOgBnzX3cnIGbV+iYrpnjOIIwZWfjVfURqSxEtGSHp
	 lqrJgPMPgEX2K8knn/dq1p92epdQNz0KjE9NCf1bFEDSy5eUILcpjOY98F9zVfcp4Xv9P
	 OyYA7Ok9k+Wi7y7ouRl98AdHUKZ+1gL3EvYnAPCleHJOUUxHVHRPtmNwAnaX/eVxFVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZnrKSOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F199606E663;
	Fri, 13 Nov 2026 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZnrKSOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76A11F000C6;
	Fri, 13 Nov 2026 17:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590921;
	bh=7Cz0vlahcXVP2FkjiXAX87uPoSEj20c5cC0XEbZvBqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZnrKSOSjnnVQtl/LSED8AXDl9gYSoZRGP+SxuRCMdfIhwCbnIXYFsB5QfRasWfCX
	 5uxd+lfCHnavWZ+2oSDORqSsnttqtH012Irr2CSoBgEn/TH/6xX9sfm0tJIQ2xRny0
	 TXz3Ww7bo8NJ+g0g04IHgxc0PL1nnYWSi58y9w7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/670] mkiss: restart the transmit queue when the interface is opened
Date: Fri, 13 Nov 2026 10:44:34 -0500
Message-ID: <20261113153815.581487536@linuxfoundation.org>
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

ax_close() stops the transmit queue, but ax_open_dev() never starts it
again, and the core does not do it either. After "ip link set ax0 down"
followed by "ip link set ax0 up" the queue stays stopped: the qdisc
never calls ax_xmit() any more, so the 20 s transmit timeout recovery
in ax_xmit() is never reached, and mkiss_write_wakeup() cannot wake the
queue because ax_close() cleared TTY_DO_WRITE_WAKEUP. The interface is
up but does not transmit a single frame until the line discipline is
detached and attached again.

Start the queue in ax_open_dev(), as network drivers do in ndo_open.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 76c8761457861c18de2d32607e5c7b19c49326ca)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/mkiss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index f11019d155764..8b0e2ca5d0ea3 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -589,6 +589,11 @@ static int ax_open_dev(struct net_device *dev)
 	if (ax->tty == NULL)
 		return -ENODEV;
 
+	/* ax_close() stopped the queue: restart it, or the interface
+	 * never transmits again after it is set down and up.
+	 */
+	netif_start_queue(dev);
+
 	return 0;
 }
 
-- 
2.53.0



