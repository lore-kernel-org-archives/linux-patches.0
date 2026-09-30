Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094AB4E36E9;
	Wed, 30 Sep 2026 16:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784307; cv=none; b=djaCpDO/c6BB42xUsUBwpNxw81eT4VsDx/UXVSzghjINkDng2C8S/iv3nIgHMc9zuYNEas+OZri+5qWayzXa7dA2NETiNmAeBvkPEMJ3FRpyv4A5lq8zjrfIn5mdWusJCWFnU2AgzezHA/TfEyCPunmK864dcmQHi1TMRPSlowY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784307; c=relaxed/simple;
	bh=Up34UqDI+6c1HIYyCjb6etWO9lRy4mA8QYfE61duaeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQUoWHOPqBIPaZAarRQ0F4tTOf8SLh4Ie4/3zG4AfL6YrS7af5CbjzVePede+3TRDFYWsZd6RJ6Ei1Kq5gvw/dWwhdXXG6mV2mVhLUeb7hwNVDWgRolMedPjA5SkaGuHoh4ahmzjZtKXyctiQzyKtym0QYNJtF2m4o9NNV+4iKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyzehRN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyzehRN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8181F000FF;
	Wed, 30 Sep 2026 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784303;
	bh=cMrA6wxtWSN0ETyFXTCP0lOEWZVYKfxVhuWeEDo5Ca8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyzehRN9IkdTQQgJtt3swCffk6szGI826yHfqOoSMH9QtmxX8ob4tTp6/mNjXf9xZ
	 J6W+SYJcn9ZjvxNr5wzebx4zb/ctgTWO3oUSEHuwjJpLS12lv9cb2WF2lRSbieQvdr
	 32GFRG/elp/wPJa7PSVWCGbUtTs+2QP+er41ARMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/982] ACPICA: validate handler object type in two places
Date: Wed, 30 Sep 2026 17:14:03 +0200
Message-ID: <20260930152419.108886583@linuxfoundation.org>
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
index be9a05498adc3..6f16e863a60f3 100644
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



