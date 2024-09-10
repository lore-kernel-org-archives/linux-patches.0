Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2FB18E754;
	Tue, 10 Sep 2024 09:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962387; cv=none; b=JBW9+G+v8oUtBzxEPF+p01HdnF3RGjYoy+fj/9d82cUjatwvYeK3+c7SkLdWLd45F4xxwP7NFxY+MsRd5dQMwIb6vyZM0Ev37CXdhoSK77Lb82j6vxQKeTi5IHwhunX984lAqoxNPyDCZOV240YaVTjfprEAoTITvbNtebXNfdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962387; c=relaxed/simple;
	bh=29dBkXU4A/NlltPgdZTeSneE7XFsqDZSMrvVDi2Adw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaojkp2h6NKuUk7DXak7Uzs4kwal2j1YP3x5tl/2KbVBCAWGe8nnUnG7OB+SRTpFreoALxAaTGBILVuX+/cRqFe1vQsNs2+CgzT72mOBDXvszXa5AxY04PI2sbM1F9GGGpA1zk3aQ5qL/uVhm1B7eL+HfiOGK7MpM6Cr+G3WgsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phfrlFCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phfrlFCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D398C4CEC6;
	Tue, 10 Sep 2024 09:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962386;
	bh=29dBkXU4A/NlltPgdZTeSneE7XFsqDZSMrvVDi2Adw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phfrlFCGLeULtqTau6aPZmeUq9zdQnDX33ukJN0EO7wE6hSsKqbp0k851/bffXuK6
	 SVlC8ex8jhq1akRc4YTVmK92VGZ+Spd5tGHJD3XwC2Nk3n6OMpzkLqQQ372Vr4dvz+
	 nS6ZtPdXV5O5x/HcXOFdTQx5AQMGEK46CKLz9DTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/121] smack: tcp: ipv4, fix incorrect labeling
Date: Tue, 10 Sep 2024 11:31:32 +0200
Message-ID: <20240910092546.560501695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Casey Schaufler <casey@schaufler-ca.com>

[ Upstream commit 2fe209d0ad2e2729f7e22b9b31a86cc3ff0db550 ]

Currently, Smack mirrors the label of incoming tcp/ipv4 connections:
when a label 'foo' connects to a label 'bar' with tcp/ipv4,
'foo' always gets 'foo' in returned ipv4 packets. So,
1) returned packets are incorrectly labeled ('foo' instead of 'bar')
2) 'bar' can write to 'foo' without being authorized to write.

Here is a scenario how to see this:

* Take two machines, let's call them C and S,
   with active Smack in the default state
   (no settings, no rules, no labeled hosts, only builtin labels)

* At S, add Smack rule 'foo bar w'
   (labels 'foo' and 'bar' are instantiated at S at this moment)

* At S, at label 'bar', launch a program
   that listens for incoming tcp/ipv4 connections

* From C, at label 'foo', connect to the listener at S.
   (label 'foo' is instantiated at C at this moment)
   Connection succeedes and works.

* Send some data in both directions.
* Collect network traffic of this connection.

All packets in both directions are labeled with the CIPSO
of the label 'foo'. Hence, label 'bar' writes to 'foo' without
being authorized, and even without ever being known at C.

If anybody cares: exactly the same happens with DCCP.

This behavior 1st manifested in release 2.6.29.4 (see Fixes below)
and it looks unintentional. At least, no explanation was provided.

I changed returned packes label into the 'bar',
to bring it into line with the Smack documentation claims.

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 072ce1ef6efb..7d04b21737cf 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4196,7 +4196,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	rcu_read_unlock();
 
 	if (hskp == NULL)
-		rc = netlbl_req_setattr(req, &skp->smk_netlabel);
+		rc = netlbl_req_setattr(req, &ssp->smk_out->smk_netlabel);
 	else
 		netlbl_req_delattr(req);
 
-- 
2.43.0



