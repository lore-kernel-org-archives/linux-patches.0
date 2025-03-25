Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AA22676FD;
	Tue, 25 Mar 2025 12:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905802; cv=none; b=WS6i1tt8cawQpYx310RGRxO93WsyN/FVvCEOqF3HEHIdp84YweeyJUDPqSTtN4+20Badkt+y06kIEib2oXEWwjbfYqXVuIEI41Th5ypwrxo349Y6lkh3hDlbRF4OOYflXyXm7MoDmCeshVBIm+C5vwJ+ut9AHmS6EKwmovIDsO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905802; c=relaxed/simple;
	bh=yXc16SzuI7M9rfs0dyjfup4Cgt+Xc17Xyo6xJrp9j1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZCwi1dkXrf+fa2hnyZH1ct8/eMzSkYrGYA43fTp+gM/YkxkuXkKHwin3l4GaUt9oJdb7jXrha3QEW6MFs55bdPWyodiLRqn4MMT3F44W8T68XriNnVpbnG7hR3Trmcqg5HjN0xGmt2CLTFL0us7jRpgBI8dlOTDGBL5fiJMB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfErlbvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfErlbvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9AEC4CEE9;
	Tue, 25 Mar 2025 12:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905802;
	bh=yXc16SzuI7M9rfs0dyjfup4Cgt+Xc17Xyo6xJrp9j1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfErlbvgwAqhMorWdREVgDbettDjv46S7l123k6T1WMseIzhepCwX6EPyFd6xueJW
	 eXHFCOsCzHgVKUjjHBXrURIdYq7MRYG06W4lydRqXx3+N2aueFiCg0p7UQRH0/dFhD
	 gZi831hlWxGBO0bnsAritThOOxcaldhMkGVPYX44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/198] smb3: add support for IAKerb
Date: Tue, 25 Mar 2025 08:21:43 -0400
Message-ID: <20250325122200.355814721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit eea5119fa5979c350af5783a8148eacdd4219715 ]

There are now more servers which advertise support for IAKerb (passthrough
Kerberos authentication via proxy).  IAKerb is a public extension industry
standard Kerberos protocol that allows a client without line-of-sight
to a Domain Controller to authenticate. There can be cases where we
would fail to mount if the server only advertises the OID for IAKerb
in SPNEGO/GSSAPI.  Add code to allow us to still upcall to userspace
in these cases to obtain the Kerberos ticket.

Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 605b249ea967 ("smb: client: Fix match_session bug preventing session reuse")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/asn1.c        | 2 ++
 fs/smb/client/cifs_spnego.c | 4 +++-
 fs/smb/client/cifsglob.h    | 4 ++++
 fs/smb/client/sess.c        | 3 ++-
 fs/smb/client/smb2pdu.c     | 2 +-
 5 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/asn1.c b/fs/smb/client/asn1.c
index b5724ef9f182f..214a44509e7b9 100644
--- a/fs/smb/client/asn1.c
+++ b/fs/smb/client/asn1.c
@@ -52,6 +52,8 @@ int cifs_neg_token_init_mech_type(void *context, size_t hdrlen,
 		server->sec_kerberos = true;
 	else if (oid == OID_ntlmssp)
 		server->sec_ntlmssp = true;
+	else if (oid == OID_IAKerb)
+		server->sec_iakerb = true;
 	else {
 		char buf[50];
 
diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index 1e6819daaaa7e..8b58f494235ff 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -130,11 +130,13 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 
 	dp = description + strlen(description);
 
-	/* for now, only sec=krb5 and sec=mskrb5 are valid */
+	/* for now, only sec=krb5 and sec=mskrb5 and iakerb are valid */
 	if (server->sec_kerberos)
 		sprintf(dp, ";sec=krb5");
 	else if (server->sec_mskerberos)
 		sprintf(dp, ";sec=mskrb5");
+	else if (server->sec_iakerb)
+		sprintf(dp, ";sec=iakerb");
 	else {
 		cifs_dbg(VFS, "unknown or missing server auth type, use krb5\n");
 		sprintf(dp, ";sec=krb5");
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 71e519bf65e26..17fce0afb297f 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -148,6 +148,7 @@ enum securityEnum {
 	NTLMv2,			/* Legacy NTLM auth with NTLMv2 hash */
 	RawNTLMSSP,		/* NTLMSSP without SPNEGO, NTLMv2 hash */
 	Kerberos,		/* Kerberos via SPNEGO */
+	IAKerb,			/* Kerberos proxy */
 };
 
 struct session_key {
@@ -685,6 +686,7 @@ struct TCP_Server_Info {
 	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
+	bool	sec_iakerb;		/* supports pass-through auth for Kerberos (krb5 proxy) */
 	bool	large_buf;		/* is current buffer large? */
 	/* use SMBD connection instead of socket */
 	bool	rdma;
@@ -2049,6 +2051,8 @@ static inline char *get_security_type_str(enum securityEnum sectype)
 		return "Kerberos";
 	case NTLMv2:
 		return "NTLMv2";
+	case IAKerb:
+		return "IAKerb";
 	default:
 		return "Unknown";
 	}
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index b8e14bcd2c68d..c8f7ae0a20064 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -1209,12 +1209,13 @@ cifs_select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
 		switch (requested) {
 		case Kerberos:
 		case RawNTLMSSP:
+		case IAKerb:
 			return requested;
 		case Unspecified:
 			if (server->sec_ntlmssp &&
 			    (global_secflags & CIFSSEC_MAY_NTLMSSP))
 				return RawNTLMSSP;
-			if ((server->sec_kerberos || server->sec_mskerberos) &&
+			if ((server->sec_kerberos || server->sec_mskerberos || server->sec_iakerb) &&
 			    (global_secflags & CIFSSEC_MAY_KRB5))
 				return Kerberos;
 			fallthrough;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 0ae931e023cee..96faa22b9cb6a 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1270,7 +1270,7 @@ smb2_select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
 		if (server->sec_ntlmssp &&
 			(global_secflags & CIFSSEC_MAY_NTLMSSP))
 			return RawNTLMSSP;
-		if ((server->sec_kerberos || server->sec_mskerberos) &&
+		if ((server->sec_kerberos || server->sec_mskerberos || server->sec_iakerb) &&
 			(global_secflags & CIFSSEC_MAY_KRB5))
 			return Kerberos;
 		fallthrough;
-- 
2.39.5



