Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187074E0B91;
	Thu, 17 Sep 2026 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667686; cv=none; b=i5rlfvrkTKFH7hu2yI74vCDsn1boeFsxz6fxZAeXOfCPCbnmz1Zwotl6yaQG/gExF5xd1rWXeT++oY2GnjCG9HGYj0quJPtkSfe/xyAVwP5aGYb8cdFdiqazcoZUxBKVdS5RMt+pmTaECN21NCoM5r4q5YB1iBb2MC8wLyqd9rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667686; c=relaxed/simple;
	bh=8Hiy2yyYTtCLpohSxbSvT+X032cibpL6CIJ37pPHuRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3kAWZeMxWUIWpM15IWUqmlYNwj2pbMrkdzRjY8ivIYO5ajAxKjxN/SmupOnZTAwG/duYtj3Yu8M/mYOKWtfbNQcwn0JnQrR4xPXuk3xcT48wWkluFSv2aM5F3xw2cb1XLAbhF1jFc1KmU1q64voXPFEHBAwCdMigDQYPCVCto4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QN/pVlym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QN/pVlym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDB11F000FF;
	Thu, 17 Sep 2026 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667685;
	bh=cf5YpqpU0NKYJTlLiSNLTtOatlL9dX3f4eX904S/wok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QN/pVlymL5pznB3CDZ4IlT1rceLlxsu4Zc3J4lLBUMtkEI0JzQarNUjL9oODywiUg
	 7cxYSQ9MuG789PIae4tPMTcThgzAnkScEPiEaRNLcc7n2+y6xImCwHsq6/62ZacfTe
	 is5E87gFU3bsLPqWR33Od74IWNsoautzqGDJ8fXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0168/1102] ACPICA: validate handler object type in two places
Date: Thu, 17 Sep 2026 16:01:51 +0100
Message-ID: <20260917151543.757654020@linuxfoundation.org>
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

[ Upstream commit c5296da2d516707862f8a2dbb4b515f777e5294f ]

ACPICA: validate handler object type in acpi_ev_has_default_handler()
and acpi_ev_find_region_handler().

Link: https://github.com/acpica/acpica/commit/f6fc648a1389
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/48111441.fMDQidcC6G@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/evhandler.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/acpica/evhandler.c b/drivers/acpi/acpica/evhandler.c
index 1c8cb6d924df4..902ac64d26694 100644
--- a/drivers/acpi/acpica/evhandler.c
+++ b/drivers/acpi/acpica/evhandler.c
@@ -130,6 +130,14 @@ acpi_ev_has_default_handler(struct acpi_namespace_node *node,
 		/* Walk the linked list of handlers for this object */
 
 		while (handler_obj) {
+
+			/* Validate handler object type before accessing fields */
+
+			if (handler_obj->common.type !=
+			    ACPI_TYPE_LOCAL_ADDRESS_HANDLER) {
+				break;
+			}
+
 			if (handler_obj->address_space.space_id == space_id) {
 				if (handler_obj->address_space.handler_flags &
 				    ACPI_ADDR_HANDLER_DEFAULT_INSTALLED) {
@@ -292,6 +300,9 @@ union acpi_operand_object *acpi_ev_find_region_handler(acpi_adr_space_type
 	/* Walk the handler list for this device */
 
 	while (handler_obj) {
+		if (handler_obj->common.type != ACPI_TYPE_LOCAL_ADDRESS_HANDLER) {
+			break;
+		}
 
 		/* Same space_id indicates a handler is installed */
 
-- 
2.53.0



