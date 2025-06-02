Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3357619EEBD;
	Mon,  2 Jun 2025 14:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874628; cv=none; b=nVdHddPjO9M5GAD43L9zwNXhMKyaXQiHlAbtb/Yomf4397Pgz5Me/TIzayUJ2FjK6VW5I4H2ag8JfqSMYnmm5OvA6i5YtSJiH6vwAeviM7pWDaI4dq243cLrZWclH3h964QjTg5BDo+6GqO0v92iE7ePUPoWZ1/fkeycUglzCTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874628; c=relaxed/simple;
	bh=MnRwMwDhaI9ATDka1u3mNK8o2I3CB4FcE3Vy8plc8Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBWVCWoLwRaI1mt0LT5RGdyQI6us4NhToxq+ZVqUdoiUJvPwMGtMfbI/dbebWdR0YHVDOgM+1e26RKOVcwATtrVQue/5zuywt7jXj320zFXQxi0IILvZc2E6pc/XAb40QPORDAwD+j/tjqquiyreXYuGR5buo4CtBHLEZsODz3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+pMulRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+pMulRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD6FC4CEEB;
	Mon,  2 Jun 2025 14:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874628;
	bh=MnRwMwDhaI9ATDka1u3mNK8o2I3CB4FcE3Vy8plc8Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+pMulRpJCeSVrM8ezfWfy8OimYAZlNA0BuiWX5EHCznYN02WEuJQdYWZjYWDnQEO
	 zxa3rGMka3vyqnP+wFI7hkTAUNDzN+Pt3ugsFZVetrI1HYA+7h5uQXzDd1xYCaQ11s
	 bXcNQcJ86AtEwzgiXSzgnzNrxX8M7O1XhfBtTyJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 085/204] openvswitch: Fix unsafe attribute parsing in output_userspace()
Date: Mon,  2 Jun 2025 15:46:58 +0200
Message-ID: <20250602134259.006515719@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -967,8 +967,7 @@ static int output_userspace(struct datap
 	upcall.cmd = OVS_PACKET_CMD_ACTION;
 	upcall.mru = OVS_CB(skb)->mru;
 
-	for (a = nla_data(attr), rem = nla_len(attr); rem > 0;
-		 a = nla_next(a, &rem)) {
+	nla_for_each_nested(a, attr, rem) {
 		switch (nla_type(a)) {
 		case OVS_USERSPACE_ATTR_USERDATA:
 			upcall.userdata = a;


