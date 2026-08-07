Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B04C397958;
	Fri,  7 Aug 2026 15:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116321; cv=none; b=u4k0EiuIkkYuB50QimaUX3N+65ZjScV9TnaghLKXmqGPdgoOudmnhLWAuR7ssNPXHORJSplM14EI5DE017xjLfzjX76kTkFYGnNCDzCTA/4/2g04uOIpgw4rDEko4W69bTkajWmFQEjTTY9IxYrZqbsj1Zv+RtTMV8iEmzXdGJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116321; c=relaxed/simple;
	bh=nMqVovKnNX1+MUDgP/9o9Lm235FVUZd3YwuhxtUCAAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSZ7tFSGVkmtsN5g00UdywM465VUjaUQsms+5eM2c4vev1h2js0hj90B4gmOPIDAT5ce8J+5pipn2FD51LH71IZipxUgTZ3pujqz9R5uFhLQ9HpIbycQkzyTy+xFNjGy9Ya4byOSrbEz/ZOcRQi81HuqGQCYP2E5yd/4ZlKdoy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muOx5g0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muOx5g0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776021F000E9;
	Fri,  7 Aug 2026 15:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116320;
	bh=2JkQ8Si64uS3bq2Z5flcVmC/hzHmrFXrwHrp+l/zcMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muOx5g0bjw2zuK6X4T/EB7yA3tiCVAONqkN37IQO3UqLk9VJrV49/dwaDfE4N4cjG
	 YwpXSwRWEC9Ve3yk2pf0IQ7pg8L1bLyFxAWbkNTAK+6SPBWB1XcqKA4o1cHqCN84kX
	 OyAGljrIjGxg48cmGHVuRM81emBry4VWxM+vNoZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 163/261] net: openvswitch: fix skb leak on flow key update failure during recirculation
Date: Fri,  7 Aug 2026 16:38:40 +0200
Message-ID: <20260807143418.880274988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

commit e1cf066244dad576221b7123a0e5005967f25a20 upstream.

do_execute_actions() returns right away when execute_recirc() fails on
the last action as it assumes this function always takes ownership of
the skb when 'last' is true.  But when the flow key update fails, the
function doesn't free the skb and it ends up leaked.

This is a very unlikely scenario as it requires the packet to become
unparseable by applying a set of actions on a previously parseable skb,
but should be fixed nevertheless.

Reported by Sashiko.

Fixes: 971427f353f3 ("openvswitch: Add recirc and hash action.")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260727181851.306076-2-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1120,6 +1120,10 @@ static int execute_masked_set_action(str
 	return err;
 }
 
+/* When 'last' is true, recirc() should always consume the 'skb'.
+ * Otherwise, recirc() should keep 'skb' intact regardless what
+ * actions are executed on recirculation.
+ */
 static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 			  struct sw_flow_key *key,
 			  const struct nlattr *a, bool last)
@@ -1130,8 +1134,12 @@ static int execute_recirc(struct datapat
 		int err;
 
 		err = ovs_flow_key_update(skb, key);
-		if (err)
+		if (err) {
+			if (last)
+				ovs_kfree_skb_reason(skb,
+						     OVS_DROP_ACTION_ERROR);
 			return err;
+		}
 	}
 	BUG_ON(!is_flow_key_valid(key));
 


