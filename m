Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5A915CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB8FC433C1;
	Tue,  8 Nov 2022 14:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916901;
	bh=leuPe9aFUj/SccplIZkv6Wrej5gGNsu6dL8gPWXtf1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IODPJlMRxsMElayTaoszlQNtYJf/o/EtJfYj50zX0MW1WR6qQxDHaQjaMz1+Wx13G
	 RJ5xRotW2ySSXc9HtuEgVwxxN/ktfz/adRvqMZ9kVjhQHYG0XUiVdjRmb8uJDwW6QV
	 n2TfD+IuMyXbxCJeyvl3M3IY3nrkfxDhzklXSIMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Aditya Garg <gargaditya08@live.com>
Subject: [PATCH 6.0 152/197] efi: efivars: Fix variable writes with unsupported query_variable_store()
Date: Tue,  8 Nov 2022 14:39:50 +0100
Message-Id: <20221108133401.876722341@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

commit f11a74b45d330ad1ab986852b099747161052526 upstream.

Commit 8a254d90a775 ("efi: efivars: Fix variable writes without
query_variable_store()") addressed an issue that was introduced during
the EFI variable store refactor, where alternative implementations of
the efivars layer that lacked query_variable_store() would no longer
work.

Unfortunately, there is another case to consider here, which was missed:
if the efivars layer is backed by the EFI runtime services as usual, but
the EFI implementation predates the introduction of QueryVariableInfo(),
we will return EFI_UNSUPPORTED, and this is no longer being dealt with
correctly.

So let's fix this, and while at it, clean up the code a bit, by merging
the check_var_size() routines as well as their callers.

Cc: <stable@vger.kernel.org> # v6.0
Fixes: bbc6d2c6ef22 ("efi: vars: Switch to new wrapper layer")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/vars.c | 68 +++++++++++--------------------------
 1 file changed, 20 insertions(+), 48 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 433b61587139..0ba9f18312f5 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -21,29 +21,22 @@ static struct efivars *__efivars;
 
 static DEFINE_SEMAPHORE(efivars_lock);
 
-static efi_status_t check_var_size(u32 attributes, unsigned long size)
-{
-	const struct efivar_operations *fops;
-
-	fops = __efivars->ops;
-
-	if (!fops->query_variable_store)
-		return (size <= SZ_64K) ? EFI_SUCCESS : EFI_OUT_OF_RESOURCES;
-
-	return fops->query_variable_store(attributes, size, false);
-}
-
-static
-efi_status_t check_var_size_nonblocking(u32 attributes, unsigned long size)
+static efi_status_t check_var_size(bool nonblocking, u32 attributes,
+				   unsigned long size)
 {
 	const struct efivar_operations *fops;
+	efi_status_t status;
 
 	fops = __efivars->ops;
 
 	if (!fops->query_variable_store)
+		status = EFI_UNSUPPORTED;
+	else
+		status = fops->query_variable_store(attributes, size,
+						    nonblocking);
+	if (status == EFI_UNSUPPORTED)
 		return (size <= SZ_64K) ? EFI_SUCCESS : EFI_OUT_OF_RESOURCES;
-
-	return fops->query_variable_store(attributes, size, true);
+	return status;
 }
 
 /**
@@ -195,26 +188,6 @@ efi_status_t efivar_get_next_variable(unsigned long *name_size,
 }
 EXPORT_SYMBOL_NS_GPL(efivar_get_next_variable, EFIVAR);
 
-/*
- * efivar_set_variable_blocking() - local helper function for set_variable
- *
- * Must be called with efivars_lock held.
- */
-static efi_status_t
-efivar_set_variable_blocking(efi_char16_t *name, efi_guid_t *vendor,
-			     u32 attr, unsigned long data_size, void *data)
-{
-	efi_status_t status;
-
-	if (data_size > 0) {
-		status = check_var_size(attr, data_size +
-					      ucs2_strsize(name, 1024));
-		if (status != EFI_SUCCESS)
-			return status;
-	}
-	return __efivars->ops->set_variable(name, vendor, attr, data_size, data);
-}
-
 /*
  * efivar_set_variable_locked() - set a variable identified by name/vendor
  *
@@ -228,23 +201,21 @@ efi_status_t efivar_set_variable_locked(efi_char16_t *name, efi_guid_t *vendor,
 	efi_set_variable_t *setvar;
 	efi_status_t status;
 
-	if (!nonblocking)
-		return efivar_set_variable_blocking(name, vendor, attr,
-						    data_size, data);
+	if (data_size > 0) {
+		status = check_var_size(nonblocking, attr,
+					data_size + ucs2_strsize(name, 1024));
+		if (status != EFI_SUCCESS)
+			return status;
+	}
 
 	/*
 	 * If no _nonblocking variant exists, the ordinary one
 	 * is assumed to be non-blocking.
 	 */
-	setvar = __efivars->ops->set_variable_nonblocking ?:
-		 __efivars->ops->set_variable;
+	setvar = __efivars->ops->set_variable_nonblocking;
+	if (!setvar || !nonblocking)
+		 setvar = __efivars->ops->set_variable;
 
-	if (data_size > 0) {
-		status = check_var_size_nonblocking(attr, data_size +
-							  ucs2_strsize(name, 1024));
-		if (status != EFI_SUCCESS)
-			return status;
-	}
 	return setvar(name, vendor, attr, data_size, data);
 }
 EXPORT_SYMBOL_NS_GPL(efivar_set_variable_locked, EFIVAR);
@@ -264,7 +235,8 @@ efi_status_t efivar_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 	if (efivar_lock())
 		return EFI_ABORTED;
 
-	status = efivar_set_variable_blocking(name, vendor, attr, data_size, data);
+	status = efivar_set_variable_locked(name, vendor, attr, data_size,
+					    data, false);
 	efivar_unlock();
 	return status;
 }
-- 
2.38.1



