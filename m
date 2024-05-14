Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CFE6E5ED;
	Tue, 14 May 2024 11:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686381; cv=none; b=mv374IOstqcXBBQrjJ360bXyi3XhGfZs7vM83RZZ2l300qfJ/Dl5w5jxYyO0B0i2/RPEKB5wPLMEc38T7FzFgerpORdv9AqqZTygcR52OtQJOGjX03xOzfgJXlzifAQbPCZphwAkk+D9hFE7AQkCDp1xzoUqGW6E48BKGfqUDMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686381; c=relaxed/simple;
	bh=zXp5ripADO5ysTk3ZCIgddCxbvIoh+X6Y0oRFDltAe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cg+KvNnVQEcD0XDHdak8LtscDcwlwdC0/3elJkvBCE4+LV+xUh5rgDu07OxOMGMMWM6tYAazyoM9Xwv5lUoCTq8p4d6rfv8Ycc2bvxXp8qLgN9r30hSyS6tICL6DPIOLHEblajZNWLskKKLg0O3Sk5upaoYBCUzlNsFghAhU874=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQHUdWTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQHUdWTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA2EC2BD10;
	Tue, 14 May 2024 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686381;
	bh=zXp5ripADO5ysTk3ZCIgddCxbvIoh+X6Y0oRFDltAe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQHUdWTA5wwhWfPCg1J/Rzz5FQD+Fj3fRD/t41gBYTcKqgR6CSQc//FtqJTkDYx7v
	 J7QcGk05pw/nYme0HaLInVUhlWv+2L5bVaHkVeagONSHa3Th6ynYzvXGPSfNZdS1Ko
	 jLHImGjuOECK+jGwx6BGzDvxRNr1MHE7d0kgHM+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Russell Currey <ruscur@russell.cc>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/236] powerpc/pseries: Implement signed update for PLPKS objects
Date: Tue, 14 May 2024 12:17:30 +0200
Message-ID: <20240514101023.710898376@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit 899d9b8fee66da820eadc60b2a70090eb83db761 ]

The Platform Keystore provides a signed update interface which can be used
to create, replace or append to certain variables in the PKS in a secure
fashion, with the hypervisor requiring that the update be signed using the
Platform Key.

Implement an interface to the H_PKS_SIGNED_UPDATE hcall in the plpks
driver to allow signed updates to PKS objects.

(The plpks driver doesn't need to do any cryptography or otherwise handle
the actual signed variable contents - that will be handled by userspace
tooling.)

Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
[ajd: split patch, add timeout handling and misc cleanups]
Co-developed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230210080401.345462-18-ajd@linux.ibm.com
Stable-dep-of: 784354349d2c ("powerpc/pseries: make max polling consistent for longer H_CALLs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hvcall.h      |  1 +
 arch/powerpc/platforms/pseries/plpks.c | 74 ++++++++++++++++++++++++--
 arch/powerpc/platforms/pseries/plpks.h |  5 ++
 3 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 95fd7f9485d55..c099780385dd3 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -335,6 +335,7 @@
 #define H_RPT_INVALIDATE	0x448
 #define H_SCM_FLUSH		0x44C
 #define H_GET_ENERGY_SCALE_INFO	0x450
+#define H_PKS_SIGNED_UPDATE	0x454
 #define H_WATCHDOG		0x45C
 #define MAX_HCALL_OPCODE	H_WATCHDOG
 
diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 06b52fe12c88b..3efbfd25d35d0 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -74,6 +74,12 @@ static int pseries_status_to_err(int rc)
 		err = -ENOENT;
 		break;
 	case H_BUSY:
+	case H_LONG_BUSY_ORDER_1_MSEC:
+	case H_LONG_BUSY_ORDER_10_MSEC:
+	case H_LONG_BUSY_ORDER_100_MSEC:
+	case H_LONG_BUSY_ORDER_1_SEC:
+	case H_LONG_BUSY_ORDER_10_SEC:
+	case H_LONG_BUSY_ORDER_100_SEC:
 		err = -EBUSY;
 		break;
 	case H_AUTHORITY:
@@ -174,14 +180,17 @@ static struct label *construct_label(char *component, u8 varos, u8 *name,
 				     u16 namelen)
 {
 	struct label *label;
-	size_t slen;
+	size_t slen = 0;
 
 	if (!name || namelen > PLPKS_MAX_NAME_SIZE)
 		return ERR_PTR(-EINVAL);
 
-	slen = strlen(component);
-	if (component && slen > sizeof(label->attr.prefix))
-		return ERR_PTR(-EINVAL);
+	// Support NULL component for signed updates
+	if (component) {
+		slen = strlen(component);
+		if (slen > sizeof(label->attr.prefix))
+			return ERR_PTR(-EINVAL);
+	}
 
 	label = kzalloc(sizeof(*label), GFP_KERNEL);
 	if (!label)
@@ -264,6 +273,61 @@ static int plpks_confirm_object_flushed(struct label *label,
 	return rc;
 }
 
+int plpks_signed_update_var(struct plpks_var *var, u64 flags)
+{
+	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE] = {0};
+	int rc;
+	struct label *label;
+	struct plpks_auth *auth;
+	u64 continuetoken = 0;
+	u64 timeout = 0;
+
+	if (!var->data || var->datalen <= 0 || var->namelen > PLPKS_MAX_NAME_SIZE)
+		return -EINVAL;
+
+	if (!(var->policy & PLPKS_SIGNEDUPDATE))
+		return -EINVAL;
+
+	// Signed updates need the component to be NULL.
+	if (var->component)
+		return -EINVAL;
+
+	auth = construct_auth(PLPKS_OS_OWNER);
+	if (IS_ERR(auth))
+		return PTR_ERR(auth);
+
+	label = construct_label(var->component, var->os, var->name, var->namelen);
+	if (IS_ERR(label)) {
+		rc = PTR_ERR(label);
+		goto out;
+	}
+
+	do {
+		rc = plpar_hcall9(H_PKS_SIGNED_UPDATE, retbuf,
+				  virt_to_phys(auth), virt_to_phys(label),
+				  label->size, var->policy, flags,
+				  virt_to_phys(var->data), var->datalen,
+				  continuetoken);
+
+		continuetoken = retbuf[0];
+		if (pseries_status_to_err(rc) == -EBUSY) {
+			int delay_ms = get_longbusy_msecs(rc);
+			mdelay(delay_ms);
+			timeout += delay_ms;
+		}
+		rc = pseries_status_to_err(rc);
+	} while (rc == -EBUSY && timeout < PLPKS_MAX_TIMEOUT);
+
+	if (!rc)
+		rc = plpks_confirm_object_flushed(label, auth);
+
+	kfree(label);
+out:
+	kfree(auth);
+
+	return rc;
+}
+
 int plpks_write_var(struct plpks_var var)
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE] = { 0 };
@@ -314,7 +378,7 @@ int plpks_remove_var(char *component, u8 varos, struct plpks_var_name vname)
 	struct label *label;
 	int rc;
 
-	if (!component || vname.namelen > PLPKS_MAX_NAME_SIZE)
+	if (vname.namelen > PLPKS_MAX_NAME_SIZE)
 		return -EINVAL;
 
 	auth = construct_auth(PLPKS_OS_OWNER);
diff --git a/arch/powerpc/platforms/pseries/plpks.h b/arch/powerpc/platforms/pseries/plpks.h
index 6afb44ee74a16..ccbec26fcbd8b 100644
--- a/arch/powerpc/platforms/pseries/plpks.h
+++ b/arch/powerpc/platforms/pseries/plpks.h
@@ -66,6 +66,11 @@ struct plpks_var_name_list {
 	struct plpks_var_name varlist[];
 };
 
+/**
+ * Updates the authenticated variable. It expects NULL as the component.
+ */
+int plpks_signed_update_var(struct plpks_var *var, u64 flags);
+
 /**
  * Writes the specified var and its data to PKS.
  * Any caller of PKS driver should present a valid component type for
-- 
2.43.0



