Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCE32FFDEA;
	Sat, 12 Sep 2026 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220748; cv=none; b=Ry0ITiqndQPEUQtiDrPAvDT0GNm9j+V4OEfBEA7BCOARSFZkCIHftjPq/7PoXEdr8DPQY/fjUt1UMzWafa5KpGYkcwiGeBoyTsMZLracM5JvZJ1v42ksYxDzosElBUh1d3gnNbCWGylC63q/1phePXfLn0DiXWg4VY5P5p1yQYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220748; c=relaxed/simple;
	bh=t7h/8gd5oh+Ogt+UvbGnaqqzQyJNtNFQsAt2ibN5GOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mRMeuWUCsPsne9JT99jj0ExeBlsoz2kvRwkE69E5XcXJc9rwuNY6r0JXuLHTahmsjj7gLeFIiTTDmlmXVpoC/rKTR8kWoT7eEDVsjHS2990kiem7jAfFJ0s8pI15Jy2QTHT4mOcvmCFAZLxTsuqm15wRwyI66Pgqbn3bqdEKQMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHRN4JxQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHRN4JxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0798C1F000FF;
	Sat, 12 Sep 2026 13:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220747;
	bh=UDz2NRlast5QjiX21QzNMwSqlcVaemhwc0OoTy21kmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHRN4JxQEVhxdHz1gD9smOrsOduo2dW9dC/VAFhAG1m7AhWkbHEOLp26pFOr2A3pK
	 wJgDVi/Phmu7kA3INs9ETVuJ/cDUy3mfwWPDE2GPtDp3yvNJHUPxvB9DdU0/U/2W+7
	 Kw4ZMXwaYsEgC55sQJ+kQyS5/2k7ctnaGxCp5nCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0240/1424] platform/x86: hp-bioscfg: accept reduced ACPI packages from older HP BIOS
Date: Sat, 12 Sep 2026 08:44:32 +0200
Message-ID: <20260912065612.657741368@linuxfoundation.org>
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

commit 40e10e6cc8f70c041431a1e30186807e28ec46e0 upstream.

hp_init_bios_package_attribute() hard-fails when a WMI ACPI package
contains fewer elements than the type-specific expected count (e.g. 11
elements instead of 13 for INTEGER or ENUMERATION attributes). This
causes the entire hp_bioscfg driver to skip attribute enumeration on
older HP hardware whose BIOS returns shortened packages when optional
fields like prerequisites or possible values are absent.

Observed on HP EliteBook 840 G2 (BIOS M71 Ver. 01.31):

  hp_bioscfg: ACPI-package does not have enough elements: 11 < 13

The element layout has two tiers:
  - Elements 0-9 (SECURITY_LEVEL+1 = 10): common to all attribute types
  - Elements 10-N: type-specific (bounds, values, encodings, ...)

The per-type populate functions (hp_populate_*_elements_from_package)
already handle sparse packages correctly via their own elem < count
loop guards and inner-loop bounds checks. The only unsafe case is when
we lack even the common elements needed to register the attribute.

Fix by introducing COMMON_ELEM_CNT to mark the hard minimum (10), and
splitting the check into two tiers:
  - Fewer than COMMON_ELEM_CNT elements: hard fail, can't proceed.
  - Fewer than expected type-specific elements: warn, but let the
    populate function parse what is available.

Fixes: a34fc329b189 ("platform/x86: hp-bioscfg: bioscfg")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260709165900.30615-4-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c |   11 ++++++++---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.h |    3 +++
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -666,12 +666,17 @@ static int hp_init_bios_package_attribut
 	int ret = 0;
 
 	/* Take action appropriate to each ACPI TYPE */
-	if (obj->package.count < min_elements) {
-		pr_err("ACPI-package does not have enough elements: %d < %d\n",
-		       obj->package.count, min_elements);
+	if (obj->package.count < COMMON_ELEM_CNT) {
+		pr_err("ACPI-package is missing common elements: %d < %d\n",
+		       obj->package.count, COMMON_ELEM_CNT);
 		goto pack_attr_exit;
 	}
 
+	if (obj->package.count < min_elements) {
+		pr_warn("ACPI-package has fewer elements than expected: %d < %d, parsing available elements\n",
+			obj->package.count, min_elements);
+	}
+
 	elements = obj->package.elements;
 
 	/* sanity checking */
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.h
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.h
@@ -279,6 +279,9 @@ enum hp_wmi_data_elements {
 	PSWD_ENCODINGS = 13,
 	PSWD_IS_SET = 14,
 	PSWD_ELEM_CNT = 15,
+
+	/* Minimum elements shared by all attribute types (NAME..SECURITY_LEVEL) */
+	COMMON_ELEM_CNT = SECURITY_LEVEL + 1,
 };
 
 #define GET_INSTANCE_ID(type)						\


