Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D43037FF60;
	Sat, 12 Sep 2026 13:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218799; cv=none; b=hFOSvtZ3pk5iTLuGUkA4NvTjPH/sb5z+9fBd8CXC+koj5P3EZVcBxi0rvVO1u/nzRlcMULgTgJU3fxjK2+TZeMBsB6ISnLixqGAZNLCxsG3DNNQEU1L/EfE2IfdE8UG2gJJP5nVP7o64eRR/6m2g8lRc9gu3U3FqnSeYOKqic6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218799; c=relaxed/simple;
	bh=o9EfS9sIZuJIa0yOuv/EAc+9POHufhfUSMX3gaThwEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rUplc2bciNm/DfjKTZlDbINznTtkW2am/k09UaTMz/08hFnDUzMG0B0lWU+abHIcdrmsjtut3OU96kWiURB1RoA3ctPvKEu1ojYCf1dAVD0G7VxxZZiokAj2gT25gUwhmMNqeeNrdt6SaOWZjzsX2jDBjs2LaUFYnqx2n/0bIBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bP1EvOEb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bP1EvOEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0C81F000FF;
	Sat, 12 Sep 2026 13:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218798;
	bh=cYq8srm2jzDRGOVbB+0aUa368tgSyvkM1IIwYzfcEPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bP1EvOEb50ERuX5J8ez+H7P7FNPSWlLLISj1suRQNdv4q6gXU2P+BmUpyPbnNX3Zs
	 eSPQL51m7U8yojrRJFXHMDUmx8BzQvS++RdUwGKrLC96Xo6uwsM1FLkgpPVMw4gOdn
	 HFg2Wbd6CWERckCdMmr9lPPBKf51F+3DXRBfSkoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1220/1376] platform/x86: hp-bioscfg: fix password encoding bounds check
Date: Sat, 12 Sep 2026 09:00:46 +0200
Message-ID: <20260912065634.740762364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit e213939ed9e6e6badf7aa48c4c8dd9a9cdf00615 ]

The password PSWD_ENCODINGS parser reads password_obj[elem + pos_values]
while copying the supported password encodings from the ACPI package.

The outer loop only guarantees that elem is within password_obj_count.
The encoding count is bounded by MAX_ENCODINGS_SIZE, but that does not
guarantee that the ACPI package contains enough entries for all
elem + pos_values accesses.

A malformed package can therefore declare a non-zero encoding count
without providing enough string objects, causing the parser to read past
the ACPI package array and pass an out-of-bounds string pointer and
length to hp_convert_hexstr_to_str().

Add the same computed-index bounds check used by the other offset-based
package parsing loops before reading password_obj[elem + pos_values].

Fixes: 8646a3b5ee3a ("platform/x86: hp-bioscfg: passwdobj-attributes")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260708090937.740435-1-lgs201920130244@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
index 1ebc5afc850f9..34740f29f41a5 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -353,6 +353,11 @@ static int hp_populate_password_elements_from_package(union acpi_object *passwor
 		case PSWD_ENCODINGS:
 			size = min_t(u32, password_data->encodings_size, MAX_ENCODINGS_SIZE);
 			for (pos_values = 0; pos_values < size; pos_values++) {
+				if (elem + pos_values >= password_obj_count) {
+					pr_err("Error elem-objects package is too small\n");
+					return -EINVAL;
+				}
+
 				ret = hp_convert_hexstr_to_str(password_obj[elem + pos_values].string.pointer,
 							       password_obj[elem + pos_values].string.length,
 							       &str_value, &value_len);
-- 
2.53.0



