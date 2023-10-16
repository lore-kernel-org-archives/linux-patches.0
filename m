Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C5718E1F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvH053z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B227C433C7;
	Mon, 16 Oct 2023 08:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445817;
	bh=v/Nh62iBmrd8zh2kgvASVMT8Y9s1ToqGjDnCLIxDd/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvH053z4cjAEdOXeEYEdvNSJuYjy+DSwvyMcMT5galm5IyrNafItoXQjybvbCQx5o
	 EBNr3VJseQN5Ff1BQoTEUzjzzmfgX295ywnq5LatqkVq843H4XNoaKVdEwnGYdtjrE
	 UNZz3Ze3GsT6Yh/JYWrkjd3fvAOu/ufwn1VX8QrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sumit Garg <sumit.garg@linaro.org>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	David Gstir <david@sigma-star.at>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	Michael Walle <michael@walle.cc>,
	John Ernberg <john.ernberg@actia.se>
Subject: [PATCH 5.15 016/102] KEYS: trusted: allow use of kernel RNG for key material
Date: Mon, 16 Oct 2023 10:40:15 +0200
Message-ID: <20231016083954.121156438@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit fcd7c26901c83681532c6daac599e53d4df11738 ]

The two existing trusted key sources don't make use of the kernel RNG,
but instead let the hardware doing the sealing/unsealing also
generate the random key material. However, both users and future
backends may want to place less trust into the quality of the trust
source's random number generator and instead reuse the kernel entropy
pool, which can be seeded from multiple entropy sources.

Make this possible by adding a new trusted.rng parameter,
that will force use of the kernel RNG. In its absence, it's up
to the trust source to decide, which random numbers to use,
maintaining the existing behavior.

Suggested-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Sumit Garg <sumit.garg@linaro.org>
Acked-by: Pankaj Gupta <pankaj.gupta@nxp.com>
Reviewed-by: David Gstir <david@sigma-star.at>
Reviewed-by: Pankaj Gupta <pankaj.gupta@nxp.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Pankaj Gupta <pankaj.gupta@nxp.com>
Tested-by: Michael Walle <michael@walle.cc> # on ls1028a (non-E and E)
Tested-by: John Ernberg <john.ernberg@actia.se> # iMX8QXP
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Stable-dep-of: 01bbafc63b65 ("KEYS: trusted: Remove redundant static calls usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         | 10 ++++++
 .../security/keys/trusted-encrypted.rst       | 20 ++++++-----
 include/keys/trusted-type.h                   |  2 +-
 security/keys/trusted-keys/trusted_core.c     | 35 ++++++++++++++++++-
 4 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2cd4d66ab64c2..34b093e7f8910 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5920,6 +5920,16 @@
 			first trust source as a backend which is initialized
 			successfully during iteration.
 
+	trusted.rng=	[KEYS]
+			Format: <string>
+			The RNG used to generate key material for trusted keys.
+			Can be one of:
+			- "kernel"
+			- the same value as trusted.source: "tpm" or "tee"
+			- "default"
+			If not specified, "default" is used. In this case,
+			the RNG's choice is left to each individual trust source.
+
 	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
diff --git a/Documentation/security/keys/trusted-encrypted.rst b/Documentation/security/keys/trusted-encrypted.rst
index 80d5a5af62a1d..99cf34d7c025b 100644
--- a/Documentation/security/keys/trusted-encrypted.rst
+++ b/Documentation/security/keys/trusted-encrypted.rst
@@ -87,22 +87,26 @@ Key Generation
 Trusted Keys
 ------------
 
-New keys are created from random numbers generated in the trust source. They
-are encrypted/decrypted using a child key in the storage key hierarchy.
-Encryption and decryption of the child key must be protected by a strong
-access control policy within the trust source.
+New keys are created from random numbers. They are encrypted/decrypted using
+a child key in the storage key hierarchy. Encryption and decryption of the
+child key must be protected by a strong access control policy within the
+trust source. The random number generator in use differs according to the
+selected trust source:
 
-  *  TPM (hardware device) based RNG
+  *  TPM: hardware device based RNG
 
-     Strength of random numbers may vary from one device manufacturer to
-     another.
+     Keys are generated within the TPM. Strength of random numbers may vary
+     from one device manufacturer to another.
 
-  *  TEE (OP-TEE based on Arm TrustZone) based RNG
+  *  TEE: OP-TEE based on Arm TrustZone based RNG
 
      RNG is customizable as per platform needs. It can either be direct output
      from platform specific hardware RNG or a software based Fortuna CSPRNG
      which can be seeded via multiple entropy sources.
 
+Users may override this by specifying ``trusted.rng=kernel`` on the kernel
+command-line to override the used RNG with the kernel's random number pool.
+
 Encrypted Keys
 --------------
 
diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
index d89fa2579ac05..4eb64548a74f1 100644
--- a/include/keys/trusted-type.h
+++ b/include/keys/trusted-type.h
@@ -64,7 +64,7 @@ struct trusted_key_ops {
 	/* Unseal a key. */
 	int (*unseal)(struct trusted_key_payload *p, char *datablob);
 
-	/* Get a randomized key. */
+	/* Optional: Get a randomized key. */
 	int (*get_random)(unsigned char *key, size_t key_len);
 
 	/* Exit key interface. */
diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 9b9d3ef79cbe3..79806594384e3 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -16,12 +16,17 @@
 #include <linux/key-type.h>
 #include <linux/module.h>
 #include <linux/parser.h>
+#include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <linux/slab.h>
 #include <linux/static_call.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
 
+static char *trusted_rng = "default";
+module_param_named(rng, trusted_rng, charp, 0);
+MODULE_PARM_DESC(rng, "Select trusted key RNG");
+
 static char *trusted_key_source;
 module_param_named(source, trusted_key_source, charp, 0);
 MODULE_PARM_DESC(source, "Select trusted keys source (tpm or tee)");
@@ -312,8 +317,14 @@ struct key_type key_type_trusted = {
 };
 EXPORT_SYMBOL_GPL(key_type_trusted);
 
+static int kernel_get_random(unsigned char *key, size_t key_len)
+{
+	return get_random_bytes_wait(key, key_len) ?: key_len;
+}
+
 static int __init init_trusted(void)
 {
+	int (*get_random)(unsigned char *key, size_t key_len);
 	int i, ret = 0;
 
 	for (i = 0; i < ARRAY_SIZE(trusted_key_sources); i++) {
@@ -322,6 +333,28 @@ static int __init init_trusted(void)
 			    strlen(trusted_key_sources[i].name)))
 			continue;
 
+		/*
+		 * We always support trusted.rng="kernel" and "default" as
+		 * well as trusted.rng=$trusted.source if the trust source
+		 * defines its own get_random callback.
+		 */
+		get_random = trusted_key_sources[i].ops->get_random;
+		if (trusted_rng && strcmp(trusted_rng, "default")) {
+			if (!strcmp(trusted_rng, "kernel")) {
+				get_random = kernel_get_random;
+			} else if (strcmp(trusted_rng, trusted_key_sources[i].name) ||
+				   !get_random) {
+				pr_warn("Unsupported RNG. Supported: kernel");
+				if (get_random)
+					pr_cont(", %s", trusted_key_sources[i].name);
+				pr_cont(", default\n");
+				return -EINVAL;
+			}
+		}
+
+		if (!get_random)
+			get_random = kernel_get_random;
+
 		static_call_update(trusted_key_init,
 				   trusted_key_sources[i].ops->init);
 		static_call_update(trusted_key_seal,
@@ -329,7 +362,7 @@ static int __init init_trusted(void)
 		static_call_update(trusted_key_unseal,
 				   trusted_key_sources[i].ops->unseal);
 		static_call_update(trusted_key_get_random,
-				   trusted_key_sources[i].ops->get_random);
+				   get_random);
 		static_call_update(trusted_key_exit,
 				   trusted_key_sources[i].ops->exit);
 		migratable = trusted_key_sources[i].ops->migratable;
-- 
2.40.1



