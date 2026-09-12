Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400432FDC30;
	Sat, 12 Sep 2026 13:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220753; cv=none; b=WVH5qGzeGiW1MCAK7Bxe6Al+wd3Ihg275X4c9tckeN//QTwhCvR4Rj+uWCMRaMj6rh+fizFTXWd2rWAy5sg/Ol65x7XSYdt1qmTzzPUc/xYfxo4DYawNpoaoCi/Z18W56BxSuL1Aw0REMBJC9dW8O+EXW+1QcHxFvmvbugoih1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220753; c=relaxed/simple;
	bh=q+LgreD8FbS++VXQ9DxpG8j1V1K13ktojWC1vr9Z5uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgaCl3YKQT5ibIf8NsFAmLUNlSemO1x56T+Tr1JkEydF8qLvcOBA8LsYVOekCNrwBCjzW5oZ04SmylL4CPefZHOFwYlcjbysSDzk0TH8uMKstpMpOTvJ9Gog1YG8pm44ra9CFaZJKk1P2fnk6yYKfdzySqK78XNk/DATOat4kRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfeMASfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfeMASfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEA71F000FF;
	Sat, 12 Sep 2026 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220752;
	bh=b14R+S6AfQO1LvRxkbjEEcy/1Ts1Qx+oOMT0Q6Itq3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfeMASfPM7U2uxEDswRXFTceWcd2jKdat4K+Zq3g46GmAtG/J5T/hygtI1ibFxfYH
	 gn5ZGhnqMyBNbV6QOLwyjW9cmlYlk9jUi4qpL7tbuKyAfKEPs19izg20XWJB4GfmFN
	 FJ5a/E9kX/uyFDUeQxMmWb4g3tUQ/0z6DxA4Ohz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0241/1424] platform/x86: hp-bioscfg: advance elem past consumed array elements
Date: Sat, 12 Sep 2026 08:44:33 +0200
Message-ID: <20260912065612.679363713@linuxfoundation.org>
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
@@ -232,6 +232,8 @@ static int hp_populate_enumeration_eleme
 				kfree(str_value);
 				str_value = NULL;
 			}
+			if (size)
+				elem += size - 1;
 			break;
 
 		case SECURITY_LEVEL:
@@ -288,6 +290,8 @@ static int hp_populate_enumeration_eleme
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
@@ -246,6 +246,8 @@ static int hp_populate_integer_elements_
 				kfree(str_value);
 				str_value = NULL;
 			}
+			if (size)
+				elem += size - 1;
 			break;
 
 		case SECURITY_LEVEL:
--- a/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
@@ -239,6 +239,8 @@ static int hp_populate_ordered_list_elem
 				kfree(str_value);
 				str_value = NULL;
 			}
+			if (size)
+				elem += size - 1;
 			break;
 
 		case SECURITY_LEVEL:
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -329,6 +329,8 @@ static int hp_populate_password_elements
 				str_value = NULL;
 
 			}
+			if (size)
+				elem += size - 1;
 			break;
 		case SECURITY_LEVEL:
 			password_data->common.security_level = int_value;
@@ -372,6 +374,8 @@ static int hp_populate_password_elements
 				str_value = NULL;
 
 			}
+			if (size)
+				elem += size - 1;
 			break;
 		case PSWD_IS_SET:
 			password_data->is_enabled = int_value;
--- a/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
@@ -237,6 +237,8 @@ static int hp_populate_string_elements_f
 				kfree(str_value);
 				str_value = NULL;
 			}
+			if (size)
+				elem += size - 1;
 			break;
 
 		case SECURITY_LEVEL:


