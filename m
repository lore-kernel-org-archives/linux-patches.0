Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247E23370E2;
	Fri, 17 Oct 2025 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713412; cv=none; b=urgkbS1WquwShq2UbFR3MLPhdNLc657jFgbr3CXFvk8Ma7AuiMrtWGe1Aa2/j25pzGUxEBukyE4/pnMQY5Oh6WyzimJH8jCN4eTQR+a/TYoYP05LgxPFzY3YI5OZWuKwFnu0vqVAq2KBWIAp7y5mSHIs5mUcZ97mlNKrKsIp0rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713412; c=relaxed/simple;
	bh=iORQ6r9HiT/2yBqAX8oTTHxnnHvStAuXbZWokibFEx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0jRAdqF+VJmjMGaraBZ40N/PMK0nRAbvsoswYrsBDoEsVqlBE9wj2dVxYKkDWHzz7/VbCQziXYWBjEkj+q/SnFHqP4sSXc/D3qsXbGxEc8emcTFjox8so+M5o2JZqIM3qnZxTSUhRKpamrsDI67cVrl1MPlg2eB5FMKUDUrQW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yp2SVPQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yp2SVPQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DFDC4CEE7;
	Fri, 17 Oct 2025 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713412;
	bh=iORQ6r9HiT/2yBqAX8oTTHxnnHvStAuXbZWokibFEx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yp2SVPQqVdesX8/mLIualqHzLVUy+Mt+f1r1JpytRpM8aLiepAjIgQXO3XikZkQtg
	 Jryw2img0GbO0CIEDe2J5Ly5oEn8qLcCuSpimG9dE7MByCGhl1llIkKbNbN37nGlro
	 yUgnbFeVwTPXbEq5PXMXANAUWUtfaicg3Eklul68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/168] ACPI: property: Do not pass NULL handles to acpi_attach_data()
Date: Fri, 17 Oct 2025 16:53:54 +0200
Message-ID: <20251017145134.755234233@linuxfoundation.org>
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
@@ -112,6 +112,10 @@ static bool acpi_nondev_subnode_extract(
 		result = true;
 
 	if (result) {
+		/*
+		 * This will be NULL if the desc package is embedded in an outer
+		 * _DSD-equivalent package and its scope cannot be determined.
+		 */
 		dn->handle = handle;
 		dn->data.pointer = desc;
 		list_add_tail(&dn->sibling, list);
@@ -212,6 +216,8 @@ static bool acpi_add_nondev_subnodes(acp
 			 * strings because there is no way to build full
 			 * pathnames out of them.
 			 */
+			acpi_handle_debug(scope, "subnode %s: Unknown scope\n",
+					  link->package.elements[0].string.pointer);
 			desc = &link->package.elements[1];
 			result = acpi_nondev_subnode_extract(desc, NULL, link,
 							     list, parent);
@@ -384,6 +390,9 @@ static void acpi_untie_nondev_subnodes(s
 	struct acpi_data_node *dn;
 
 	list_for_each_entry(dn, &data->subnodes, sibling) {
+		if (!dn->handle)
+			continue;
+
 		acpi_detach_data(dn->handle, acpi_nondev_subnode_tag);
 
 		acpi_untie_nondev_subnodes(&dn->data);
@@ -398,6 +407,9 @@ static bool acpi_tie_nondev_subnodes(str
 		acpi_status status;
 		bool ret;
 
+		if (!dn->handle)
+			continue;
+
 		status = acpi_attach_data(dn->handle, acpi_nondev_subnode_tag, dn);
 		if (ACPI_FAILURE(status) && status != AE_ALREADY_EXISTS) {
 			acpi_handle_err(dn->handle, "Can't tag data node\n");


