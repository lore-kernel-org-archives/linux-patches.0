Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058EF47426E;
	Fri,  7 Aug 2026 15:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116913; cv=none; b=Ul8T/3M+VfXJ8gcQmOv71clobZfAbIqfFBYIAzDjKeLz11+JRxmysm7y0xJz8mIzPg9okk8np74yrsL6jSoMZAGw58ypLsX9N8c9JQVJpKUH+R6phVFDBpB1vAuyIfM7ncH/GQZRkrgvZyZBI7Mcx9j+9sr3/NY6E0xvItvBB6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116913; c=relaxed/simple;
	bh=EP9fFN/CRXZMefU5wpvwxU4z0xVgWWGB1ebnU1X8nuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ytd9nRbIl7XPqDqO0NYJgrRQZI0fxZlIDEiM6DvdqOc8kcBCdRV7lEyCz9tLVocH6sr2+1msXvmpIH5pdgYqSiwr1oIqfS3PdQtbljlKP8WfU+yDKDLI05qwW/sVs9UubMO10OY2j9+N7HJ/Q3aa1MKXp/qOhTD0uDmD8aGb2Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lU+ujFW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lU+ujFW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2E01F000E9;
	Fri,  7 Aug 2026 15:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116911;
	bh=EuZrFna9uMrpZjGv1HOrfEN3PaisPZebIu99vz5url4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lU+ujFW11+YIXMNN4XObBHFSuq1eilkYFDADOaVwiK9Qc5mjynKWG/w1nYbFf+wPw
	 QheID9xlZgxcvrGIM//ffhp8nbjRhXXint2E2KPQmw3edckzmzheRYekCGivrk0KAP
	 NK9QwCGtESZH3sb6sQUz8SxapGjHNOWc+t7+D75M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 134/438] Bluetooth: ISO: validate sockaddr_iso first in iso_sock_rebind_bis()
Date: Fri,  7 Aug 2026 16:35:30 +0200
Message-ID: <20260807143430.857533510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7e8f8a51eebd2..06b6fec364485 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1038,15 +1038,15 @@ static int iso_sock_rebind_bis(struct sock *sk, struct sockaddr_iso *sa,
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



