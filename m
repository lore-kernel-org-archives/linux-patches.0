Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9914FD267;
	Wed, 30 Sep 2026 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784322; cv=none; b=d1Xmpoh+tmm0bFA7MoF5/4iw6Tn5SQwifVDEYdN0RI9sFTlQOETVtJ7qOxvyg3kLcw4dpbfTIkdSO6Nt8SRPdG2A4Dt7rFlCxWXEAuNQXRillTnm3l/hPKcHdETp5Bpka/ftL0lvTgg+lEx4w0fzxoWVGtdISrJAXsXAiT6MBks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784322; c=relaxed/simple;
	bh=YvdixY+UILDsjBHuaePw7uwgS62cGJbbPEa2KJY6x3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdmnSmTKOxPLwRSTLjFxjZvhJR4K53lw4e2Uph5BhuwIb7vxbqbAeIK5FE+FykTZoJbfLRxlth3xIqzaszKhBUUykWAafrQKP9D7DIYc7/3Vt+4wP4OCi1MjKLnGsST3qZzQIoG3pzRGPtKvP4Bogiaf/jTuZPO7U2UzPldNcH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDAiXxVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDAiXxVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771B71F00898;
	Wed, 30 Sep 2026 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784318;
	bh=z2fTlxKgUG57Nr0rJVnA8IOSFzB050nog5U8qjRLNSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDAiXxVpsjxNbU/oY1aadsbdgVjUswhyjki7XLG3Z9Oiu81iGjWfsCEmVbiAJg2O2
	 +OXw39526xE75kM8IgBc3i7M8ItBrK+tBogt/wrN5m1Yt5fNwK/YPCGAKpE1pT/U2I
	 jddiVx4sKMCPzIAPmwEj2eiMAFLmRe4R+n2d4R64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/982] ACPICA: Fix NULL pointer dereference in acpi_ns_custom_package()
Date: Wed, 30 Sep 2026 17:14:07 +0200
Message-ID: <20260930152419.196410287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 82932c9a774b4..887eb54942ffc 100644
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



