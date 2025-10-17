Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B56B2745E;
	Fri, 17 Oct 2025 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714751; cv=none; b=JLffq1hHy8B0CyXm5zotJ6QKVp6XnPcZLgfrWFgMe5wkQoEckC0hhuyC7SvfQNwtQzKj3wZsjJUy74VuIlYIAOFm/RjeZt13ZCBffA0XlxLjzmxtWiF102/Ugw6TdtqT/r7g6gNvKihxzCYq2INdhNGWX4QvbVtCd5pdLUYTWN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714751; c=relaxed/simple;
	bh=M2IP5uDzCXvb4mZMQBJysCBlzy+P/Gxf+xANki8p+3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9HKqZ9oD3IugS99cIqWMSxU6gRy7ay3mwdD/bYPKqoS12b8cdk3AEGwsprkD8hJbLavck3BuzCdYqqTWz7MkUwyEN5e8FqALT5jCdJENNBOsys5XkeEUuMl10UucAYlcFAqrXwqwmwES528vKrd87AoqYhePwjGxUua+RqzQ3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyE4qLHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyE4qLHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB654C4CEE7;
	Fri, 17 Oct 2025 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714751;
	bh=M2IP5uDzCXvb4mZMQBJysCBlzy+P/Gxf+xANki8p+3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyE4qLHiasx2Ck/sI7mKY+iuJPkhtuYV07B8D6hUd+O3DQwjW3RNbNb2ELRgRHYDR
	 gKrJZvv/aZfWt80hOMad5Ne4gQ4SKNeqXL9jVNpHE+iWNWA/4V/gKVn0opS62Wor/N
	 8nvZV/Dh3N9oDOQufte+j/QUTKEmW0pmF1N7ArPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/277] ACPI: property: Do not pass NULL handles to acpi_attach_data()
Date: Fri, 17 Oct 2025 16:54:21 +0200
Message-ID: <20251017145156.428535620@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit baf60d5cb8bc6b85511c5df5f0ad7620bb66d23c ]

In certain circumstances, the ACPI handle of a data-only node may be
NULL, in which case it does not make sense to attempt to attach that
node to an ACPI namespace object, so update the code to avoid attempts
to do so.

This prevents confusing and unuseful error messages from being printed.

Also document the fact that the ACPI handle of a data-only node may be
NULL and when that happens in a code comment.  In addition, make
acpi_add_nondev_subnodes() print a diagnostic message for each data-only
node with an unknown ACPI namespace scope.

Fixes: 1d52f10917a7 ("ACPI: property: Tie data nodes to acpi handles")
Cc: 6.0+ <stable@vger.kernel.org> # 6.0+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/property.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -124,6 +124,10 @@ static bool acpi_nondev_subnode_extract(
 		result = true;
 
 	if (result) {
+		/*
+		 * This will be NULL if the desc package is embedded in an outer
+		 * _DSD-equivalent package and its scope cannot be determined.
+		 */
 		dn->handle = handle;
 		dn->data.pointer = desc;
 		list_add_tail(&dn->sibling, list);
@@ -224,6 +228,8 @@ static bool acpi_add_nondev_subnodes(acp
 			 * strings because there is no way to build full
 			 * pathnames out of them.
 			 */
+			acpi_handle_debug(scope, "subnode %s: Unknown scope\n",
+					  link->package.elements[0].string.pointer);
 			desc = &link->package.elements[1];
 			result = acpi_nondev_subnode_extract(desc, NULL, link,
 							     list, parent);
@@ -396,6 +402,9 @@ static void acpi_untie_nondev_subnodes(s
 	struct acpi_data_node *dn;
 
 	list_for_each_entry(dn, &data->subnodes, sibling) {
+		if (!dn->handle)
+			continue;
+
 		acpi_detach_data(dn->handle, acpi_nondev_subnode_tag);
 
 		acpi_untie_nondev_subnodes(&dn->data);
@@ -410,6 +419,9 @@ static bool acpi_tie_nondev_subnodes(str
 		acpi_status status;
 		bool ret;
 
+		if (!dn->handle)
+			continue;
+
 		status = acpi_attach_data(dn->handle, acpi_nondev_subnode_tag, dn);
 		if (ACPI_FAILURE(status) && status != AE_ALREADY_EXISTS) {
 			acpi_handle_err(dn->handle, "Can't tag data node\n");


