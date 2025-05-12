Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F4114658D;
	Mon, 12 May 2025 17:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071058; cv=none; b=FiNMcE7h9URVseCvI3ZYfpOzirKooY94/Ux9fqU93PJd4bUjlK7dD1iJ7lvUYo91yZBze0xX1SDkiDqlHoAtUy7bO8CCjXEif2xdKObL9f6YtyDCrsqGeM9iiz6gAVzsf7tboVm+geREBji8TCQOn30k5lvKHwzQSYk2uknKP+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071058; c=relaxed/simple;
	bh=E5gqgPoy62F6bXuADOgdKJlIbfc3tKZpbtnROhz8B+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSXTfXzYV+ABgvnj36xEb824pIuontBAxkOo8i+5eDi/YgCUdpCAlgHS5BHWxyVz+i9Zlzx65wGg6YLGAuXE+YzzgQMXGdP+aQ+x6OqdAED5/v0x7RO0mM0TAAgfLVgpMtHazIrRkcjfWwTxYWN2HYcWf+LB8APkFgezeJIYHAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yG4G5WHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yG4G5WHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7071C4CEEF;
	Mon, 12 May 2025 17:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071058;
	bh=E5gqgPoy62F6bXuADOgdKJlIbfc3tKZpbtnROhz8B+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yG4G5WHmRR2Mq0bMp6Tnr4a53+MdEKNQEBNWGPSAQXVmDqai6Do2SFUB9/F30kf9d
	 R/kXOLqfGHqZKVwTPZ5yQK7Txv62B5EgiuImbd9ey8kHcZrNnybGjSqrZ03G1DCV7H
	 188b5Y89erO5gYqGhK6ODolr4lrcpmcTNVNYzBd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 03/54] openvswitch: Fix unsafe attribute parsing in output_userspace()
Date: Mon, 12 May 2025 19:29:15 +0200
Message-ID: <20250512172015.783420631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -954,8 +954,7 @@ static int output_userspace(struct datap
 	upcall.cmd = OVS_PACKET_CMD_ACTION;
 	upcall.mru = OVS_CB(skb)->mru;
 
-	for (a = nla_data(attr), rem = nla_len(attr); rem > 0;
-	     a = nla_next(a, &rem)) {
+	nla_for_each_nested(a, attr, rem) {
 		switch (nla_type(a)) {
 		case OVS_USERSPACE_ATTR_USERDATA:
 			upcall.userdata = a;


