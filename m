Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236312C032C;
	Sat, 12 Sep 2026 09:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204352; cv=none; b=n4UWChTyAOWYYwTgJy9K4cvx5Wd2XJk0YvC+ylOLSs07IZmZKPApdTohAv24ybs4FjJ9ZIgmmSEQtUxiHwG55N3swk89vHKa8BXiugdJqeLl1xlQQPhw/8gGyRpaqOlkvh1qdzIU/wSfzmuYcgumK9TntvXrg5UvUY5nvnP0x14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204352; c=relaxed/simple;
	bh=KLzYJm/YHL7qTZZbDNQbNVtkbzixq1djyPpZ9ZbZroE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RAu5PKYObCNUXNXjOLwW2ztRSZ+LsYdzCdweXbCS26zfVdwJduUjnoWiX1XUoJO2QPMRQ5IxfTlrK7pd+1MVJPviU8BdOm2zhNlsi4k/v/GciVW56c8ukFGnkhpZbS8nTRcAipgpXuI7Bd18CwU3YQu4YY4XByYHUdUuVquPjAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WifWCP82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WifWCP82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAC91F000FF;
	Sat, 12 Sep 2026 09:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204351;
	bh=2WmbIMCZEDlHd6f9Qq05mVRCZsuNs9PYDKgoSlOLUDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WifWCP82S0CN0sgb6CQEL/nYzyx1fUzk/+xHScfxh0i+mamSegk9sVKipocMDMsI8
	 YvRaEmcPDvzejPO4SAWBWj7rwn+NhgT/MKqeE71pDtjp5/OvJrnphnR+rEMw/YTARj
	 mwmGywWPe9lULw3LGD4lvJTIxneFHvdavTV8vcZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1593/1815] platform/x86: hp-bioscfg: fix password encoding bounds check
Date: Sat, 12 Sep 2026 08:55:43 +0200
Message-ID: <20260912065726.388242931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 9821403e42b64..a9e1786374162 100644
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



