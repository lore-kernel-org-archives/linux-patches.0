Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9722719F120;
	Mon, 23 Jun 2025 22:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717192; cv=none; b=Hx2OFDopuogjKSHBUcS5+g4iilGKSgTeg5B4mw4UF1ZM6v2roBnvsMgJONHaRl756ibahL3vAe2iLO7+ipb6s3dPw2OIseLCun8t0Y8yd58bSq45vaGI9mK58NA+HBgHOpOIBwbZMS5pZfTCRl6KwEj4c1+lmrTELSV6PY6pPDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717192; c=relaxed/simple;
	bh=0jaoNjVdzKAFMox+pFkzXd+RwhGWtel2TScXp6f4pRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxeLX2g/6juMaQkkRTe7t6/xB6m8eM2/D363oGv8215SEDGokPLFEG2GLr22RoPo9QL6mtJbpqbiUdqy6KxJ5sh69WVxa1YAfD2Aq7gqXtnOGOpKPTTEtP22CIBPpn6DVWinbsnqfDiBo/IZliItQM/Vf8oIXm0YWTwEHzNN2tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyPykw3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyPykw3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E898C4CEEA;
	Mon, 23 Jun 2025 22:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717192;
	bh=0jaoNjVdzKAFMox+pFkzXd+RwhGWtel2TScXp6f4pRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyPykw3G/cfVzXgSghIVCOvq91vqU7VzWUeuMUCNgHMOhJ84yPrq5RGw5FHKsspyA
	 A3jUbXitCqXMW1PjSZSACjv3ktcTscXrNiokpir1hMwZXTsbH+M/3/AB+tRIDeyFmd
	 dvT1hAYY9KKflGptnErPwQ3xlqnxdqF9/29fAIUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Salem <x0rw3ll@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 378/508] ACPICA: Avoid sequence overread in call to strncmp()
Date: Mon, 23 Jun 2025 15:07:03 +0200
Message-ID: <20250623130654.616891665@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3491e454b2abf..680586f885a8c 100644
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



