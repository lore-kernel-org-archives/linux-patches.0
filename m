Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0EC1CC89D;
	Wed,  6 Nov 2024 13:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899150; cv=none; b=Phk3oeyaLiAt29ZanJjo103HejO7jnhZohjyEnEvlVlpntkWaf6ktUcumwgxrQotAeDtgcVhQ+3/kqeWZhABjeO12x3ig9EspcirZEDlq0gd5jmnNZ3BbhgNAUX8OVBqo97R2kUcp3jIm2aX5qu2hxPGsOBUwg4RSDdlsen/a9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899150; c=relaxed/simple;
	bh=5Rb0VQTtUM4IUicQv+5lenLJPDKGIe/w/oo/Zu9eYJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBtiKtlhgRdE/7YoSfL9RbYC0f5FM0YEV228KoLuSx5IF66Kkh9mWj3f7iLuhX7AKtJ5OoZeAy/ejqNc0E3X1beOYqbQUvz0mbKLYw3Yjv8FMWzK8kMZVJixMsKofaH/u88/tjcuzvgq5pOhg0ixPsr3eaT4aUJJQlehW2kt8OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzsvxmel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzsvxmel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CC7C4CECD;
	Wed,  6 Nov 2024 13:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899149;
	bh=5Rb0VQTtUM4IUicQv+5lenLJPDKGIe/w/oo/Zu9eYJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzsvxmel0jqbPxG7wcpXOC0kYdp1bwPcuWlIdKVYEajDOpf24MdCUUKFesHi2nbLs
	 Pt/GONLMCiXzri38prbgBVaC+jnfyJPouNJIyBuZ1qPrh3xuC4vnprg4cJyYACODSS
	 WpJL7d7EBvB3/wTAyvYz4MOLqDOrBcRScSuGjrWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/73] ACPI: PRM: Change handler_addr type to void pointer
Date: Wed,  6 Nov 2024 13:05:08 +0100
Message-ID: <20241106120300.094815027@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 353efd5e97a7973d78f2634274b57309d0966e29 ]

handler_addr is a virtual address passed to efi_call_virt_pointer.
While x86 currently type cast it into the pointer in it's arch specific
arch_efi_call_virt() implementation, ARM64 is restrictive for right
reasons.

Convert the handler_addr type from u64 to void pointer.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Stable-dep-of: 088984c8d54c ("ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM handler and context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/prmt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
index 8d876bdb08f68..6da424f1f133f 100644
--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -53,7 +53,7 @@ static LIST_HEAD(prm_module_list);
 
 struct prm_handler_info {
 	guid_t guid;
-	u64 handler_addr;
+	void *handler_addr;
 	u64 static_data_buffer_addr;
 	u64 acpi_param_buffer_addr;
 
@@ -136,7 +136,7 @@ acpi_parse_prmt(union acpi_subtable_headers *header, const unsigned long end)
 		th = &tm->handlers[cur_handler];
 
 		guid_copy(&th->guid, (guid_t *)handler_info->handler_guid);
-		th->handler_addr = efi_pa_va_lookup(handler_info->handler_address);
+		th->handler_addr = (void *)efi_pa_va_lookup(handler_info->handler_address);
 		th->static_data_buffer_addr = efi_pa_va_lookup(handler_info->static_data_buffer_address);
 		th->acpi_param_buffer_addr = efi_pa_va_lookup(handler_info->acpi_param_buffer_address);
 	} while (++cur_handler < tm->handler_count && (handler_info = get_next_handler(handler_info)));
-- 
2.43.0



