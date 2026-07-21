Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774F3326D44;
	Tue, 21 Jul 2026 17:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655721; cv=none; b=VY4favGpv0DOk2dofkrKU5P5eQ6vNM2qNbFYfLuT8ucxkbyIFJOxdF0XH7VjLtVRpwA//VBE1BpHU1J7PBuiQquoRWzislm1wKSvI/tt/y/EqSKOwbeV6k85ERXILJ7cCtieXpcH0RKCBOrYttplprhk2Dmx+KA1dVkK5iyTrls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655721; c=relaxed/simple;
	bh=DwzHLpt3xGHAM+vpR1X5POmY5ggDz9Ns1cwUrvap4mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2eEmSHH//VTit/zihZSUiArzQAMiH5Ivhgp4v7xwwxJctakx/OLmHnEJEdzfNUrxUGWP4CDOqQxXvy2MbKOuPjfeNcpBdLwpBRMDFeBYx3sNIqqgLHTh2WqFLSmHxAm7Y0m0OCD6PE9a73LFgdbYtqP3n6hGOvr3aX+MPWR2+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIgF9ZB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIgF9ZB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8681F000E9;
	Tue, 21 Jul 2026 17:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655720;
	bh=rMUJo+ObfIhl1pzCReiT4xt1b8qZ0T3P7uGkBte6anw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIgF9ZB595EI95r58kwm9XYFZjErItnBfjCHdBCw+pySdXFH6dN2Hxsf0DfdiG+UW
	 YXOufwant0ySP5TzPYmWlahLyM13qJl7KnWVexSlFAlNu7erk4XyklXjWYhZYFWMl+
	 svEHl5GoMVu2O80K6jRqMjW4Td6mG3O1FfX3Pl4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0116/1611] vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().
Date: Tue, 21 Jul 2026 17:03:52 +0200
Message-ID: <20260721152517.465357130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 30a45c0bffdd62350261e2f2689fdba426a33578 ]

udp_tunnel_sock_release() could set sk->sk_user_data to NULL
while vxlan_gro_prepare_receive() is running.

Let's check if rcu_dereference_sk_user_data() is NULL after
skb_gro_remcsum_init().

Fixes: 5602c48cf875 ("vxlan: change vxlan to use UDP socket GRO")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260502031401.3557229-7-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index a4ff66e354f532..b706e1777354c0 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -658,14 +658,18 @@ static struct vxlanhdr *vxlan_gro_prepare_receive(struct sock *sk,
 						  struct sk_buff *skb,
 						  struct gro_remcsum *grc)
 {
-	struct sk_buff *p;
 	struct vxlanhdr *vh, *vh2;
 	unsigned int hlen, off_vx;
-	struct vxlan_sock *vs = rcu_dereference_sk_user_data(sk);
+	struct vxlan_sock *vs;
+	struct sk_buff *p;
 	__be32 flags;
 
 	skb_gro_remcsum_init(grc);
 
+	vs = rcu_dereference_sk_user_data(sk);
+	if (!vs)
+		return NULL;
+
 	off_vx = skb_gro_offset(skb);
 	hlen = off_vx + sizeof(*vh);
 	vh = skb_gro_header(skb, hlen, off_vx);
-- 
2.53.0



