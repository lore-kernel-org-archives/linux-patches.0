Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF70296D3A;
	Mon, 12 May 2025 17:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071754; cv=none; b=s68tzPNja3U2w5ffqtiZRCgHpHlzbdgTM91e/77gpkLvhM92QlV50nE9GbrG606dbvMHgBhZzlcopNMy//Tfh0N75EWDn30xjQv/QRsld/mDcy38qX1nZ/EWYQSgOLlWyWA5FBPRPkfHm5bEGT5OT29nfAWxi/bJR6+ezcM3uPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071754; c=relaxed/simple;
	bh=0F5tEMln5DUdNvjHVT+Bm9m54tHoA7VRBJmOcHKL9VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZifJDxlVnHf9yJ2TKeiqenYd/rsxQ1+oayLKrsmF0tVNTnpBdg6RD3xiqtAqpmjIL6a+SuxIVL/KKzFuL1ZM1z3ooWOHG4gU2oDPkh11gtcFBnKPsaxxXdKnAUWmasapntndG/db+q6JovIRravDsTaxa+fTTOP5nL9ZBV9u3Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lD2hO5nH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lD2hO5nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC59C4CEE7;
	Mon, 12 May 2025 17:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071754;
	bh=0F5tEMln5DUdNvjHVT+Bm9m54tHoA7VRBJmOcHKL9VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lD2hO5nHm/aa5zbehczoNVzChwCsCPESM4w+7SCENAiNjXc+ELSXOvTRuYc8jSfwA
	 /I4uSdmV49swo7Gyc1A3Gh9PpBiTeT1TFNz2H2kebT5MhdQ9Ag45DGl1IOwiVzx5kM
	 W7NYNla/uw/QO5PUSblfbaaPNscSunSbuYNJM0eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 016/197] openvswitch: Fix unsafe attribute parsing in output_userspace()
Date: Mon, 12 May 2025 19:37:46 +0200
Message-ID: <20250512172045.005161764@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


