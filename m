Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE8F4EF153;
	Thu, 17 Sep 2026 17:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667647; cv=none; b=Juqy+x9dRNhG5LbKx+kW/6BciCGmzyU45uEi+rsc12FtODO9Xvt8+wPD7Sx9wgGjwLwDne44nN9Ca+snH30zf6EaZLlF/Qremk1A8sa0wnxpOm8HPkgR4MSplI7OGeHAZy+Mqsot0uey/XEVQ/G8E4R7HeF/lBa98ZZXfB3GFII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667647; c=relaxed/simple;
	bh=jsKBZqR0OTcvauQVeLeNdiswMm1b8RwuoHrGoh8TyKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWttqdHqge/KzDzsXEivRYNmZaR+/1XYSN94gnju/2/gWFC4COhogdsXt3jDL6dg6frmtLoB7P4QtbcNh71xg+blOe6535XeMLspQXNZPKiR6eqsl5ePbiGE5VK8g5UHG4+afHetRjf8wvHzzzibSTq/Yt0TQncwb97vGNWeBWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkAT7gxG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkAT7gxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C53E1F000FF;
	Thu, 17 Sep 2026 17:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667646;
	bh=wEYxbaeKnem7CvcihUd6+leA3q3k65XaSh9TFcgeNms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkAT7gxGmonBZQGtpoT7r0p9yOyED1nK3/EVpF7x33/Xl1yasIgMSCGTthGyDSeSC
	 BHEYe7IYb2X3GatYsTneAU7EOLAw+dMSqjaMFHys4VcyctSrYMCd/BTTal3LQqrqoK
	 SO99KK2aA+bCvQ+aZ7d3MtifHaVg7YfKdbG9zZRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0161/1102] ACPICA: Fix condition check in acpi_ps_parse_loop()
Date: Thu, 17 Sep 2026 16:01:44 +0100
Message-ID: <20260917151543.578525789@linuxfoundation.org>
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

[ Upstream commit 8de27e2d83c0d07ae9443c6304575b0609394bfd ]

Fix condition check for AML_ELSE_OP in acpi_ps_parse_loop() to prevent
out-of-bounds access.

Link: https://github.com/acpica/acpica/commit/3b537b92336e
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/1959692.tdWV9SEqCh@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psloop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/psloop.c b/drivers/acpi/acpica/psloop.c
index d0fd556361297..ceab76e3bcb82 100644
--- a/drivers/acpi/acpica/psloop.c
+++ b/drivers/acpi/acpica/psloop.c
@@ -425,7 +425,10 @@ acpi_status acpi_ps_parse_loop(struct acpi_walk_state *walk_state)
 
 					ACPI_ERROR((AE_INFO,
 						    "Skipping While/If block"));
-					if (*walk_state->aml == AML_ELSE_OP) {
+					if ((walk_state->aml <
+					     parser_state->aml_end)
+					    && (*walk_state->aml ==
+						AML_ELSE_OP)) {
 						ACPI_ERROR((AE_INFO,
 							    "Skipping Else block"));
 						walk_state->parser_state.aml =
-- 
2.53.0



