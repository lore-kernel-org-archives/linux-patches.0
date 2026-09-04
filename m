Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551323E7631;
	Fri,  4 Sep 2026 05:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501516; cv=none; b=p2Loc4i5qigiSi2E3cPmPPudwT7lPSQt7j0XIlchcW7dZ8yCOmJmI1/txM5dzYfVaTga8NUkADe+qhr3GyP0nr8xgjFCSz322ULUEKcBTYk6zZh7rgEhqzEbithnfaNYOu86bF1KLYDIK5WcV4gQhkwkrUDhn1fP4ystOVna3i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501516; c=relaxed/simple;
	bh=avpupqnRzBxA12xS0eDcTuRETa9My4caQ2UYHUkgB/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m9pi5+dbgKh3cHrZ8sIKpSW5PJit/oSNSj35koC4iHqbLe3qzkKDSd4OS/WvwXWJfrqEZi7UX+hXLLpLdlpKx+KsXMgT7fiF8vkRvAHEY5Ka+A8MCyTuT29c4OYN7RFcgcCdP29HRWqg3uo5iATMkWvoRlvgRvy6yoHn1/ujzwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17QN17KM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17QN17KM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC36F1F00A3E;
	Fri,  4 Sep 2026 05:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501515;
	bh=ddG9uA35qGKpXIieK5Ui5wx571fTdzpiGXiRDXzSs7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17QN17KMOg9UeV4a5LqNLwIRw+GHRucXG10ccwT0+TFJWlEPEPyn18c6KLj/aahp5
	 RkpnJ8xX1W7IhKF+a+xgFDE87QQUZB9YkgKT3Y5M6LT/ive9OTKQr1wqJ5PsqaM3g7
	 G9tJLf4HPJKaRyivDrSJU8I9BPX48sph0NjUTz4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 435/552] platform/x86: hp-bioscfg: advance elem past consumed array elements
Date: Fri,  4 Sep 2026 06:59:52 +0200
Message-ID: <20260904045800.456702544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -233,6 +233,8 @@ static int hp_populate_ordered_list_elem
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


