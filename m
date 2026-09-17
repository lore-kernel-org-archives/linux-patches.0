Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717C04D4878;
	Thu, 17 Sep 2026 16:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664059; cv=none; b=iqU5bdi2v1w7Ugswyiyx9KImx9Wj2VvJCxEtyvT5N7eKkEkpa/l5D475LxaweqSZTov8YeoXpJF30FBHxNQwjicQXjzsIH3GfIrK+p0QyN9TOCqKDQX9obuxyKk62hIaSnBxws9KgOBXwSO8IQr2XA51cyfVhKAXhYuFK+p7TfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664059; c=relaxed/simple;
	bh=AqfyFHpmXpemVTJoG5qWkCg9wcg+aVtbbO+SQx3jx78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbWWi267C3ngUwldFCzKC3xCd7WpDFZe2CLvK68gihaU3pvoV7ZPZkmJKDdmJZwfWlUG54262TWjQdI/oEW6THxN4OWK1oyZOKVQ5Wb4wtI02TW4J8vFL8stvXnBSsIzBFI7ejYY+63vA4+NLYULO+uWorFp154KttbJ+ubUjCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvYVjFRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvYVjFRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D94E1F000FF;
	Thu, 17 Sep 2026 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664058;
	bh=aHE48xQJBDvxen3HPCuLEMKLVLBaFU9JVY/yaRO536I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvYVjFRo3U8eHIU38BTtxpsYq/kYtQluLarjVM1kmEzHLH7j0f40aW/kIxj7xhOFH
	 ze5PND8g7aI4IYTVVjQxBK9og+whpg3kWNeD+Qfvf4lqmohdd7XXfniNYwvs/uRuam
	 e6VcP13gtxF1zQoPAK/H2WZZWGey9t4rjf1vKDGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0244/1250] ACPICA: Add validation for node in acpi_ns_build_normalized_path()
Date: Thu, 17 Sep 2026 16:00:39 +0100
Message-ID: <20260917151558.760400281@linuxfoundation.org>
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
index 22aeeeb56cffd..19802da865c54 100644
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



