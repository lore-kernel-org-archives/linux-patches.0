Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D741E505;
	Mon, 12 May 2025 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072655; cv=none; b=SusiuAZsLrzF13CCtROeMUPIQiLRKzYV+oQ0qROQxMOllMNvBNum0aJ1HoIrSdnZiQTnHo/ChYa1F8BEHzW5HMaLJM0OkaApY9lskDlA485Feg1G3YsU8Z7ShFpKjoyhVrzCzjRdRzGzoDdvfP9nyl0SlXJfUPOibYlm8vfYOaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072655; c=relaxed/simple;
	bh=riAlaUHRZdtSHcDbP/0bAaWyydhJkUS+J8kvD38t3CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXtj/m3FgUNMkaTiMNMMZ1DRkbOllDZ66Opi9mznWvCMneV9VLRD9ytYJTPuwFo6/F6twqN5Spc/7TfKDX1zHYyuaZMZJGoPFq+4ZYwy9CZcZVGctXBboN6PzY1L/1/5KlqQiS8qmyc+bDta4+4f/DkPUK6xPqNECMBJT3vv6pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4wSIwGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4wSIwGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D45CC4CEE7;
	Mon, 12 May 2025 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072654;
	bh=riAlaUHRZdtSHcDbP/0bAaWyydhJkUS+J8kvD38t3CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4wSIwGLpMwsP4vKpo69ce/hsgI+x8EQlFM7DCOSFnhKjYR7RQNNfqm3WwDhsaOjt
	 B6LyQxIlwMud6n6As707uPW7yhrMz/3Sfti0ILPqAuH1crsZzhwJbEj+9osuraVQlz
	 q6cdPPMGRHknMoka3tvzg7jQ9Iu3YWmwMnPKA9AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 016/184] openvswitch: Fix unsafe attribute parsing in output_userspace()
Date: Mon, 12 May 2025 19:43:37 +0200
Message-ID: <20250512172042.337053953@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -975,8 +975,7 @@ static int output_userspace(struct datap
 	upcall.cmd = OVS_PACKET_CMD_ACTION;
 	upcall.mru = OVS_CB(skb)->mru;
 
-	for (a = nla_data(attr), rem = nla_len(attr); rem > 0;
-	     a = nla_next(a, &rem)) {
+	nla_for_each_nested(a, attr, rem) {
 		switch (nla_type(a)) {
 		case OVS_USERSPACE_ATTR_USERDATA:
 			upcall.userdata = a;


