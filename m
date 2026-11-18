Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033246;
	b=jnm5zr6/5qp5ESocszW2t5hS23EEt4lPw0roz0F8HBA3Vn2hMlC7RdrLtowyDa9S90Lo
	 1bbEbQtvnWglwgt/IhVZgOKagoztFuCjjSkrNc8Fl6/p78dPhNJOhIaZbV4pvm2IjU5u6
	 pPt7yPXd8JTljblwJItutPU2D1S+6ewLWxHu8niYZDiVC5QQV4E8riP4/ZGaS3itQ0PpM
	 ktPgFecLiX12YWWBH1LOSOd77108dKOGpReIrDmJnaG0jHDEV22jK4ARNR/mmXjeO5zQr
	 7cokrr0xJsiCq05iykfGM7A4LDImXo4siCJ+2f0QPPkt4U4g1SxijW11bYWSobsEnBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+6HpvKm/zfXA8WkVKnjFJ4pnEEq+07h3soeW8+RraEs=;
	b=OLs70h2U42uqQIuee9mCA/4KcdS+Ue5Zn6X80ThZCPmpikl5VJDHnH1FCMp50aE0gH23
	 4E6A+pgjhzwFwtwgdp6ECmvMzbhlwCBuWrvgh8T9tVMRWiGRptSu16+e+n48yBERIgQmS
	 oCXrZ1N5LnUnnDkECDV7i3e0CRYLcHrcobDOx3dVf+R/S/z8+WESqyBhQoTAJi34Kr/3W
	 lVg3fz4cNz54yAB6UPbdR9B3c8GPRfHXgdzF0ezr+FRMbxdH0paJrMa17cHdNHxwy410h
	 iLcxYbeVyvkhCnCgdpWRaXFfCmDiNVDHP1KHt81xMuJ4gqUkbs34YIhV4d5Vc8lsokg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TdcW7/HR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D8C606A334;
	Wed, 18 Nov 2026 20:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TdcW7/HR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50DA1F000C4;
	Wed, 18 Nov 2026 20:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033246;
	bh=+6HpvKm/zfXA8WkVKnjFJ4pnEEq+07h3soeW8+RraEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdcW7/HRfYFhommraOkPY3EnrxMeGCC/TY1V8amTU/SAP1X3aieEc3bK31cH1awah
	 I5US1IHtNGzLqgV8xR32Z2da+zACNCrFNXyxOMkld8/p0xJb68YH7L1ax5UVLB7NLN
	 Ga7j9intGarXhZzbKHw1oFGety/GN056Sy/EUygc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1701/1756] apparmor: fix check SCTP bind, and connect permission checks
Date: Wed, 18 Nov 2026 16:03:48 +0100
Message-ID: <20261118150117.364175334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 7a82f9a06459ff1c37b5e97b204430442cc076e3 ]

SCTP mediation of bind is not being checked correctly because bind
permission needs to be checked in the sctp_bind_connect() hook.

Require for bind permissions when CTP_SET_PEER_PRIMARY_ADDR, and
SCTP_SOCKOPT_BINDX_ADD are asked for.

The peer initialized ASCONF cases (SCTP_PARAM_ADD_IP and
SCTP_PARAM_SET_PRIMARY) are processed in softirq context and are not
mediated atm. SCTP_PRIMATEY_ADDR, and SCTP_SET_PEER_PRIMARY_ADDR only
select among address already in the association.

Fixes: 56974a6fcfef ("apparmor: add base infastructure for socket mediation")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 47d772d36627e..b9dd558e55e3a 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1169,6 +1169,11 @@ static int apparmor_sctp_bind_connect(struct sock *sk, int optname,
 				      struct sockaddr *address, int addrlen)
 {
 	switch (optname) {
+	/* Bind checks */
+	case SCTP_SET_PEER_PRIMARY_ADDR:
+	case SCTP_SOCKOPT_BINDX_ADD:
+		return aa_sk_perm(OP_BIND, AA_MAY_BIND, sk);
+	/* Connect checks */
 	case SCTP_SOCKOPT_CONNECTX:
 	case SCTP_SENDMSG_CONNECT:
 		return aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sk);
-- 
2.53.0



