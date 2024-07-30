Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350051A76A4;
	Tue, 30 Jul 2024 17:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359834; cv=none; b=lvDNuimvxxyjmQxutwV8trnTUHbyGwWCaDr5F095o0O/XNuumanTzkwJqWvyi0t4ujHtJTdE9JP8yYru04ScJ8oSzVGWR5HYLPLAY+6ynAeYd7XDKxyxEJp1atDr+3SY48Ch+qa4DG/AqioSPU2dRhgVnaPMJpAI1LPMzmYXK7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359834; c=relaxed/simple;
	bh=msP2VvToAv/EawngSbvvO4YeKpqlmSmoNS/OMNTNnCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d84DdCJGMu5bmNiaQkQ5fSVqs8YHvTz7YnxveMtN4mcXsYfZQExDULftUJAvywn9zFU4XexFupJU2iRGFa9MwKaDx+xNmNL9mpru0EsYfXU++4XcXqJmyi+YV5jqUCpIVx72URsN0UU1J5JkA7MxDAH+IPE7C30NMW52k8QyEx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJK6GnR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJK6GnR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF36EC32782;
	Tue, 30 Jul 2024 17:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359834;
	bh=msP2VvToAv/EawngSbvvO4YeKpqlmSmoNS/OMNTNnCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJK6GnR5BcsmOGUJ8LzRfAwi2txIdZVp3UTPj2yU3f2dbbh7Uk2vSXotI9nQU+IiV
	 kB1k+1YfYfU6CM3CF6mWjdXi+dXNgwTHnbTCFlc/ifKOKP3MZvvlGZ95hM5h7ohoMz
	 yfNbwoULvyklL3fj/P55TVwOqbGi0Dz9gaEqmikY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.10 542/809] x86/efistub: Avoid returning EFI_SUCCESS on error
Date: Tue, 30 Jul 2024 17:46:58 +0200
Message-ID: <20240730151746.157784151@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit fb318ca0a522295edd6d796fb987e99ec41f0ee5 upstream.

The fail label is only used in a situation where the previous EFI API
call succeeded, and so status will be set to EFI_SUCCESS. Fix this, by
dropping the goto entirely, and call efi_exit() with the correct error
code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -501,16 +501,13 @@ efi_status_t __efiapi efi_pe_entry(efi_h
 	/* Convert unicode cmdline to ascii */
 	cmdline_ptr = efi_convert_cmdline(image, &options_size);
 	if (!cmdline_ptr)
-		goto fail;
+		efi_exit(handle, EFI_OUT_OF_RESOURCES);
 
 	efi_set_u64_split((unsigned long)cmdline_ptr, &hdr->cmd_line_ptr,
 			  &boot_params.ext_cmd_line_ptr);
 
 	efi_stub_entry(handle, sys_table_arg, &boot_params);
 	/* not reached */
-
-fail:
-	efi_exit(handle, status);
 }
 
 static void add_e820ext(struct boot_params *params,


