Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AC93398C
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VALHYzvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23510C433C9;
	Mon,  9 Oct 2023 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858490;
	bh=ThS54CLWG+zL18PFo1o98wN9nKs43M8/IlHyVeNlRbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VALHYzvmxZZSXTWe6EOVuvC+MR+bAHCSRvFBJpiSs3kH4QGZNeI/OKDaa6MJ21iMP
	 PHqOF8IZsNyD+m1PiMiKAILT0vi05ric0yLWOQNVW8uE+TT2DF3d0O4RGA2YT3Iavc
	 ivxeeW8r9rmWS8OoI5upJxHhDV7Qda9zjp3g3l28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.4 131/131] ima: rework CONFIG_IMA dependency block
Date: Mon,  9 Oct 2023 15:02:51 +0200
Message-ID: <20231009130120.426634053@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 91e326563ee34509c35267808a4b1b3ea3db62a8 upstream.

Changing the direct dependencies of IMA_BLACKLIST_KEYRING and
IMA_LOAD_X509 caused them to no longer depend on IMA, but a
a configuration without IMA results in link failures:

arm-linux-gnueabi-ld: security/integrity/iint.o: in function `integrity_load_keys':
iint.c:(.init.text+0xd8): undefined reference to `ima_load_x509'

aarch64-linux-ld: security/integrity/digsig_asymmetric.o: in function `asymmetric_verify':
digsig_asymmetric.c:(.text+0x104): undefined reference to `ima_blacklist_keyring'

Adding explicit dependencies on IMA would fix this, but a more reliable
way to do this is to enclose the entire Kconfig file in an 'if IMA' block.
This also allows removing the existing direct dependencies.

Fixes: be210c6d3597f ("ima: Finish deprecation of IMA_TRUSTED_KEYRING Kconfig")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/Kconfig |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -29,9 +29,11 @@ config IMA
 	  to learn more about IMA.
 	  If unsure, say N.
 
+if IMA
+
 config IMA_KEXEC
 	bool "Enable carrying the IMA measurement list across a soft boot"
-	depends on IMA && TCG_TPM && HAVE_IMA_KEXEC
+	depends on TCG_TPM && HAVE_IMA_KEXEC
 	default n
 	help
 	   TPM PCRs are only reset on a hard reboot.  In order to validate
@@ -43,7 +45,6 @@ config IMA_KEXEC
 
 config IMA_MEASURE_PCR_IDX
 	int
-	depends on IMA
 	range 8 14
 	default 10
 	help
@@ -53,7 +54,7 @@ config IMA_MEASURE_PCR_IDX
 
 config IMA_LSM_RULES
 	bool
-	depends on IMA && AUDIT && (SECURITY_SELINUX || SECURITY_SMACK)
+	depends on AUDIT && (SECURITY_SELINUX || SECURITY_SMACK)
 	default y
 	help
 	  Disabling this option will disregard LSM based policy rules.
@@ -61,7 +62,6 @@ config IMA_LSM_RULES
 choice
 	prompt "Default template"
 	default IMA_NG_TEMPLATE
-	depends on IMA
 	help
 	  Select the default IMA measurement template.
 
@@ -80,14 +80,12 @@ endchoice
 
 config IMA_DEFAULT_TEMPLATE
 	string
-	depends on IMA
 	default "ima-ng" if IMA_NG_TEMPLATE
 	default "ima-sig" if IMA_SIG_TEMPLATE
 
 choice
 	prompt "Default integrity hash algorithm"
 	default IMA_DEFAULT_HASH_SHA1
-	depends on IMA
 	help
 	   Select the default hash algorithm used for the measurement
 	   list, integrity appraisal and audit log.  The compiled default
@@ -113,7 +111,6 @@ endchoice
 
 config IMA_DEFAULT_HASH
 	string
-	depends on IMA
 	default "sha1" if IMA_DEFAULT_HASH_SHA1
 	default "sha256" if IMA_DEFAULT_HASH_SHA256
 	default "sha512" if IMA_DEFAULT_HASH_SHA512
@@ -121,7 +118,6 @@ config IMA_DEFAULT_HASH
 
 config IMA_WRITE_POLICY
 	bool "Enable multiple writes to the IMA policy"
-	depends on IMA
 	default n
 	help
 	  IMA policy can now be updated multiple times.  The new rules get
@@ -132,7 +128,6 @@ config IMA_WRITE_POLICY
 
 config IMA_READ_POLICY
 	bool "Enable reading back the current IMA policy"
-	depends on IMA
 	default y if IMA_WRITE_POLICY
 	default n if !IMA_WRITE_POLICY
 	help
@@ -142,7 +137,6 @@ config IMA_READ_POLICY
 
 config IMA_APPRAISE
 	bool "Appraise integrity measurements"
-	depends on IMA
 	default n
 	help
 	  This option enables local measurement integrity appraisal.
@@ -295,3 +289,5 @@ config IMA_APPRAISE_SIGNED_INIT
 	default n
 	help
 	   This option requires user-space init to be signed.
+
+endif


