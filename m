Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710A64E325C;
	Thu, 17 Sep 2026 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664029; cv=none; b=pqUky3H8SaTUYyadQ9CYj5+LUucYDU0YE0qoa0L4Vq6RNRIMcJPrPJT73evb2wzGC8/B25OSf4+dtkiw/r8fSCsyK6HYpJMpZfs3teKh/X2rGRDu/xjKe6Rr4LKrN7R/whwnBCth0TqMqTMuc8HycPM2L5Cmd21EywmiODH++l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664029; c=relaxed/simple;
	bh=DMO6xHjfp2L+sYc5N5xT7Nitn8EoC4ErNO69mw6cz88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay2GO1l7rD5gpzkbTudzngB/ZkfWdIZJTi+NiIFwQwmVIyHeWdoUvdsF+S9JQzUyP9dlPytA6/gVm7Qc3MZoBzTSxmrb7hcxrOfXa5Js3lZkpd815nvwKrB/nJx/gjbX2F0sNSryK2ROFoBC7RCvxOhUxR1JLsmA9a+c2dJMC+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYN02sPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYN02sPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DCC1F000FF;
	Thu, 17 Sep 2026 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664028;
	bh=457g+8rymBLSJ2olZ7f7VgvMBng1Jz6vblzD34Nq6xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYN02sPsnCs/vEOE1StdzautS91TDuxVfrZ+QqgXcGBLzX6aS/ggKUiszeezkl5VV
	 TOiPGasu3zJ4o5iJ9v6kjDeMMIabTTxCzJS4Jaa5Wyxrih+X9yfUPy+CrPfOhlRDS3
	 3wN4CY9H/uVBDIeib02U91gFJtRA7nv+oHsc+MNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0235/1250] ACPICA: Fix condition check in acpi_ps_parse_loop()
Date: Thu, 17 Sep 2026 16:00:30 +0100
Message-ID: <20260917151558.513142294@linuxfoundation.org>
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
index c989cadf271ce..35111ff2526b1 100644
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



