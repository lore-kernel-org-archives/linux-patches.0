Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C273E3C81B2;
	Wed, 30 Sep 2026 18:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794203; cv=none; b=SMvNQ8ZEWt8my9D3F93TI6tv0f+yUCtBP+1Sm7qurKZL0p2Uyk0unOB6pl8zN+y/OBBiazMF0A5nXMUsWor0luFrzwuLD/Q0B1FcGK6j5mEZMk/WY4SXQtDCneIeAcr4g4Q712NQQsbsyIi6gxQkQ59cpiye7nDkPFOHVUzRIc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794203; c=relaxed/simple;
	bh=OZ92x+sLJyAppdOrRoZTlXQDvvoudEKHD8T3jVBeW5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3mpDskB/UTRO2439pfwu6Ko3cgF4xiNAr5xLz9EieCY/oYsUsP47UeCgy1trKIAO7W40G+j29Ahblmb1zUzLItprhVVhTJd74kanBqk6hSrGWyfaAhYp1WoFLin1gEePWL/hdavIyWjb6FHYqaHwa5TkYmrUQ/APB57qJpQ7CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhqN8cxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhqN8cxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294901F000FF;
	Wed, 30 Sep 2026 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794202;
	bh=KdwJT9lxv47KnR4yNOUwBscJikWUFITpcToI1bypS9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IhqN8cxdNuJdM6BKkeMu0Slma7Vn9yf6Ad7Bj5fuG4YXPXTtTCo4BaBMG6uhq/MCo
	 RxMTbp+zZst2z7wYwR4BmnT/6h6T2BJH6Iq08p7qPzSQf5CqiU5JtNgzYIyUqG3nKm
	 wX2Xu1OC4GFWxfbuwpY0MjnR3X28tEWO1GZ8F19o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0128/1193] ACPICA: Fix NULL pointer dereference in acpi_ns_custom_package()
Date: Wed, 30 Sep 2026 17:13:32 +0200
Message-ID: <20260930152437.057495588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index dd37fc108fce9..0b11622abed1b 100644
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



