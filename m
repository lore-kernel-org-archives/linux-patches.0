Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D47E335078;
	Fri, 17 Oct 2025 15:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713403; cv=none; b=Rs/yoUBSAh1KDRibgBva79RQQQYPD95TaUdn0gp5kXqPSwMYeL5FkVRtetLMTzQxfTeMSGmWIconUeqbY1M99anBmsbbIA/7CsMgvQU+mCy+86sABi9sxuJZPYKDAiou993WEgU4imbArC7ursQimjSObcbSMVyoZRO5v8+h0Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713403; c=relaxed/simple;
	bh=aGPpW6XgsVbr7Dyw64byegUYAAWUgL9YRRhRsnrv/lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuxC52vg6xfcsGnEzFbpsCN36iI2vhRmsZmqFhsl3Fqtfc1d8qNqUQ+YbvndVlanL/WugHh1uUqfz+1Qr51rsIOAOhWguAc2sgQMrgGMzdUnBhBeZO2qE6CB4vyw+Gz83no2tkPk2kxbKwOGaC4JHqOqNsJ9uFxJ9mW0OigIvak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjngnv4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjngnv4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C9AC4CEE7;
	Fri, 17 Oct 2025 15:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713403;
	bh=aGPpW6XgsVbr7Dyw64byegUYAAWUgL9YRRhRsnrv/lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjngnv4eMx2Tdjh0pAJcRE/7/tGiVAhGXbPLm1M9+lHI5oJqRyIasycK+HVfJLwQC
	 9kl8P1pG2ADcPuxFWDCUpYvXogQlTXoK0abvrLX+zKpC7m/Zjww28Ob5rncZohezka
	 dXzdEKWYv68yZv9epfeJOrf+DKAowIQCowLSgBOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/168] ACPI: property: Disregard references in data-only subnode lists
Date: Fri, 17 Oct 2025 16:53:52 +0200
Message-ID: <20251017145134.680146503@linuxfoundation.org>
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

[ Upstream commit d06118fe9b03426484980ed4c189a8c7b99fa631 ]

Data-only subnode links following the ACPI data subnode GUID in a _DSD
package are expected to point to named objects returning _DSD-equivalent
packages.  If a reference to such an object is used in the target field
of any of those links, that object will be evaluated in place (as a
named object) and its return data will be embedded in the outer _DSD
package.

For this reason, it is not expected to see a subnode link with the
target field containing a local reference (that would mean pointing
to a device or another object that cannot be evaluated in place and
therefore cannot return a _DSD-equivalent package).

Accordingly, simplify the code parsing data-only subnode links to
simply print a message when it encounters a local reference in the
target field of one of those links.

Moreover, since acpi_nondev_subnode_data_ok() would only have one
caller after the change above, fold it into that caller.

Link: https://lore.kernel.org/linux-acpi/CAJZ5v0jVeSrDO6hrZhKgRZrH=FpGD4vNUjFD8hV9WwN9TLHjzQ@mail.gmail.com/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Stable-dep-of: baf60d5cb8bc ("ACPI: property: Do not pass NULL handles to acpi_attach_data()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/property.c |   51 ++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -112,32 +112,12 @@ static bool acpi_nondev_subnode_extract(
 	return false;
 }
 
-static bool acpi_nondev_subnode_data_ok(acpi_handle handle,
-					const union acpi_object *link,
-					struct list_head *list,
-					struct fwnode_handle *parent)
-{
-	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
-	acpi_status status;
-
-	status = acpi_evaluate_object_typed(handle, NULL, NULL, &buf,
-					    ACPI_TYPE_PACKAGE);
-	if (ACPI_FAILURE(status))
-		return false;
-
-	if (acpi_nondev_subnode_extract(buf.pointer, handle, link, list,
-					parent))
-		return true;
-
-	ACPI_FREE(buf.pointer);
-	return false;
-}
-
 static bool acpi_nondev_subnode_ok(acpi_handle scope,
 				   const union acpi_object *link,
 				   struct list_head *list,
 				   struct fwnode_handle *parent)
 {
+	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
 	acpi_handle handle;
 	acpi_status status;
 
@@ -149,7 +129,17 @@ static bool acpi_nondev_subnode_ok(acpi_
 	if (ACPI_FAILURE(status))
 		return false;
 
-	return acpi_nondev_subnode_data_ok(handle, link, list, parent);
+	status = acpi_evaluate_object_typed(handle, NULL, NULL, &buf,
+					    ACPI_TYPE_PACKAGE);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	if (acpi_nondev_subnode_extract(buf.pointer, handle, link, list,
+					parent))
+		return true;
+
+	ACPI_FREE(buf.pointer);
+	return false;
 }
 
 static bool acpi_add_nondev_subnodes(acpi_handle scope,
@@ -162,7 +152,6 @@ static bool acpi_add_nondev_subnodes(acp
 
 	for (i = 0; i < links->package.count; i++) {
 		union acpi_object *link, *desc;
-		acpi_handle handle;
 		bool result;
 
 		link = &links->package.elements[i];
@@ -174,22 +163,26 @@ static bool acpi_add_nondev_subnodes(acp
 		if (link->package.elements[0].type != ACPI_TYPE_STRING)
 			continue;
 
-		/* The second one may be a string, a reference or a package. */
+		/* The second one may be a string or a package. */
 		switch (link->package.elements[1].type) {
 		case ACPI_TYPE_STRING:
 			result = acpi_nondev_subnode_ok(scope, link, list,
 							 parent);
 			break;
-		case ACPI_TYPE_LOCAL_REFERENCE:
-			handle = link->package.elements[1].reference.handle;
-			result = acpi_nondev_subnode_data_ok(handle, link, list,
-							     parent);
-			break;
 		case ACPI_TYPE_PACKAGE:
 			desc = &link->package.elements[1];
 			result = acpi_nondev_subnode_extract(desc, NULL, link,
 							     list, parent);
 			break;
+		case ACPI_TYPE_LOCAL_REFERENCE:
+			/*
+			 * It is not expected to see any local references in
+			 * the links package because referencing a named object
+			 * should cause it to be evaluated in place.
+			 */
+			acpi_handle_info(scope, "subnode %s: Unexpected reference\n",
+					 link->package.elements[0].string.pointer);
+			fallthrough;
 		default:
 			result = false;
 			break;


