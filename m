Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBF723EA9E;
	Fri, 17 Oct 2025 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715211; cv=none; b=J//j88OBfLzST7jPlNu0JX5M8f77Imlvb9YpBkhEdmsV/ebBrWJ/eMlZZ+jRRonOPOCYN4sYdbtZsBdbOLrcASGM0JCbA34U0HKeEaeymrLpB7gEbjdO5mAZBMWsj1rg/X/1/G8EXwJMwgSC6Q00YJrQYZSJwPfCGkMRqMIbahY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715211; c=relaxed/simple;
	bh=IhQJEJbeWB1fmD+QZe8GdlQj9ScsTrN+vAckScriXIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6WWXwyc7uHtYZ58WqW/RS4SXkTNcQh4YWM7L7KqiIaEEAPYjrBR6ibdVxQWnYofRMq142QyYyoaTYRWutP0jWqKspYCdThtgoiCfOPhkH0ZV1r1IMrX+E9LehpVDLDGtJXyk97q4qhR0ob71htiolhzEZ6T5KVAv8kO7m3Bjh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WjmGXiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WjmGXiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174D2C4CEE7;
	Fri, 17 Oct 2025 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715210;
	bh=IhQJEJbeWB1fmD+QZe8GdlQj9ScsTrN+vAckScriXIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WjmGXiqGgCbCB3V4GrtEtIcD1mKN0hpYDuxG+F81iYRA5Xv0hWWdAZUHU48bwtAH
	 1kr10CMgdDEVgxvP+D3xD3QAYIMesFW1jg7D1w3+nQdSfhDqFeATNapuiLUj2nUB1/
	 QCXFzeScz0a29eNYtFxUMWmvDJW4gSGyzN18pteY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.17 137/371] ACPI: property: Fix buffer properties extraction for subnodes
Date: Fri, 17 Oct 2025 16:51:52 +0200
Message-ID: <20251017145206.887404642@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit d0759b10989c5c5aae3d455458c9fc4e8cc694f7 upstream.

The ACPI handle passed to acpi_extract_properties() as the first
argument represents the ACPI namespace scope in which to look for
objects returning buffers associated with buffer properties.

For _DSD objects located immediately under ACPI devices, this handle is
the same as the handle of the device object holding the _DSD, but for
data-only subnodes it is not so.

First of all, data-only subnodes are represented by objects that
cannot hold other objects in their scopes (like control methods).
Therefore a data-only subnode handle cannot be used for completing
relative pathname segments, so the current code in
in acpi_nondev_subnode_extract() passing a data-only subnode handle
to acpi_extract_properties() is invalid.

Moreover, a data-only subnode of device A may be represented by an
object located in the scope of device B (which kind of makes sense,
for instance, if A is a B's child).  In that case, the scope in
question would be the one of device B.  In other words, the scope
mentioned above is the same as the scope used for subnode object
lookup in acpi_nondev_subnode_extract().

Accordingly, rearrange that function to use the same scope for the
extraction of properties and subnode object lookup.

Fixes: 103e10c69c61 ("ACPI: property: Add support for parsing buffer property UUID")
Cc: 6.0+ <stable@vger.kernel.org> # 6.0+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/property.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -83,6 +83,7 @@ static bool acpi_nondev_subnode_extract(
 					struct fwnode_handle *parent)
 {
 	struct acpi_data_node *dn;
+	acpi_handle scope = NULL;
 	bool result;
 
 	if (acpi_graph_ignore_port(handle))
@@ -98,27 +99,18 @@ static bool acpi_nondev_subnode_extract(
 	INIT_LIST_HEAD(&dn->data.properties);
 	INIT_LIST_HEAD(&dn->data.subnodes);
 
-	result = acpi_extract_properties(handle, desc, &dn->data);
+	/*
+	 * The scope for the completion of relative pathname segments and
+	 * subnode object lookup is the one of the namespace node (device)
+	 * containing the object that has returned the package.  That is, it's
+	 * the scope of that object's parent device.
+	 */
+	if (handle)
+		acpi_get_parent(handle, &scope);
 
-	if (handle) {
-		acpi_handle scope;
-		acpi_status status;
-
-		/*
-		 * The scope for the subnode object lookup is the one of the
-		 * namespace node (device) containing the object that has
-		 * returned the package.  That is, it's the scope of that
-		 * object's parent.
-		 */
-		status = acpi_get_parent(handle, &scope);
-		if (ACPI_SUCCESS(status)
-		    && acpi_enumerate_nondev_subnodes(scope, desc, &dn->data,
-						      &dn->fwnode))
-			result = true;
-	} else if (acpi_enumerate_nondev_subnodes(NULL, desc, &dn->data,
-						  &dn->fwnode)) {
+	result = acpi_extract_properties(scope, desc, &dn->data);
+	if (acpi_enumerate_nondev_subnodes(scope, desc, &dn->data, &dn->fwnode))
 		result = true;
-	}
 
 	if (result) {
 		dn->handle = handle;


