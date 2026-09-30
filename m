Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E61A3CA481;
	Wed, 30 Sep 2026 18:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794198; cv=none; b=ReMJHh67cpfN7dPb2QBVxQYq/K4C6KbxZ0mvxNkpAm93Edb7q6WqP2fqhG4a73QZU+Cl0l0BuIFPAie6pAR+1LW7TyJMyt9dqskmCrROn5H0CO9NuNmsyaQvvKDiOiGw9m0aLgenhVfRmLeqSb6DMNxUxetOFB63oUkDQxJjWOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794198; c=relaxed/simple;
	bh=AMrfg5RXWrkj/ykyvcTiZRTcnAFMBpr5ZifIJ8VOJjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYGOeT9gMR4pExhRj8S9K23vR22rZCTokaVv+X0YsbXvxw7VqP726IWaHUoMraVEgU/6FLAlZhz3v9w6qE/7Db8+h5IBfJYG4NYUCSLkjDGzFOjxv3c7o6Gh1X1nitp2GUipH7nbxyesGGlmMqIMRBXX7cU8O34Z2AZ8F7sLtNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntGFWnWw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntGFWnWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654DC1F000FF;
	Wed, 30 Sep 2026 18:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794196;
	bh=e/W01ZO/5VshdUKtX64C/DNfK76iF5R9UyJN4kmFios=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntGFWnWw2LOeTJpaLM7QmZO2K1YPENpQ19hjgsEETmi6tR/9NymzN2XRDZb6MlV7q
	 kBrXbtOq7A6HXvArEsvbXQ1+QIq0D/S6W+Of0bkdm2Y/6uI/VF2uNQ0Lo990QhLU2P
	 TbBs6r/01Kk7z6GN/Zjq6Tdtv2Db2fjpvJ6JNx/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0126/1193] ACPICA: Add validation for node in acpi_ns_build_normalized_path()
Date: Wed, 30 Sep 2026 17:13:30 +0200
Message-ID: <20260930152437.015725871@linuxfoundation.org>
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



