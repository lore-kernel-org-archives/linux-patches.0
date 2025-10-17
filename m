Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2188D3208;
	Fri, 17 Oct 2025 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713977; cv=none; b=Z9v9gXjFFKkZ+5UF4fSUhfH4I//P52oiTcFxb8jNooUa/saEbw9xYugmn5XGc06ZzjPtl3OK1YCxOouZMXLMxe+zBN0ifM+KtrutpQW6u6yIauaK/RmPd5PqV1+5bwbziNuWQ5et+m/XGzOpG0FoBNpUSmrsB9u8XSviRxItbeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713977; c=relaxed/simple;
	bh=sugkaHs4Bwqls/NsrBDORKt5GtaPw82Yhv6SoFbrL+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPcd3r/f20gyB3ZMj2fp3kgS12lk2deqoE3R6shWTWOGEmT2hlJx0BOFzOyoLS3Uk4GnhA7f7etO/T0vDU0WQi2jh3cCvoro8+1QkWSw+u7Tl+vS1OtZjb1rk1fSv/PNKtg65CvIUDIdCgVn9/Dvow+8VjT9ZatuBB61XNH4U+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh0/RpJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh0/RpJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B507C4CEE7;
	Fri, 17 Oct 2025 15:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713977;
	bh=sugkaHs4Bwqls/NsrBDORKt5GtaPw82Yhv6SoFbrL+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hh0/RpJcY2kI0VPfsOuK/2HgbhyAe8PAAZmJK+vwL3oSZUhEduYRqKeoN+HUKkYOW
	 /bXzN0Xq0mV33MR0ZpMy23beV5quHkRvKTttJ26HpsoHZKLuitVJ4vrDdmefiCj73S
	 gyyH7KvpUxdtVlN+323B9VKcjsR/MpqF8C5qyiCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/201] ACPI: property: Do not pass NULL handles to acpi_attach_data()
Date: Fri, 17 Oct 2025 16:54:05 +0200
Message-ID: <20251017145141.516734994@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


