Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864C01DDCE;
	Tue, 16 Jul 2024 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145693; cv=none; b=Se/PaO0VAYjIXZzAfdo03k+KFvd3zNNFNOw6VGjzKrs68Af22YhYit5jbbAWanESn/9TEUcoy4I9NLyNaO9udIMjoPPCLSHnreaIzfbrGJ6Tq3FPETBm0p/y5elU6CaLb+lljuzRgQ5arkko0faGgjpvtujKCcnbJqECxWywojw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145693; c=relaxed/simple;
	bh=VgPxu01POcFVJqisWnpZZYIHxDDyCiz4WaU735IM8ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmkk97DAKrQe4XYnkUFFQKrqzYh8jC+md4eLkJR3CXb8+PKnHmlbYU8YWhu+vt6m40J0WJQ9pZ8eN+RH4mcNE87xgkMzbKH383TVBOBDmyTivWsRLay/MfNYPbG6XyXLHGG2Xlnr3BIGhS1UC1hs1+tzsxj2b/DJKMHSRY84kwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GF2VaKoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GF2VaKoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2ECC4AF0D;
	Tue, 16 Jul 2024 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145693;
	bh=VgPxu01POcFVJqisWnpZZYIHxDDyCiz4WaU735IM8ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GF2VaKoKwW14hInFvYd0l1nfntuS5IEdU6P0x/Zl41gA8dLo4IcR6xNPBZ80BcojZ
	 ltSoVqOG1KvlFECxiuHTRb0SWL58u9OD+40PXJ80DVUjuM3+vqeFNKch4G/2KIeeqn
	 Z2C56YF5GO7kQjv3Ty8rdJkDiNu30zISp6nQlyhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 051/121] cifs: fix setting SecurityFlags to true
Date: Tue, 16 Jul 2024 17:31:53 +0200
Message-ID: <20240716152753.286883957@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit d2346e2836318a227057ed41061114cbebee5d2a upstream.

If you try to set /proc/fs/cifs/SecurityFlags to 1 it
will set them to CIFSSEC_MUST_NTLMV2 which no longer is
relevant (the less secure ones like lanman have been removed
from cifs.ko) and is also missing some flags (like for
signing and encryption) and can even cause mount to fail,
so change this to set it to Kerberos in this case.

Also change the description of the SecurityFlags to remove mention
of flags which are no longer supported.

Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/cifs/usage.rst |   34 +++++++++----------------------
 fs/smb/client/cifsglob.h                 |    4 +--
 2 files changed, 12 insertions(+), 26 deletions(-)

--- a/Documentation/admin-guide/cifs/usage.rst
+++ b/Documentation/admin-guide/cifs/usage.rst
@@ -722,40 +722,26 @@ Configuration pseudo-files:
 ======================= =======================================================
 SecurityFlags		Flags which control security negotiation and
 			also packet signing. Authentication (may/must)
-			flags (e.g. for NTLM and/or NTLMv2) may be combined with
+			flags (e.g. for NTLMv2) may be combined with
 			the signing flags.  Specifying two different password
 			hashing mechanisms (as "must use") on the other hand
 			does not make much sense. Default flags are::
 
-				0x07007
+				0x00C5
 
-			(NTLM, NTLMv2 and packet signing allowed).  The maximum
-			allowable flags if you want to allow mounts to servers
-			using weaker password hashes is 0x37037 (lanman,
-			plaintext, ntlm, ntlmv2, signing allowed).  Some
-			SecurityFlags require the corresponding menuconfig
-			options to be enabled.  Enabling plaintext
-			authentication currently requires also enabling
-			lanman authentication in the security flags
-			because the cifs module only supports sending
-			laintext passwords using the older lanman dialect
-			form of the session setup SMB.  (e.g. for authentication
-			using plain text passwords, set the SecurityFlags
-			to 0x30030)::
+			(NTLMv2 and packet signing allowed).  Some SecurityFlags
+			may require enabling a corresponding menuconfig option.
 
 			  may use packet signing			0x00001
 			  must use packet signing			0x01001
-			  may use NTLM (most common password hash)	0x00002
-			  must use NTLM					0x02002
 			  may use NTLMv2				0x00004
 			  must use NTLMv2				0x04004
-			  may use Kerberos security			0x00008
-			  must use Kerberos				0x08008
-			  may use lanman (weak) password hash		0x00010
-			  must use lanman password hash			0x10010
-			  may use plaintext passwords			0x00020
-			  must use plaintext passwords			0x20020
-			  (reserved for future packet encryption)	0x00040
+			  may use Kerberos security (krb5)		0x00008
+			  must use Kerberos                             0x08008
+			  may use NTLMSSP               		0x00080
+			  must use NTLMSSP           			0x80080
+			  seal (packet encryption)			0x00040
+			  must seal (not implemented yet)               0x40040
 
 cifsFYI			If set to non-zero value, additional debug information
 			will be logged to the system error log.  This field
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1939,8 +1939,8 @@ require use of the stronger protocol */
 #define   CIFSSEC_MUST_SEAL	0x40040 /* not supported yet */
 #define   CIFSSEC_MUST_NTLMSSP	0x80080 /* raw ntlmssp with ntlmv2 */
 
-#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_NTLMSSP)
-#define   CIFSSEC_MAX (CIFSSEC_MUST_NTLMV2)
+#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_NTLMSSP | CIFSSEC_MAY_SEAL)
+#define   CIFSSEC_MAX (CIFSSEC_MAY_SIGN | CIFSSEC_MUST_KRB5 | CIFSSEC_MAY_SEAL)
 #define   CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_NTLMSSP)
 /*
  *****************************************************************


