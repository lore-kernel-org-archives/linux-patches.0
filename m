Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A8F4E5323;
	Thu, 17 Sep 2026 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664053; cv=none; b=u51b87hiQpYSPvbHPX/u/EWrMSREz1UaZzdaocb40jfYVNN2x9eKoEIMO2t7hQ7eYrNafQbPWJhz0EqcoOabnmjhthRwVtmhn6Hi40OZ2EX0iDtFUl3rIW/3UFvDTDGKnbHVKWdXJ3ULCx1+nSsk/Qk/X57cluznTEQ8qSPdZe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664053; c=relaxed/simple;
	bh=04cxh8Vo2qW62f3avFEpVIMYN5vGU3Qzd8fghz2ScCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l24DKkeH4RiheUmcQfiZCDRRbesQULAFV0aRnz+YFzxMy0Qny5wGVAUEsoYkHlktMUDSIqmf9nmXQ5N/p9b2M4VwFzDChfWkna9CAtiEse17BXwSqseNY34CggjrvodbLIgyaf0EXPCw/BrQipx99KIWxQkgzRv0e9OHCntaSv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Imh52FMw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Imh52FMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D62E1F000FF;
	Thu, 17 Sep 2026 16:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664052;
	bh=ga7QVfEeOZxaj+8+N+VaJTp9PQuC/7BmH/Xb6hKNDV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Imh52FMwKoWjTqD9tKITxzkT8q+Ik8d5XDxTpxqbtChQhkYIOVwzyIXoaNQD+Y9Ty
	 YbxwJMxIhVlXKcgiamuSa+6naHAyinn8m+vscXCwjKknQn7KK9333giIUOHXSPwe/4
	 yr9VBjAMiJRUcnmHkKYIbZTV2p/m/7MJzzp2fg3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0242/1250] ACPICA: validate handler object type in two places
Date: Thu, 17 Sep 2026 16:00:37 +0100
Message-ID: <20260917151558.702874318@linuxfoundation.org>
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
index 5a35dae945e20..f16c1148e602e 100644
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



