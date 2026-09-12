Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B7831618C;
	Sat, 12 Sep 2026 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225929; cv=none; b=CyQhHPv+fTaTUsTG2yTXnUEFKfoKT2BbmAE3onht7CRcwcMMlRzfRxxs8sMXExEwdpvqCFfVNfKJr6N9wd+wHZ84Ke2kTMgqZ19RONOiZqbCBf/56dvq8k5VM+vqu/wkn4P+sxg2rEN8pFEgimXNK4AlkhOdz//MI1lpkYWfeLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225929; c=relaxed/simple;
	bh=7OvXeidcLnbBo4oj8XuoKpPNi7Lwcn7HOxggHGbjDIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isa1KD0n1Np0vDZA/xe+P3sgf7tCqbika7c3rEKJCuNGrt6TIx4yICpT83GYofE2tGRACG0i8xwlnTpB6HvqCTiAnszl5wjs1sNqI+RVGPb34tfjyRcbLY+y8VzyiU1Qx4G7p/4iFhF8m3pqAB/W+wxOTXVz0P+I60QMsNVVcXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDBVt3oH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDBVt3oH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A3E1F000FF;
	Sat, 12 Sep 2026 15:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225928;
	bh=RqjgRg6WugywHpGYSF1+A/idlXZFmHUtyIKjvFqQZfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDBVt3oH+Gk+94iGaeAOjZc/rKYmKCKCHZqx5y3T0umIF2A/1gW9soUhCt1I8tsgP
	 AXYEJDwkgdIhHemQYKozPLMz5Ru5nFNwHZ1qqLBcpCU88fmgbrc62E1eLzWxC12IiU
	 7dKF3eWykVwsXK73c+E0nAxn23hGUkf+TatQReQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1298/1424] platform/x86: hp-bioscfg: fix password encoding bounds check
Date: Sat, 12 Sep 2026 09:02:10 +0200
Message-ID: <20260912065636.336322934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 91d0b8c57434d..b165f9b056e6a 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -361,6 +361,11 @@ static int hp_populate_password_elements_from_package(union acpi_object *passwor
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



