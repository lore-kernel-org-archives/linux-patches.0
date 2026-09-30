Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1F65218B2;
	Wed, 30 Sep 2026 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790942; cv=none; b=VQamaSp+RPGfSJxfbVb9kjRnW2YFy15ob0JjAUm3e7S4DLtKxv4sRi/Kd6oY+bfzGfxPpT/Blbr8BRDFzdj8FLmY/TcMrSYUPjtOQbUF4sWGVznYNW7LBSuXPM6PLbQ0QfZZ4CR4b7MrtMn04KhR9+DsHKy9Jw2IVLZk7XO8gwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790942; c=relaxed/simple;
	bh=9QTdFSkmOVVutaBU2cMqlmWtf1yhSMs30EjuxCdyb9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCOcG4O2LjqmNfLYV/cOjT4buF4Sj3zoc/fVfVt30Mr8w3QPcVNcvTMi8MJai9nIP/vw/rRv93sQllk8i64xomKvef6uS1GRGJa2AyNM+kiI9z/PFd6g6YyYcJ6jqvLwINMlCob5fsuig6MMNpc4zRRSjfth5BSLNj53Fr6eN0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuUZ5mIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuUZ5mIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349D51F00899;
	Wed, 30 Sep 2026 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790940;
	bh=GfIqCKb76UYCvX24Y9BBXY8WZwQSYN1wVIEQEy29BsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuUZ5mIFLEKpOaFVivK30SUEx8E+Mmcc9j1Llem9dj7RsGT6h7BxdR1XH8o2xrXhW
	 eLXwBRZqA7FlCbE1tEnfZfKu60H0FdXwPielq4yUyDTNYj7+q4HqiFGyitOC/yymTt
	 KMPQCDDSXsGpnMRrOFwzGTTCWEO85i/XCPlxHQVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/752] ACPICA: validate handler object type in two places
Date: Wed, 30 Sep 2026 17:19:13 +0200
Message-ID: <20260930152359.962274110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c0cd7147a5a39..d692e38387feb 100644
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



