Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6CF4B7A35;
	Thu, 17 Sep 2026 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667752; cv=none; b=Ib6mBdDo2BIG38mYe887CPfTu3vqA2O4et4/ns0+vx2IsKyFwKYSNJCQT/TJY5mv7PpNVvGeFDKHy7RP2E4dwyZixzIpB79xbiuFO53OKdmLFT3k/7+29TCyQ1ZA0NCUZGpkpOKaVV3VEW9p8f5JM6QOo25iyj+YSCl6L3+IJv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667752; c=relaxed/simple;
	bh=EHmUV3sK0tP2VZ0SQ5VubvPzC/8Pn9OVSLESEjGlqTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYijRd6lha3yyeXS1BXQUkIT3Yegi5cJvZoFJpzXN5vCcv3RfxN10Dg83CPd/Bei23hFooi54LWEJGTWaMCcfeUyhAom8XoxXYYRy3u2LOl7k35PrnGGWdqIb12cSwHrSdM1xYHi1LOkW3hk2LDQ/eVpCj25L84Z3/vUzsPBxAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1SmsZQf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1SmsZQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E7A1F000FF;
	Thu, 17 Sep 2026 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667751;
	bh=AC+MGWcoUNpEt4aj1IY6OYc3qG9qxwPLLk7G16Tc24w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1SmsZQfFnu0d565hJTyL7OpnQCv7qxHgNTxybY830VoUT8oX00mEC3vYGPrpmbF+
	 bRIdD6YOWmD2aka5cYfNGR++qiNuE9xU/sGVMbmpfW5Yis5IhJvQfjNkc2QLOCbxHU
	 HOwhW/zLgoVXJNA6qDZkoQ20Mq++n5nY6D0FXtSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0170/1102] ACPICA: Add validation for node in acpi_ns_build_normalized_path()
Date: Thu, 17 Sep 2026 16:01:53 +0100
Message-ID: <20260917151543.808928838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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



