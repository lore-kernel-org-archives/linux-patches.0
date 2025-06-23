Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA8B218580;
	Mon, 23 Jun 2025 21:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714414; cv=none; b=iNSB33Lg5e1HaZDT/VYVDuJAOGuaRjx16dKvHqAtiX7f8eMDobhTY7ZBsW+goo0FTpbrGq1e1Y6qsBtHnV7oKNo8c9tgITGq0Egd3PA0LzVOU8qCyhgqRq3MVuXJDp1bPLLRFiC/fz+WRxoLK7LyH9ImM4OzdK/rUMVkLTxvJFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714414; c=relaxed/simple;
	bh=qGba+cP7sXO2cSWkO6OBQqF4vmaIRoiw7lFtd8EC6QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUkUFVmgpPLIRhkd1ulMcxTdqIFwaZt9Cp8MmMcm6+/4XBoIKu/xQnwMzcai6Xz7rAU3OZaByzX3ivBv0OSUGN3t4kyQdrUWuYV3ccClBftq12oe3+2IB7zAVZn59lVfjybm6I5PCVdg0iglL4fJrNLO2oRe9cqtGLz1LUFEAP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDnbN9q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDnbN9q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC90AC4CEEA;
	Mon, 23 Jun 2025 21:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714414;
	bh=qGba+cP7sXO2cSWkO6OBQqF4vmaIRoiw7lFtd8EC6QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDnbN9q/ba8esQsuocpr7GEhVjp+DdWj/C5i8skalfnHyG+1cuFJ6AontvthiXFNi
	 qbCGe0CA7cKOtWkOw313k8PLFaxXQx+Et5CSQQQgrtnAbvmyNfMxFekKpKuCUpVmXP
	 AniEjgDO3iNPctPg7e787i8qLBu7pdnmszOa/6iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Salem <x0rw3ll@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/290] ACPICA: Avoid sequence overread in call to strncmp()
Date: Mon, 23 Jun 2025 15:06:22 +0200
Message-ID: <20250623130630.575934414@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ahmed Salem <x0rw3ll@gmail.com>

[ Upstream commit 64b9dfd0776e9c38d733094859a09f13282ce6f8 ]

ACPICA commit 8b83a8d88dfec59ea147fad35fc6deea8859c58c

ap_get_table_length() checks if tables are valid by
calling ap_is_valid_header(). The latter then calls
ACPI_VALIDATE_RSDP_SIG(Table->Signature).

ap_is_valid_header() accepts struct acpi_table_header as an argument, so
the signature size is always fixed to 4 bytes.

The problem is when the string comparison is between ACPI-defined table
signature and ACPI_SIG_RSDP. Common ACPI table header specifies the
Signature field to be 4 bytes long[1], with the exception of the RSDP
structure whose signature is 8 bytes long "RSD PTR " (including the
trailing blank character)[2]. Calling strncmp(sig, rsdp_sig, 8) would
then result in a sequence overread[3] as sig would be smaller (4 bytes)
than the specified bound (8 bytes).

As a workaround, pass the bound conditionally based on the size of the
signature being passed.

Link: https://uefi.org/specs/ACPI/6.5_A/05_ACPI_Software_Programming_Model.html#system-description-table-header [1]
Link: https://uefi.org/specs/ACPI/6.5_A/05_ACPI_Software_Programming_Model.html#root-system-description-pointer-rsdp-structure [2]
Link: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wstringop-overread [3]
Link: https://github.com/acpica/acpica/commit/8b83a8d8
Signed-off-by: Ahmed Salem <x0rw3ll@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2248233.Mh6RI2rZIc@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/actypes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 85c2dcf2b7048..0a24200852415 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -527,7 +527,7 @@ typedef u64 acpi_integer;
 
 /* Support for the special RSDP signature (8 characters) */
 
-#define ACPI_VALIDATE_RSDP_SIG(a)       (!strncmp (ACPI_CAST_PTR (char, (a)), ACPI_SIG_RSDP, 8))
+#define ACPI_VALIDATE_RSDP_SIG(a)       (!strncmp (ACPI_CAST_PTR (char, (a)), ACPI_SIG_RSDP, (sizeof(a) < 8) ? ACPI_NAMESEG_SIZE : 8))
 #define ACPI_MAKE_RSDP_SIG(dest)        (memcpy (ACPI_CAST_PTR (char, (dest)), ACPI_SIG_RSDP, 8))
 
 /* Support for OEMx signature (x can be any character) */
-- 
2.39.5



