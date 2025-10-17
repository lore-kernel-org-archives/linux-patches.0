Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12B32F12BE;
	Fri, 17 Oct 2025 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713409; cv=none; b=tG0HQZ46kkCgccbKaY9qLiMaNlaGkpls+2/bDbLIrLAQSLJ8c6knheEHyquRTO0h/W6hhjwbAsyTr33K+SXGN7zfgkiyk3PZPRboXuxGuI2L7H0M5xb9lMeCbcBDTi/q+DeB9h4ztsUY9rOoBIJ6VvSav+9RB8mER1RcFIKkZmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713409; c=relaxed/simple;
	bh=//XZR/z+mCCU/Flj2apZiUDVmcaHv7S7GIS0Cgowb3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nj5S3yiv9i1tnkbNHA6Ofe9RWVoruGOF7PRGcbEUNV5XV6bXLVY6JPHjGmEzC4Fs7smx/950/FkGZnou2LI7JSo5mfObTYMzSDr1s81y+17tjmK6Tr0Kgv0Ru6hgEIjYODNgkaynyFGlG1TglEBisbqReIziydet1eNUtkkmT00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SilPy9HG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SilPy9HG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA02BC4CEE7;
	Fri, 17 Oct 2025 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713409;
	bh=//XZR/z+mCCU/Flj2apZiUDVmcaHv7S7GIS0Cgowb3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SilPy9HGhdO/2Hqq/RqQOxOBsQZthek0876wzIj3qS4SvhGvQWo5BBjbXi4MBbTZg
	 gk+oCG34QKkMhavqAEE/YV2pXwpcI0zh8wAmKsnDsg6oIsWHKNkyd4fV/fpH0usVU0
	 9qujgkxNMci1YiWWRj5bQj/sMD0MGN9HnetPfOOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/168] ACPI: property: Add code comments explaining what is going on
Date: Fri, 17 Oct 2025 16:53:53 +0200
Message-ID: <20251017145134.718394837@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 737c3a09dcf69ba2814f3674947ccaec1861c985 ]

In some places in the ACPI device properties handling code, it is
unclear why the code is what it is.  Some assumptions are not documented
and some pieces of code are based on knowledge that is not mentioned
anywhere.

Add code comments explaining these things.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Stable-dep-of: baf60d5cb8bc ("ACPI: property: Do not pass NULL handles to acpi_attach_data()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/property.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -96,7 +96,18 @@ static bool acpi_nondev_subnode_extract(
 	if (handle)
 		acpi_get_parent(handle, &scope);
 
+	/*
+	 * Extract properties from the _DSD-equivalent package pointed to by
+	 * desc and use scope (if not NULL) for the completion of relative
+	 * pathname segments.
+	 *
+	 * The extracted properties will be held in the new data node dn.
+	 */
 	result = acpi_extract_properties(scope, desc, &dn->data);
+	/*
+	 * Look for subnodes in the _DSD-equivalent package pointed to by desc
+	 * and create child nodes of dn if there are any.
+	 */
 	if (acpi_enumerate_nondev_subnodes(scope, desc, &dn->data, &dn->fwnode))
 		result = true;
 
@@ -121,6 +132,12 @@ static bool acpi_nondev_subnode_ok(acpi_
 	acpi_handle handle;
 	acpi_status status;
 
+	/*
+	 * If the scope is unknown, the _DSD-equivalent package being parsed
+	 * was embedded in an outer _DSD-equivalent package as a result of
+	 * direct evaluation of an object pointed to by a reference.  In that
+	 * case, using a pathname as the target object pointer is invalid.
+	 */
 	if (!scope)
 		return false;
 
@@ -150,6 +167,10 @@ static bool acpi_add_nondev_subnodes(acp
 	bool ret = false;
 	int i;
 
+	/*
+	 * Every element in the links package is expected to represent a link
+	 * to a non-device node in a tree containing device-specific data.
+	 */
 	for (i = 0; i < links->package.count; i++) {
 		union acpi_object *link, *desc;
 		bool result;
@@ -159,17 +180,38 @@ static bool acpi_add_nondev_subnodes(acp
 		if (link->package.count != 2)
 			continue;
 
-		/* The first one must be a string. */
+		/* The first one (the key) must be a string. */
 		if (link->package.elements[0].type != ACPI_TYPE_STRING)
 			continue;
 
-		/* The second one may be a string or a package. */
+		/* The second one (the target) may be a string or a package. */
 		switch (link->package.elements[1].type) {
 		case ACPI_TYPE_STRING:
+			/*
+			 * The string is expected to be a full pathname or a
+			 * pathname segment relative to the given scope.  That
+			 * pathname is expected to point to an object returning
+			 * a package that contains _DSD-equivalent information.
+			 */
 			result = acpi_nondev_subnode_ok(scope, link, list,
 							 parent);
 			break;
 		case ACPI_TYPE_PACKAGE:
+			/*
+			 * This happens when a reference is used in AML to
+			 * point to the target.  Since the target is expected
+			 * to be a named object, a reference to it will cause it
+			 * to be avaluated in place and its return package will
+			 * be embedded in the links package at the location of
+			 * the reference.
+			 *
+			 * The target package is expected to contain _DSD-
+			 * equivalent information, but the scope in which it
+			 * is located in the original AML is unknown.  Thus
+			 * it cannot contain pathname segments represented as
+			 * strings because there is no way to build full
+			 * pathnames out of them.
+			 */
 			desc = &link->package.elements[1];
 			result = acpi_nondev_subnode_extract(desc, NULL, link,
 							     list, parent);


