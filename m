Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B92C421EFB;
	Sat, 12 Sep 2026 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220491; cv=none; b=R5Kf+BD/bgK/Pb/jyn+78lzVnvR1z/lFdE+6Ip2uTb1lK7TjBFfMP3PUI9LuyDxPJt9nX2NO7AjAo3iN4hwV32lRrRaQEQ5wU13mtojiXA2uTlCJk+ot482Brb1rhXFThoLA43TGyoMAGDUjylpCPr0wK9Sd5mtJ5ZFMcixR+GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220491; c=relaxed/simple;
	bh=vJggr5PH8oRi+TOobKKNyh9k+vnYZ441kwwF5a2E7PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka1/UvhAaJ/ECBTng7gGOs0gqg1HJOgS+c3DB6YRGHE5bRNweIO4u3ipdjrncugIBYx01mRYrsEoLiKv92O1h1y6iTbNFdGf3Z2nNeVh305R0eJ3dnFQTd+X9iGYrA6TUDVl7FeaLPz9Auy+tPLu/v5Ojn01NTO9h1tOnJbNF3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oklKaGqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oklKaGqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9848C1F000FF;
	Sat, 12 Sep 2026 13:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220490;
	bh=0+xM1leq9z+tEZqHGdI91Emsj5QpSujsHreTq7Hm86k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oklKaGqI/mjhNU7WHUXc8oSnr2surKiFhaPA0Nvlrj9tI7PDgYCmtf0rpO0YYLJt0
	 0zOIeJKLXIX1uq4Mbz1bHWFHubCd1oSSYmCtv1Rd7yM11L8yd0QiC8ccVWJsFmPfVg
	 crwWzku3oIEj0BcAre3oOJUtFjDym+xBpAKj+g+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jongmin Jang <payload.jang@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 0188/1424] openvswitch: only skb_tx_error() a packet we are about to drop
Date: Sat, 12 Sep 2026 08:43:40 +0200
Message-ID: <20260912065611.499238302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -282,6 +282,7 @@ void ovs_dp_process_packet(struct sk_buf
 			consume_skb(skb);
 			break;
 		default:
+			skb_tx_error(skb);
 			kfree_skb(skb);
 			break;
 		}
@@ -582,8 +583,6 @@ static int queue_userspace_packet(struct
 	err = genlmsg_unicast(ovs_dp_get_net(dp), user_skb, upcall_info->portid);
 	user_skb = NULL;
 out:
-	if (err)
-		skb_tx_error(skb);
 	consume_skb(user_skb);
 	consume_skb(nskb);
 


