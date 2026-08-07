Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196A444A3F4;
	Fri,  7 Aug 2026 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114975; cv=none; b=NqE6dlUlhEGoo6flQqOjnGAC+6Nq629s98uzjFra5aKLERdq10CTZV+2ZFjG5KOmi5mGkyJLKi1w4UUottX9s2TlcElb6+HhEnHB/dm7x09ngMnF0MxU/K4rxwyaaVLUdsTRpEdEJMJI4V8SchcIjsJ3HOmfrTlfWYDZ5RUFYUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114975; c=relaxed/simple;
	bh=RsALJc05buQCIW2V9e1gHiKCoMGDRbwpJpHVTw0rSv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iP6YbdJPCr+f7dzQlXRVUB5ByrzFc0ev3lm+CWaR6g3BYd8/n6VvJSkCX++VurbG2KPdyog48tj7KxxXqmMRyRsefRrf3AwqSDojE4WlkcTCg8M2Wv6TgG3puXyxinx2PIG5wXJsvXtD1c+UxSnEMEm4ICQa8HAy1A1JPUVBoyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWgypRkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWgypRkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A631F000E9;
	Fri,  7 Aug 2026 15:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114974;
	bh=ipDuMTH3+V1ulHhgOT2M8xEg/2Kl45W7TgmOu90EM6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWgypRkOFYZrDhG7hcv9W6pW3H61F4+dWjG8FexfuayXDJgFtM/rpzVXkxavhExql
	 pT9dtSv2LIVtmp9c8D9bUGBUtGm+qCO1LvsisbVaeSeRRRbbdpJj+QZ0Pz8Obz1oSf
	 nYIXmVi5FLURgoNCkLyQIZ9vnCJ4RIeNvioFHznw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/396] Bluetooth: ISO: validate sockaddr_iso first in iso_sock_rebind_bis()
Date: Fri,  7 Aug 2026 16:34:33 +0200
Message-ID: <20260807143426.732705143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
index a0ef76ecb80b8..98fa94644b4a6 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1022,15 +1022,15 @@ static int iso_sock_bind_pa_sk(struct sock *sk, struct sockaddr_iso *sa,
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



