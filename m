Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750B1303C97;
	Fri,  7 Aug 2026 14:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113972; cv=none; b=g7P1zuZG9G4McAxgmy4jZVSNk9jfmMlryRuVkmOSl224xIEj0x1l3T94lbOMMsDesnUGxqoCYPYDrWxjcvbxgRCiCBlhe87lrfTB/Q9ILkb9O8P5R8kf1QX3wAXG1hJCwAPaAM/lr+mj4KBjiuJ/81V31kVEV7tlcWkdJtre4Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113972; c=relaxed/simple;
	bh=AYsI5Z+rbmMeRMNku7fHDxeiNJ4QNaprsWH766FVJfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPUfzH5tqk3eGQKnf4dIkqpWeGfV7FYKbpOoMOw6iHCtRnFvRwfqijFAahoQTHANXYfSpGruFFreb5Bd3vF8CoyteugKN2D2xtfLCoFQNmOh14gqeocM8uCaUCtsX+02z3VWWhHt1VDAfgx4Nx2aea2K6ystcRbDqghhWfMN5c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVoR8PAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVoR8PAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D191F000E9;
	Fri,  7 Aug 2026 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113971;
	bh=H4GF2HEqovQSFjsEVtQayBOhzz+Q2Up4ORFKieWX5EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVoR8PAC8V7Bei14Vlvtvn91JmXar3m4IUnCuEUdYmV3maOpKMnDwez4PW0U/5x8x
	 XRAge6Xfm7JpPdK/V2A2hwy3jPEBBrglKi/962eBDW60tNldfngliyg1L6E4IeAohh
	 2aZ4RY8lcBz95nAmSz/sfL4fdb5NCjTYSONQkXlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/337] Bluetooth: ISO: validate sockaddr_iso first in iso_sock_rebind_bis()
Date: Fri,  7 Aug 2026 16:35:02 +0200
Message-ID: <20260807143420.686178928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 4e20192d46a685d73e590a60a4a2419a0a8afcbf ]

iso_sock_rebind_bis() updates socket iso_pi(sk)->bc_num_bis before
validating the BIS values, so it's possible to end up with bc_num_bis
inconsistent.

Assign to iso_pi(sk)->bc_num_bis only after validation.

Fixes: 80837140c1f2 ("Bluetooth: ISO: Allow binding a PA sync socket")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index c54e42ab6947b..06c68e053b423 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1014,15 +1014,15 @@ static int iso_sock_bind_pa_sk(struct sock *sk, struct sockaddr_iso *sa,
 		goto done;
 	}
 
-	iso_pi(sk)->bc_num_bis = sa->iso_bc->bc_num_bis;
-
-	for (int i = 0; i < iso_pi(sk)->bc_num_bis; i++)
+	for (int i = 0; i < sa->iso_bc->bc_num_bis; i++)
 		if (sa->iso_bc->bc_bis[i] < 0x01 ||
 		    sa->iso_bc->bc_bis[i] > 0x1f) {
 			err = -EINVAL;
 			goto done;
 		}
 
+	iso_pi(sk)->bc_num_bis = sa->iso_bc->bc_num_bis;
+
 	memcpy(iso_pi(sk)->bc_bis, sa->iso_bc->bc_bis,
 	       iso_pi(sk)->bc_num_bis);
 
-- 
2.53.0



