Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E8A1DEFE3;
	Wed, 19 Mar 2025 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394992; cv=none; b=qkMdwSRzarvTCx8YwHnGfOYsv8Nr8aG8n0LdRxkuBEEP4aTZS83wVXedHLPi+s8yaTiHqPzrMabSNHb0JGH/sTQb+2QloE7Ro51eYFHhxawEdnUgxDdA7h+aruI2ZwPQ0EovuZfVHvKnBYj/iy8MCcRiDwdJXwmoAlz+Z+rvV4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394992; c=relaxed/simple;
	bh=RuC2V2ZdQlpwZYog6bkk/lNv8Z1qPU1toIMFAFRn+aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DILli9L6G98UWztHFsk2Q2nUFV9/wfY202tIbIgTZsUFOCShc0CrObhhLE6K/W513Cf5ZifXhkl73qtbLz4NjgdOx3GYFSoL5OhJwY/WcDU/TMCG9heErUOrKxoZgwIiqfHd1ktGnrMGzWpUg4kCLscuECLeiYchdmAMmM3Mueo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFwUOGNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFwUOGNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1390C4CEE4;
	Wed, 19 Mar 2025 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394991;
	bh=RuC2V2ZdQlpwZYog6bkk/lNv8Z1qPU1toIMFAFRn+aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFwUOGNiqw7cAhe01/AwJK9ue/+zouNeoSdewhOCObW74vyD9vY47nfowV8ABPVZh
	 RZ3EcXGKNkQYr8O9nP1SX0pIfyMslBZ7VkMj76OCRO5vBqmJLRsor5h0qPp52ti/T9
	 CGGfYHaDZaq4AQUEpVOtEY51Xgzo0fPTZ7Dt07O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 233/241] smb3: add support for IAKerb
Date: Wed, 19 Mar 2025 07:31:43 -0700
Message-ID: <20250319143033.507814051@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 28f568b5fc277..bc1c1e9b288ad 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -138,11 +138,13 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 
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
index 37b7d84e26913..774d47318b0d3 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -151,6 +151,7 @@ enum securityEnum {
 	NTLMv2,			/* Legacy NTLM auth with NTLMv2 hash */
 	RawNTLMSSP,		/* NTLMSSP without SPNEGO, NTLMv2 hash */
 	Kerberos,		/* Kerberos via SPNEGO */
+	IAKerb,			/* Kerberos proxy */
 };
 
 enum upcall_target_enum {
@@ -749,6 +750,7 @@ struct TCP_Server_Info {
 	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
+	bool	sec_iakerb;		/* supports pass-through auth for Kerberos (krb5 proxy) */
 	bool	large_buf;		/* is current buffer large? */
 	/* use SMBD connection instead of socket */
 	bool	rdma;
@@ -2122,6 +2124,8 @@ static inline char *get_security_type_str(enum securityEnum sectype)
 		return "Kerberos";
 	case NTLMv2:
 		return "NTLMv2";
+	case IAKerb:
+		return "IAKerb";
 	default:
 		return "Unknown";
 	}
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 91d4d409cb1dc..faa80e7d54a6e 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -1235,12 +1235,13 @@ cifs_select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
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
index f1f55fbd0eeab..7ece98c742bdb 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1429,7 +1429,7 @@ smb2_select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
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



