Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DAA347DD;
	Mon, 23 Jun 2025 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686076; cv=none; b=P9hGmrJq2QbcFt+FV3LSF8W2ZQ5IYqL/SjI7JyWUJWbK1afPigHpouv73TWeBbeDCi3LhU+4rYpg8GZ8gdyUub4UF/RVNVIO59F7Y7ItnU6GO2lWMwJ6oIFGzeVwx/yTpP0MCSA11ysf3WhPfjf7YVi8EI1IEEWLA2cRnMNdvDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686076; c=relaxed/simple;
	bh=gC3VXcC5+t+Xa+r1mDFAeCPfWcgE38zfpOW49RsPH4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jY5eExT5sFPuJKUAWej1txIuzY1+N88VIacvO/JlGoyCBRMVPIdSKIX1aDzfvsIjPs0J5fldbTq2fkwIrjNf/19/PHbo64KE94iDt8rWNWk/MyORuXe8OJBqusAekvtBum7V0ZjqSnbykkizVsRpkicDJo7joYZ3FHoSur/Yrpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cX5ipiAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cX5ipiAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9E7C4CEEA;
	Mon, 23 Jun 2025 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686076;
	bh=gC3VXcC5+t+Xa+r1mDFAeCPfWcgE38zfpOW49RsPH4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cX5ipiAm0jHAneZUDseNZXqrIxcLGbhuyYClCLzp5U1SfXNrRQ3htQcii1B5XLe+O
	 BGBbTLO8wuEjga1Zdn1xHhoi9vnIbEXq5iV10JWpcvND1N5eReprFOqdGILw/kNtTm
	 fqkrnJcTqkCyrd2Z6+3vPMH9BzcGYqozXhYghhJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Salem <x0rw3ll@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/222] ACPICA: Avoid sequence overread in call to strncmp()
Date: Mon, 23 Jun 2025 15:07:51 +0200
Message-ID: <20250623130616.184249907@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ff5fecff51167..f931312cf51a1 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -524,7 +524,7 @@ typedef u64 acpi_integer;
 
 /* Support for the special RSDP signature (8 characters) */
 
-#define ACPI_VALIDATE_RSDP_SIG(a)       (!strncmp (ACPI_CAST_PTR (char, (a)), ACPI_SIG_RSDP, 8))
+#define ACPI_VALIDATE_RSDP_SIG(a)       (!strncmp (ACPI_CAST_PTR (char, (a)), ACPI_SIG_RSDP, (sizeof(a) < 8) ? ACPI_NAMESEG_SIZE : 8))
 #define ACPI_MAKE_RSDP_SIG(dest)        (memcpy (ACPI_CAST_PTR (char, (dest)), ACPI_SIG_RSDP, 8))
 
 /* Support for OEMx signature (x can be any character) */
-- 
2.39.5



