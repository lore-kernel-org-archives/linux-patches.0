Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807BA51588E;
	Wed, 30 Sep 2026 15:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782533; cv=none; b=szUzeEDrY7wnKv5+bFvsPpQYk+LI5YpZ2C082o/4YB22VzWbze+Oj7Wazz1uXUS9QBKxsAlURHRCaIV/26RR4gYiNVAsIz4ZNdJ6/6q1+sdqecMrhXzD92gEr+82yfHf+ghaAIUUWGqSVZKFTTWGDz3bXyPAaLY3SeWbvTluXIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782533; c=relaxed/simple;
	bh=/MhnB9qzjC7e4qbFrrid448BLWUHPbi51iQ4K0nd+qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohJRSQJCbTUItoKaHnO4kR20ziER2iT55aoliGTQ7SF/ca4bQ+0zzLLXWsz3uD13/RGYIpqtaJp1mdtfENRRKUF48o9ef5UCidDJNdyzg+zMMzoisdqBsCN91Hj8l/g/mqSBnnuwnKmKgaQpNoG61rLmy3DmBbaZiJOczq6ZMCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4xVH1FU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4xVH1FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46481F0089B;
	Wed, 30 Sep 2026 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782527;
	bh=fcIWWz9ZH9THrVMJkMVLXoj70Owt3XVYh17pKxrmTvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4xVH1FUGvphwHMnPyMbX80D+7/yjDjtClXC/0y7zNXoyT81ijfQ83aY8+dEvoLpe
	 lxi0F9W5job7RlCchbWO5nXEhE0VNzc94aXgvEiuSag9pStj5kJlLCxPw4iBA/XW/v
	 FlHTfwCFnZlzN3ih8oEc3QOep9BMwh6ODrSfP/tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/595] ACPICA: Fix NULL pointer dereference in acpi_ns_custom_package()
Date: Wed, 30 Sep 2026 17:19:32 +0200
Message-ID: <20260930152349.437553103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit f8d14b7bb0063bbbd86c0e4d73edb8cea7b362bc ]

acpi_ns_custom_package() unconditionally dereferences the first element
of the package to read the _BIX version number, without checking for
NULL:

    if ((*Elements)->Common.Type != ACPI_TYPE_INTEGER)

When firmware returns a _BIX package whose first element is an
unresolvable reference, ACPICA evaluates that entry to NULL.
acpi_ns_remove_null_elements() does not strip NULL entries for
ACPI_PTYPE_CUSTOM packages (fixed-position format would break if
elements were shifted), so acpi_ns_custom_package() sees the NULL
and causes a crash.

Add a NULL check for the first element (version field) before
dereferencing it. The caller then receives AE_AML_OPERAND_TYPE
instead of crashing.

Link: https://github.com/acpica/acpica/commit/f3f111b9013b
Reported-by: Xiang Mei <xmei5@asu.edu>
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5674388.Sb9uPGUboI@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nsprepkg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/acpica/nsprepkg.c b/drivers/acpi/acpica/nsprepkg.c
index 237b3ddeb0757..d5cc0381e67fa 100644
--- a/drivers/acpi/acpica/nsprepkg.c
+++ b/drivers/acpi/acpica/nsprepkg.c
@@ -631,6 +631,13 @@ acpi_ns_custom_package(struct acpi_evaluate_info *info,
 
 	/* Get version number, must be Integer */
 
+	if (!(*elements)) {
+		ACPI_WARN_PREDEFINED((AE_INFO, info->full_pathname,
+				      info->node_flags,
+				      "Return Package has a NULL version element"));
+		return_ACPI_STATUS(AE_AML_OPERAND_TYPE);
+	}
+
 	if ((*elements)->common.type != ACPI_TYPE_INTEGER) {
 		ACPI_WARN_PREDEFINED((AE_INFO, info->full_pathname,
 				      info->node_flags,
-- 
2.53.0



