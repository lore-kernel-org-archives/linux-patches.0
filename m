Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306C7242D9B;
	Wed, 25 Feb 2026 01:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982852; cv=none; b=JMOWB5HBNRzYW3NJel1inHC/PIYDm8YDIkTPUE2RZFjZ5jx0/pfq0zrLvMnSZRw/rh6GKlLioDocQUHERosBjFMtRSd/zATJCK5q4T4kEg/eqEuSGuUeeApLkPGqqOvwsAFcPPQ7d/bh2MM7HPny2tVVyqRx4bsYqo5EI/rihN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982852; c=relaxed/simple;
	bh=9gj3gsyUF201L3WLmH+DRKOdzej+iIShKavfeCakhpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvz6YJZECb2sPGJ+348lZ/MSoQ1BrBbiOBQmkbPVVoreiPqbR5f1+rHCP/b/LmdNzv5mzvic/r75V3wA8KYkKpRIfZXe/zldgwV1ANj5lZ9MqtLsYnhvL8bHwonFfcWX8UJwNkOWt/OC75kF6T5/2jC+sSBHIQC/8w9CXWY5rk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeVGj2gz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeVGj2gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91931C116D0;
	Wed, 25 Feb 2026 01:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982851;
	bh=9gj3gsyUF201L3WLmH+DRKOdzej+iIShKavfeCakhpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeVGj2gzOGQgrmn7tCtMG/DIYtvQ0UAirN9hWuJPOFbuDESu4bzR+LvX4IoZRpR1u
	 qOuAEaz11gfwzh4L8tW5RpAn45ggQI5eCfIqrClT7R/cTwsqlcu4PRCDajN1A4ItXl
	 fwGwESBZ7lM/kAKDvsZNQkK+FAx+d9h6lJlil0rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 041/781] ACPICA: Fix NULL pointer dereference in acpi_ev_address_space_dispatch()
Date: Tue, 24 Feb 2026 17:12:30 -0800
Message-ID: <20260225012400.711010282@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit f851e03bce968ff9b3faad1b616062e1244fd38d ]

Cover a missed execution path with a new check.

Fixes: 0acf24ad7e10 ("ACPICA: Add support for PCC Opregion special context data")
Link: https://github.com/acpica/acpica/commit/f421dd9dd897
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3030574.e9J7NaK4W3@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/evregion.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index fa3475da7ea9b..b6198f73c81df 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -163,7 +163,9 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 			return_ACPI_STATUS(AE_NOT_EXIST);
 		}
 
-		if (region_obj->region.space_id == ACPI_ADR_SPACE_PLATFORM_COMM) {
+		if (field_obj
+		    && region_obj->region.space_id ==
+		    ACPI_ADR_SPACE_PLATFORM_COMM) {
 			struct acpi_pcc_info *ctx =
 			    handler_desc->address_space.context;
 
-- 
2.51.0



