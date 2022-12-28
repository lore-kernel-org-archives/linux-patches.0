Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A21C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14532C433D2;
	Wed, 28 Dec 2022 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245409;
	bh=5p6TI3kPoDHFbjPnSlmWdnvOS3eVSq8WPBH3ZjkpxTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMWkLtQswW25Jn4DouSD9Y0qwGZR7JGD5d8DCx3L7VCB/hrnpUPVVccFHE9If7jaT
	 gwI9anGP/ZJObRivjFkgwjzluDrp4Dt1BIbaJSe9QIm4xnCxOXg0wQ3aDfXykEd1MP
	 Le2j45j/A4KpVxjal9Ny8bnJkX/Ah23R+7Wy8CHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0854/1146] powerpc/pseries: fix plpks_read_var() code for different consumers
Date: Wed, 28 Dec 2022 15:39:53 +0100
Message-Id: <20221228144353.351974528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit 1f622f3f80cbf8999ff5955a2fcfbd801a1f32e0 ]

Even though plpks_read_var() is currently called to read variables
owned by different consumers, it internally supports only OS consumer.

Fix plpks_read_var() to handle different consumers correctly.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221106205839.600442-7-nayna@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 28 +++++++++++++++++---------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index cbea447122ca..63a1e1fe0185 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -366,22 +366,24 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE] = { 0 };
 	struct plpks_auth *auth;
-	struct label *label;
+	struct label *label = NULL;
 	u8 *output;
 	int rc;
 
 	if (var->namelen > MAX_NAME_SIZE)
 		return -EINVAL;
 
-	auth = construct_auth(PKS_OS_OWNER);
+	auth = construct_auth(consumer);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
-	label = construct_label(var->component, var->os, var->name,
-				var->namelen);
-	if (IS_ERR(label)) {
-		rc = PTR_ERR(label);
-		goto out_free_auth;
+	if (consumer == PKS_OS_OWNER) {
+		label = construct_label(var->component, var->os, var->name,
+					var->namelen);
+		if (IS_ERR(label)) {
+			rc = PTR_ERR(label);
+			goto out_free_auth;
+		}
 	}
 
 	output = kzalloc(maxobjsize, GFP_KERNEL);
@@ -390,9 +392,15 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 		goto out_free_label;
 	}
 
-	rc = plpar_hcall(H_PKS_READ_OBJECT, retbuf, virt_to_phys(auth),
-			 virt_to_phys(label), label->size, virt_to_phys(output),
-			 maxobjsize);
+	if (consumer == PKS_OS_OWNER)
+		rc = plpar_hcall(H_PKS_READ_OBJECT, retbuf, virt_to_phys(auth),
+				 virt_to_phys(label), label->size, virt_to_phys(output),
+				 maxobjsize);
+	else
+		rc = plpar_hcall(H_PKS_READ_OBJECT, retbuf, virt_to_phys(auth),
+				 virt_to_phys(var->name), var->namelen, virt_to_phys(output),
+				 maxobjsize);
+
 
 	if (rc != H_SUCCESS) {
 		pr_err("Failed to read variable %s for component %s with error %d\n",
-- 
2.35.1



