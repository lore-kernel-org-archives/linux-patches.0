Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E5620B20B;
	Tue, 12 Nov 2024 10:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407174; cv=none; b=bNzoBlH8oekCNJy9q0Qs4NQpYZOD0NfJbAGxIF/988PTKsfW2FKxIi3kuedEmi386pK/cll70zjQTOlYM+0YMe1NRnUZqTOtHhiW7ms2At9ZFg4hQHIz/y8ryak2PxQdThZUfgUnEtOHQv4IeUN6jBEPpY1WIXsbqWZ6ybfmK00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407174; c=relaxed/simple;
	bh=7VefaCYu/wINSpoY0SkxTA+QChKCePF5IXuVJydyxWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsnpYHKky5bQUKIutBLuuFP6QZCv3CgVS99p+0WYGLINunKsz1pjaeMrPyVn7aboVvU7q3NDTtJKy09dljWgasEVui7HcUn4FXFl7Bik/1cOJPi89f6txOWLonoXdfckkEXaV308NazBkRlo5UsNvNGHB5AIOIzPfWiWZY2JjCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8RJC5jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8RJC5jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9835FC4CEDA;
	Tue, 12 Nov 2024 10:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407174;
	bh=7VefaCYu/wINSpoY0SkxTA+QChKCePF5IXuVJydyxWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8RJC5jxpcBekATrhb4lTu0/+3XV9iI0Hfwn50l3rXPbgkguU1e2P9VpIyGtbKeAP
	 d4CjHZ90+eXsPLPV9iDekRm38jQH31TiXA2JPhccXCDMuMjRM5UaW9bo0HKi4pmk1z
	 89YBZIppB1UErsCCJ2rcs+zcxWXC09tTEIDwbDFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 73/76] ACPI: PRM: Clean up guid type in struct prm_handler_info
Date: Tue, 12 Nov 2024 11:21:38 +0100
Message-ID: <20241112101842.557993613@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 3d1c651272cf1df8aac7d9b6d92d836d27bed50f upstream.

Clang 19 prints a warning when we pass &th->guid to efi_pa_va_lookup():

drivers/acpi/prmt.c:156:29: error: passing 1-byte aligned argument to
4-byte aligned parameter 1 of 'efi_pa_va_lookup' may result in an
unaligned pointer access [-Werror,-Walign-mismatch]
  156 |                         (void *)efi_pa_va_lookup(&th->guid, handler_info->handler_address);
      |                                                  ^

The problem is that efi_pa_va_lookup() takes a efi_guid_t and &th->guid
is a regular guid_t.  The difference between the two types is the
alignment.  efi_guid_t is a typedef.

	typedef guid_t efi_guid_t __aligned(__alignof__(u32));

It's possible that this a bug in Clang 19.  Even though the alignment of
&th->guid is not explicitly specified, it will still end up being aligned
at 4 or 8 bytes.

Anyway, as Ard points out, it's cleaner to change guid to efi_guid_t type
and that also makes the warning go away.

Fixes: 088984c8d54c ("ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM handler and context")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/3777d71b-9e19-45f4-be4e-17bf4fa7a834@stanley.mountain
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[nathan: Fix conflicts due to lack of e38abdab441c]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/prmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -52,7 +52,7 @@ struct prm_context_buffer {
 static LIST_HEAD(prm_module_list);
 
 struct prm_handler_info {
-	guid_t guid;
+	efi_guid_t guid;
 	void *handler_addr;
 	u64 static_data_buffer_addr;
 	u64 acpi_param_buffer_addr;


