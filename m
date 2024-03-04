Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC811EB5A;
	Mon,  4 Mar 2024 21:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588968; cv=none; b=thGqeKF7W+MosbgzQ1V3BE7KcUbgTEM0h26TEbn7bMUd7lHI/YJMiPRkO3+UvzhsXEqr7svHSvXK0ClSQrsr/nVY932tHONeDwA+s+wXt403C7bzoPubGrRmN8W9+zZnfxDfCmTa/Url2pNbU/wul/baL64u/PrdqNRbA+/0fnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588968; c=relaxed/simple;
	bh=iUzuETjycztyEhWUprEv002K7oi0nN2t040UwLKV7XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6TwDC0JWezg4+oC3kosFCj29/u3oVZEz0ohJ8vapmYKjIQ4zNdygzH6p3qaUvz+MDS4AzHP+upBbb9ivEiZjyvlC+42v57sIXUd+iF2DYZeR52CYnz7vIt2M96mHU3tO1agVxyQuoOVBwDG+XqBGwq5FoM3ZsMD2K6lvF6GN+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnC6sMJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnC6sMJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2789C433C7;
	Mon,  4 Mar 2024 21:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588968;
	bh=iUzuETjycztyEhWUprEv002K7oi0nN2t040UwLKV7XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnC6sMJC0R6NLTsyxPnnz3S4Vs3TlBxOIat1TROiZZvbXSq56NyosQiPDpSkRcqH+
	 kQLZ3ctjHsEesJzyGjxvHs94w/a3Pwz3Z/g4G/1AJN9Z8fc8sW5qIu6JxcK9T4O4YG
	 wBVLq0n/OUPeC3mtugx5WvJ1dw4azmM7z6Ob1aDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 126/215] efi: verify that variable services are supported
Date: Mon,  4 Mar 2024 21:23:09 +0000
Message-ID: <20240304211601.064392085@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit bad267f9e18f8e9e628abd1811d2899b1735a4e1 upstream.

Current Qualcomm UEFI firmware does not implement the variable services
but not all revisions clear the corresponding bits in the RT_PROP table
services mask and instead the corresponding calls return
EFI_UNSUPPORTED.

This leads to efi core registering the generic efivar ops even when the
variable services are not supported or when they are accessed through
some other interface (e.g. Google SMI or the upcoming Qualcomm SCM
implementation).

Instead of playing games with init call levels to make sure that the
custom implementations are registered after the generic one, make sure
that get_next_variable() is actually supported before registering the
generic ops.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -185,8 +185,27 @@ static const struct attribute_group efi_
 static struct efivars generic_efivars;
 static struct efivar_operations generic_ops;
 
+static bool generic_ops_supported(void)
+{
+	unsigned long name_size;
+	efi_status_t status;
+	efi_char16_t name;
+	efi_guid_t guid;
+
+	name_size = sizeof(name);
+
+	status = efi.get_next_variable(&name_size, &name, &guid);
+	if (status == EFI_UNSUPPORTED)
+		return false;
+
+	return true;
+}
+
 static int generic_ops_register(void)
 {
+	if (!generic_ops_supported())
+		return 0;
+
 	generic_ops.get_variable = efi.get_variable;
 	generic_ops.get_next_variable = efi.get_next_variable;
 	generic_ops.query_variable_store = efi_query_variable_store;
@@ -200,6 +219,9 @@ static int generic_ops_register(void)
 
 static void generic_ops_unregister(void)
 {
+	if (!generic_ops.get_variable)
+		return;
+
 	efivars_unregister(&generic_efivars);
 }
 


