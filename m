Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B93439F71;
	Mon, 17 Aug 2026 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976191; cv=none; b=YDKF7Q38K7cAk+8f+FIFAtBbm92i7YU1zQ6ERh5ulgpU3lVzukWEdP9D/TAqLLpM6PnpFIJ2RXb5tG7TQNmfnC1CXNngUVV8AG4MbY7ljprsQA02jiwt6zZdLpHF/RjZLYnL10OyOaUD2jEQBw+XVKGlaqgU0eyw97ZOJZgZkIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976191; c=relaxed/simple;
	bh=9+f2wjSePQzvCiHQEv1r8yWjjYKwrqzoNi4gcuvE/+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNkXGkN1SXYy3+8YPyN6HyB42mvRKDYeIM2oNrPEscjVeCH7/ivTOAYJh/207CXvXVaK0yPJcZz6jdv2NXoa/u03wGAvIM3I1gi/pi9/Njv8lVLZbS3CG1J+lMQq2CAsnjSGVXZAs+qEE7/GSnaUYXOHEYK22Rc3j5OcI2ltjck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOPHvBJe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOPHvBJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA69F1F00A3D;
	Mon, 17 Aug 2026 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976190;
	bh=j1c2/xuAC1/in6iMHuJ1zeBIN+mHXXJEsXWFzLgWN9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOPHvBJeySkOl/GQob8ur/grsyFdwrd8TGctumngaivWw4JbxN5EAuaDTG4WKCZmy
	 jw62mdhTXdZHP1T7KoB+PgUqx5+/lItdRF3l2ueBLC74/bV5t23HwkZHSXyLZ9KhCk
	 CERieRS74nRqEXAqFdYpcgzdxFgG8ZFQYC5JRNYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 289/389] net: openvswitch: fix skb leak on flow key update failure during ct
Date: Mon, 17 Aug 2026 15:32:08 +0200
Message-ID: <20260817132550.365594656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

commit bc62e843bc48f933da765ce47079fd992e535794 upstream.

ovs_ct_execute() always steals or frees the skb on failure while
ovs_flow_key_update() does not.  So, if it fails and we return right
away, the skb ends up leaked.

Fix that by breaking instead and letting the common error handling
code at the bottom of the loop to free the skb properly.

This is a very unlikely scenario as it requires the packet to become
unparseable by applying a set of actions on a previously parseable skb,
but should be fixed nevertheless.

Reported by Sashiko.

Fixes: ec0d043d05e6 ("openvswitch: Ensure flow is valid before executing ct")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260727181851.306076-3-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1316,7 +1316,7 @@ static int do_execute_actions(struct dat
 			if (!is_flow_key_valid(key)) {
 				err = ovs_flow_key_update(skb, key);
 				if (err)
-					return err;
+					break;
 			}
 
 			err = ovs_ct_execute(ovs_dp_get_net(dp), skb, key,


