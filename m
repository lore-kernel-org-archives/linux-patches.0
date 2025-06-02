Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6FD221FC9;
	Mon,  2 Jun 2025 14:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875146; cv=none; b=uXlEdb4nNj69o5dY4mguxhDkp3HMY2t+xDKzy2frxhqoVuGbdF4ylYQvW0pFp/G0FM03tALEDnewhfVCtmQGNnrD14S95POk8qn9WfucsSjrNw2rmKEegvT5GJCgRg6cB8IV9B8WYM9PnadYAJdNXmz95F6aLunne5m11KiT0UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875146; c=relaxed/simple;
	bh=wZpIpJwg7Nuh5RmmFlWOtnd1KvENwheJez8+TmATutA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFYZRJoLjIPz721yi1QeqGdJmJ5AOLC+6Qts/o4aD9wza3y/h/dr5KHUAiMlvd/pvG+jyulnF2fBAsOkzCkw0RBLO3gMDNGb8k/ZD6Pd8YB70uCqftMU4A3Z1G3ThWyEaJ+dfI5ygDQnt7A9qDCLaH9N4ipKWx0pR+9U4Xc95JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVVjJ+e6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVVjJ+e6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7067C4CEEB;
	Mon,  2 Jun 2025 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875146;
	bh=wZpIpJwg7Nuh5RmmFlWOtnd1KvENwheJez8+TmATutA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVVjJ+e6qQP39ZtjxkdDLQf37GGOV2QfqZ/6EaJmyi0DwmU0A+zjL9f3TV0m6GEt6
	 5U1uNlJ7ICzaePU7Oz4w07Ow8qtOUhQvs6fqp72ENWCUHPBoRHb2NS6njIYYg3Aw2y
	 sPfrXy/mGao7p4RcTzJv7FfCgBBNdSBXdJOelDi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 043/270] openvswitch: Fix unsafe attribute parsing in output_userspace()
Date: Mon,  2 Jun 2025 15:45:28 +0200
Message-ID: <20250602134308.949483882@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eelco Chaudron <echaudro@redhat.com>

commit 6beb6835c1fbb3f676aebb51a5fee6b77fed9308 upstream.

This patch replaces the manual Netlink attribute iteration in
output_userspace() with nla_for_each_nested(), which ensures that only
well-formed attributes are processed.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Acked-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/0bd65949df61591d9171c0dc13e42cea8941da10.1746541734.git.echaudro@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -953,8 +953,7 @@ static int output_userspace(struct datap
 	upcall.cmd = OVS_PACKET_CMD_ACTION;
 	upcall.mru = OVS_CB(skb)->mru;
 
-	for (a = nla_data(attr), rem = nla_len(attr); rem > 0;
-	     a = nla_next(a, &rem)) {
+	nla_for_each_nested(a, attr, rem) {
 		switch (nla_type(a)) {
 		case OVS_USERSPACE_ATTR_USERDATA:
 			upcall.userdata = a;


