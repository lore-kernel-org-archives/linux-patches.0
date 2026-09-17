Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDAC4E5338;
	Thu, 17 Sep 2026 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664065; cv=none; b=bGG3Po2uj6wE8GlLrdd90yfGchmD1J04inU6hiI2Vyn9NcLCViHJHwWQp3b7P/Ven8/y6By4aIRsVBlEbAGSw6yyDcVNJvEtXoP0RQd3seRciBwBPjUh4aBQIGV6/RADVa4F+eMOQLbWjOMBYKVApkbOyKAeRstT0vm4JVET1tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664065; c=relaxed/simple;
	bh=10NwCutULdZ8MGCZ2cJGWC7KYt7fUS8Jq40RZq129qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKxvFntXw0OHIfm4avIK4fXpsh0QH9mXki4lTc+JSoJGCgRO32Rz/2ks7zoKc7jY0J7mlAC3oJblOFst9BUZsHw58Ba06IvoX+WFu9ji+e5rXSzX4UirIEWzPajpOxplvjNpmuaxiGUfoxQ+a2ZLovsKDddV3O94AAi1Fu4hSqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wa+tMFZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wa+tMFZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D31F1F000FF;
	Thu, 17 Sep 2026 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664064;
	bh=LT+XCkKpqpQM7jNQ6GBFXKpg8oWxrxYK3IHOoZB7MgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wa+tMFZwO+sJV9nk0OL0g1HIjhQRixVUeKouZfo3X/R52bA8OtrG8lbm/zxdIugIQ
	 1Gfogy7LMCLZl6eodbRGQNcFe9WhzKgFqXwL1QbpHvm3yCoCHm2wUc7IE9kVcP9jts
	 TNf1Er0GYEAXDbRzrMEeBJqOnmhNYiDSYGV+OV0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0246/1250] ACPICA: Fix NULL pointer dereference in acpi_ns_custom_package()
Date: Thu, 17 Sep 2026 16:00:41 +0100
Message-ID: <20260917151558.816027747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ca137ce5674fb..c32770570120a 100644
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



