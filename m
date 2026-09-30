Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9094F4754;
	Wed, 30 Sep 2026 16:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784317; cv=none; b=jZc1DRRrtPZWKBOyC7whsPibRlWDdbkYEMUdHonz1GHkq8j9HUmgnvvQInFpVc5+uNAmc9TB9jduk9UrszmadrdoaXV43nPyrlvwePTLIABvGHNQvHNBcn/4632iJz1zDbfzneWyZDMyt3BNxgxVyrs/AOWXkrVC3KHwxZmCbz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784317; c=relaxed/simple;
	bh=17PzjONoXiqqEldtGB4RLnbhQcx7CC+BkxBQLXMlfsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBfZSusvfYSfK0mbzEzISbiusfZRTzbKceeaKVeCgM9kE0wv2NUO6fGqAa9AIqtR51C1fPCvPRN3geNnmF8wNE0wpvOwwVFnLOi/ySUCnP29pToIx3kzX7FMa1rH4Tu4jal+dtp+XNIzo3vXNDnci9a7IalW5N6bY+AuvjcgGVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DB28fAaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DB28fAaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B963C1F00893;
	Wed, 30 Sep 2026 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784312;
	bh=uH60DiA9jytAz92fPv21QKaosbQ802PgKkhkMqPJ6Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DB28fAafR5beV0vJWXs1MMXUSAnO1FH1We+th1GTcHWrn+hZn3zYWOr4WLgY0uI9z
	 l5qwW2T/Cj/TKRwxtvnNPGCtNI3r+LvGkKTd2Jy+FfJE0OFsXTSrVHtIgBYt0g0U8h
	 v3lUw+QwYvm5b+xnXnQwhgJRSr0BzuQTa+S5MDE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/982] ACPICA: Add validation for node in acpi_ns_build_normalized_path()
Date: Wed, 30 Sep 2026 17:14:05 +0200
Message-ID: <20260930152419.151116141@linuxfoundation.org>
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

From: ikaros <void0red@gmail.com>

[ Upstream commit 96b2b616870e46e2bc04efec03879683a0036e66 ]

Add validation for node in acpi_ns_build_normalized_path()
to prevent use-after-free vulnerabilities.

Link: https://github.com/acpica/acpica/commit/b35adf49e89a
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/118666237.nniJfEyVGO@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nsnames.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/acpica/nsnames.c b/drivers/acpi/acpica/nsnames.c
index d91153f657005..ab6d217d31db4 100644
--- a/drivers/acpi/acpica/nsnames.c
+++ b/drivers/acpi/acpica/nsnames.c
@@ -222,6 +222,12 @@ acpi_ns_build_normalized_path(struct acpi_namespace_node *node,
 		goto build_trailing_null;
 	}
 
+	/* Validate the Node to avoid use-after-free vulnerabilities */
+
+	if (ACPI_GET_DESCRIPTOR_TYPE(node) != ACPI_DESC_TYPE_NAMED) {
+		goto build_trailing_null;
+	}
+
 	next_node = node;
 	while (next_node && next_node != acpi_gbl_root_node) {
 		if (next_node != node) {
-- 
2.53.0



