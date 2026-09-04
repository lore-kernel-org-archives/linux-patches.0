Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B44411FBF;
	Fri,  4 Sep 2026 05:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501258; cv=none; b=R1lQuXxtqTJ/dVNn+NVb/r7TK4eFu/pdVmN759ulG6mUVMnIgffI3oF8pvzK3PI5AALLI7jYCdyMW0AIA5rtq+EXlIemTqUHHUbEqwNDcV7S/QC7bSy99umXiEAnl1YF4eUO+kkB+DKiuahDIQjCI6bRr5mXinhGWy4XmFSriDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501258; c=relaxed/simple;
	bh=Th6+yGq+NNV/X/ZaHa7lvRggPWfKFC4sNP+RJhxSJOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot8ksnxuCoscYRQpPG05qhQIOtTDTSwrcr1wXH74srJ0R9/cpAB9B/AIa1VVPtyTKKFhSoCmNYTnbHXVMB+9QW9ve234E4cEI84R2b9WCdeB0+U/q2Z5LXjwn1PJg3kGMa3eu4m5LpAQyToACD+jPE9eDuh6eJSTTz2KI0EDj5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Znh+GFtc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Znh+GFtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C5D1F00A3D;
	Fri,  4 Sep 2026 05:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501257;
	bh=NWpxzLKeJjVd/LQmwotUEIBwST5e0xv+gnnO98GgW1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Znh+GFtco9nQpg8Jct6LuftLvfeQZyISId2PX3kRkz3SQ6HcpxPpeQWhTZKdBMrag
	 q+bFCLsuef8hDA9otHvkwoR3OFXLRxEGFPocIMIS6MPmONkVKWkVWp5asz6hLnMHSg
	 J8rQX3Jv2YvgajQmKGwxEaL5mWk7tRB3E5dzsdag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jongmin Jang <payload.jang@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 344/552] openvswitch: only skb_tx_error() a packet we are about to drop
Date: Fri,  4 Sep 2026 06:58:21 +0200
Message-ID: <20260904045758.052878869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

commit 0dbc2398fca3bb33eda963849f865ddb1b3aa05e upstream.

queue_userspace_packet() borrows the packet skb -- it only copies it into
a private netlink message (user_skb) and does not own it; on return
do_execute_actions() keeps forwarding it through the flow's remaining
actions. Its error path nevertheless calls skb_tx_error(skb), which via
skb_zcopy_clear() does skb_shinfo(skb)->flags &= ~SKBFL_ALL_ZEROCOPY,
stripping SKBFL_SHARED_FRAG from that live skb (skb_tx_error()'s kerneldoc
says "skb must be freed afterwards").

For a MSG_ZEROCOPY skb carrying page-cache frags, SKBFL_SHARED_FRAG is
what makes esp_input() skb_cow_data() before in-place AEAD; once it is
stripped a later local ESP-in-UDP delivery decrypts in place over pages
the sender does not own -- an unprivileged page-cache write (the
"Fragnesia" primitive).
do_execute_actions() ignores output_userspace()'s return value, so any
action after a failed USERSPACE upcall inherits the stripped skb.

Move the skb_tx_error() to the flow-miss drop path - the "default"
branch of ovs_dp_process_packet()'s switch(error), before kfree_skb().

The call has been here since commit 36d5fe6a0007 ("core, nfqueue,
openvswitch: Orphan frags in skb_zerocopy and handle errors") but was
harmless until esp_input() began relying on SKBFL_SHARED_FRAG to gate
in-place decrypt; only then did stripping it on a still-forwarded skb
become a page-cache write primitive.

Fixes: 36d5fe6a0007 ("core, nfqueue, openvswitch: Orphan frags in skb_zerocopy and handle errors")
Fixes: f4c50a4034e6 ("xfrm: esp: avoid in-place decrypt on shared skb frags")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Tested-by: Jongmin Jang <payload.jang@gmail.com>
Link: https://patch.msgid.link/55A52703-7548-4A55-A9CE-2A37145BDCAD@doyensec.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/datapath.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -285,6 +285,7 @@ void ovs_dp_process_packet(struct sk_buf
 			consume_skb(skb);
 			break;
 		default:
+			skb_tx_error(skb);
 			kfree_skb(skb);
 			break;
 		}
@@ -601,8 +602,6 @@ static int queue_userspace_packet(struct
 	err = genlmsg_unicast(ovs_dp_get_net(dp), user_skb, upcall_info->portid);
 	user_skb = NULL;
 out:
-	if (err)
-		skb_tx_error(skb);
 	consume_skb(user_skb);
 	consume_skb(nskb);
 


