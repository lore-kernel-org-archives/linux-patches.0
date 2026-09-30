Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE173815D8;
	Wed, 30 Sep 2026 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784287; cv=none; b=qTyil/Agy+0ZPncmsr9hUEx17nKbETrYPtLcrzK06CBSFKVc0rCltwPPWGOxIXKT+uYgyjR1qAk0f5GED/QE5Vmeu/zr5yMCbSN9BQD8fbRk5+M21KYZ2l67PG3x3Ft+G4WL5wiE98wYHetz91yxBmGlgT8YFLB3pcRzMIY3xl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784287; c=relaxed/simple;
	bh=PYLcU9kdPl8fTEocb8UAsxHgk5tM6C7r0KQNiFFd0pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3QBzpwhfsA2d4O5BTsX/nknGuMwR4YL7HZAj8P0MI1m5XswITVNzEsSGLK1SCB1wjd/2kIyIPDwU8vQFFqS7Q1iPkiH9sL1G500vfr7/w/QH1TCTLvkRf9ZXJbuZ2SwCcKsrzd+MWP6Yzid+kdOAMjhu8f9TmftVuEqUcAMS+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YI04kOJ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YI04kOJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCF21F0089A;
	Wed, 30 Sep 2026 16:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784284;
	bh=BdDJ1bPjcSCHRuEe6+dpzKuePkZcvmccPd8X/CMYTnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YI04kOJ08fb1c9gJYvI1+3Tq2t9sLVqKB6ZZ2g8QIJUBbMPGcghoEOxk489+lL4xq
	 1HRkL0o9PGP99Q4KzFI1QpeLWRFGWswR9kqXlE9Fjnx0LmXHFpVamSEb9TvS/ZhqAi
	 4gqGfTs8Cm5mxSW7JLOlECaH0nAdNJoVUnE1ACiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/982] ACPICA: Fix condition check in acpi_ps_parse_loop()
Date: Wed, 30 Sep 2026 17:13:56 +0200
Message-ID: <20260930152418.959030578@linuxfoundation.org>
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
index 840512fa9fc61..e851c7fe31906 100644
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



