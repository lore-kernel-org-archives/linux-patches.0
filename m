Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058819;
	b=f6gLPQ49c7fxYvwdvxtly5M/e+vUaGtTQXcykwuF7fJCycBpbG6wKe+nEtEZPOGDPLt3
	 h7e7S0FaRCHxlyFj5crOEUeX1jarIVWzbRihH8AmaMGE0IcvJZRPm6jTXOq/nQ9BZp98P
	 wqqBCZDDB/5Wdnko7MpAsC5PKwO431F+xvfc/vg3zEvom0XaShw9VkQFksW+iupuYGx+n
	 2Hfq+vIoEkYKiMn/MDeXATBMwz6Gm/4eP1ee/Q54dFXkdpUjkhfc6wO5UZN2mNWbkETVe
	 jPqpi+66GJ/OPCANrSY5I3i89eL297zJZrhEnYENE1rxbSBohBJ4ffUS9Yjsdf2A3kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nL77ZxoYOzPsS3k46IOcbJyvxGGSV2pTHUdIgeyQFGo=;
	b=VHGDos1zjOUpC3gHO4i+A1XXi+FAu7MYd4F/n7ZuediqNMFboM2stVTfD6TYIjJrsSKb
	 3V8ad/9h4sbu2N1DD1GLfgDUy+WaXFu2g0bEa6TkX5yAbXCic8a93co2op2toMK1DNwMc
	 4d9K8aq4GmvSZz4njf1Twh4S6gyjGMGze7qs/kWSJKVeK5nlvwTdR1fsf3dYH3rCgIij5
	 TG2QDel5oA+V/WF5QNmJYZGZPo0kUYxgu4Oj7tQeK1fqrL2XJy3fr2/utF+bHzZsYhVvd
	 ziK1OAsAT4rrLzxZ935krEvkU2BOMGUBiasXK4qvDtQayBHSlBfNhYY1gMGgr2HImXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yj2UxRfI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A489606A32C;
	Thu, 19 Nov 2026 03:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yj2UxRfI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAF71F000C4;
	Thu, 19 Nov 2026 03:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058819;
	bh=nL77ZxoYOzPsS3k46IOcbJyvxGGSV2pTHUdIgeyQFGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yj2UxRfIeRYWE3VMGflT19beaqIOK/vGwZr7tnxJj8+wBhLxw4++Ie3g4wyKIYjA1
	 jn55/BimBN6211tbaDMnPye+OhJRGxAekYBrKPfrk0R7NnEGJQo8pfM2VUlQ4taCto
	 swaOYc48NYEjz/WHP/hhdrM4iO/ebuVOypGtWy5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0580/1848] ceph: Fix xattr buffer leak in __send_cap()
Date: Wed, 18 Nov 2026 15:43:38 +0100
Message-ID: <20261118145939.483029176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e51cf76e7275d1bb5ad2d529bb00feade632dadc ]

__prep_cap() takes a reference on the xattr blob via ceph_buffer_get()
and also grabs a reference to the old xattr blob returned by
__ceph_build_xattrs_blob(). These references are normally dropped in
__send_cap() after the cap message has been sent, but when ceph_msg_new()
fails, __send_cap() requeues the cap and returns early without dropping
them, leaking both buffers on every allocation failure.

Release arg->old_xattr_buf and arg->xattr_buf on the ceph_msg_new()
failure path before returning.

Cc: stable@vger.kernel.org
Fixes: 16d68903f56a ("ceph: break up send_cap_msg")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index f427c91f311d5..ed5fd6a01c56b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1462,6 +1462,8 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 		spin_lock(&ci->i_ceph_lock);
 		__cap_delay_requeue(arg->session->s_mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
+		ceph_buffer_put(arg->old_xattr_buf);
+		ceph_buffer_put(arg->xattr_buf);
 		return;
 	}
 
-- 
2.53.0



