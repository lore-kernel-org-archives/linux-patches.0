Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A5A4156F0;
	Fri,  4 Sep 2026 05:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499894; cv=none; b=QPbKtd1pEnJnOKerZXbvweQMhZ7ec0tyDQT308U6tcLvfJC2ygmcNNg00Bgd3cFdL7IVCohyvBPB4In+NeHhC23HijGL5nNAL601ixD3u3iUmOq7nUMPD7YYuzw8KbEJO0qVYiY6CDKKiteZR8W44EMBT6AqPv/5hGlBFqbGZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499894; c=relaxed/simple;
	bh=xIHIOybAp6+pjTZ0kBtocwvBRHHjrG9rzKwcgPO/vLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T3CMUMRA2mG+cKN+3Zsww4mHD/jrQ0aa95fJSHbRzw5lmCVkd3WvuVTozvQ4xqUWUUlUfo3DE3qfpcoAkDHBGOPpZxPCCesUc81lY4WzZE6ZL2T9EOFdfLR6f/ujaa/02ckp0hG00GW2XtJrquuluNX+GT3/NLZWH7zAfjYkkBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuwQYRw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuwQYRw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09E11F00A3E;
	Fri,  4 Sep 2026 05:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499893;
	bh=eL8tIxaMhHOH9mlf9FGcQkysSAHYwWIPe4liuqGNJTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuwQYRw+tZn85u+TKwr2SZiIVzp3GUZnhUkrz6hIjgXIsPNf2MpqAq+JP7z+t3Ecu
	 kMGk/jFy6PmT+sGGRhty5hqWPwQXjQ9Rl/FTmP1mu9h6Et9yQhWwaUIfkTkAf9nPfJ
	 hFw3j6JT9g7Uq3CRspjEsCGkAmQdUX8NniRTivPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 577/713] platform/x86: hp-bioscfg: advance elem past consumed array elements
Date: Fri,  4 Sep 2026 06:59:05 +0200
Message-ID: <20260904045816.755415626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit 05c808362e808e196f75696b8a64f7aa8b2245ce upstream.

The outer parsing loop in each attribute-type parser advances "elem"
(the index into the ACPI package element array) by exactly one per
iteration, but cases that consume multi-element arrays
(PREREQUISITES, ENUM_POSSIBLE_VALUES, PSWD_ENCODINGS) read "size"
consecutive elements without adjusting "elem" for the extra entries
consumed beyond the first. The next outer iteration then re-reads a
leftover element from the array just consumed instead of the next
real property, and the type check fails on that stale element,
aborting the parse with -EIO.

This produces exactly the failure visible in dmesg on the test
hardware, on every boot:

  Error expected type 2 for elem 13, but got type 1 instead
  hp_bioscfg: Returned error 0x3, "Invalid command value/Feature not
  supported"

Fix by advancing "elem" by (size - 1) after each array-consuming
loop, so the outer loop's own "elem++" lands on the correct next
element. "eloc" is intentionally left alone: it indexes the logical
property schema, not the physical element array, and each array case
is still exactly one logical property regardless of how many physical
elements it spans.

The defect is identical across all five attribute-type parsers
(enum, integer, string, ordered-list, password), which were
copy-pasted from the same template when the driver was introduced.

Fixes: 6b2770bfd6f9 ("platform/x86: hp-bioscfg: enum-attributes")
Fixes: 6f2c06d5a467 ("platform/x86: hp-bioscfg: int-attributes")
Fixes: e6c7b3e15559 ("platform/x86: hp-bioscfg: string-attributes")
Fixes: 4b2672ec71a3 ("platform/x86: hp-bioscfg: order-list-attributes")
Fixes: 8646a3b5ee3a ("platform/x86: hp-bioscfg: passwdobj-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260812111829.172273-10-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c       |    4 ++++
 drivers/platform/x86/hp/hp-bioscfg/int-attributes.c        |    2 ++
 drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c |    2 ++
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c  |    4 ++++
 drivers/platform/x86/hp/hp-bioscfg/string-attributes.c     |    2 ++
 5 files changed, 14 insertions(+)

--- a/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
@@ -227,6 +227,8 @@ static int hp_populate_enumeration_eleme
 				kfree(str_value);
 				str_value = NULL;
 			}
+			if (size)
+				elem += size - 1;
 			break;
 
 		case SECURITY_LEVEL:
@@ -280,6 +282,8 @@ static int hp_populate_enumeration_eleme
 				kfree(str_value);
 				str_value = NULL;
 			}
+			if (size)
+				elem += (size < MAX_VALUES_SIZE ? size : MAX_VALUES_SIZE) - 1;
 			break;
 		default:
 			pr_warn("Invalid element: %d found in Enumeration attribute or data may be malformed\n", elem);
--- a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
@@ -243,6 +243,8 @@ static int hp_populate_integer_elements_
 				kfree(str_value);
 				str_value = NULL;
 			}
+			if (size)
+				elem += size - 1;
 			break;
 
 		case SECURITY_LEVEL:
--- a/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
@@ -232,6 +232,8 @@ static int hp_populate_ordered_list_elem
 				kfree(str_value);
 				str_value = NULL;
 			}
+			if (size)
+				elem += size - 1;
 			break;
 
 		case SECURITY_LEVEL:
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -321,6 +321,8 @@ static int hp_populate_password_elements
 				str_value = NULL;
 
 			}
+			if (size)
+				elem += size - 1;
 			break;
 		case SECURITY_LEVEL:
 			password_data->common.security_level = int_value;
@@ -362,6 +364,8 @@ static int hp_populate_password_elements
 				str_value = NULL;
 
 			}
+			if (size)
+				elem += size - 1;
 			break;
 		case PSWD_IS_SET:
 			password_data->is_enabled = int_value;
--- a/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
@@ -233,6 +233,8 @@ static int hp_populate_string_elements_f
 				kfree(str_value);
 				str_value = NULL;
 			}
+			if (size)
+				elem += size - 1;
 			break;
 
 		case SECURITY_LEVEL:


