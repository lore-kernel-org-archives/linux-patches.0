Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEDC31D366;
	Wed, 30 Sep 2026 15:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782638; cv=none; b=KLBqhq0PLFRXk/U8CdD6/Z2noNxIbslUQcz7YJR6Vc3i+Jg0YmzsGea9b2CfaBrIPJFhLLWm5h3Y5KRkMAw6UfkNLrYhrtolyZwvkVM+aPr1X7MPZhjgjTM3i4CJAgc7r9+b86U8PHVUBp1mn4ffXhPKUSJMY9EraRNDdWT6NBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782638; c=relaxed/simple;
	bh=W+C2Iy+4HzYNIuav2ujew5n3RDAWoJnvEn1Rm5MHa4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ussAyg1OatNQy090b+F3F++ZiuWPJz/IrKJVY7W6N75uYatazU89dkZcbmBWsoZ1tKzmFL7PEg23uH0+Z+tEwWKyjCPIWCUcqqDWJbdPFbTUjA9fUviZaNucC8XiTyFROnigJhNaJMRq1pq8XlVWVULRz9w1F5LFb0a7FdJeT6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOtef6f6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOtef6f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406631F000FF;
	Wed, 30 Sep 2026 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782629;
	bh=rx0bTsapMtTX4cgs/C+s8kXzl5D7lWMlfhFolH5qFGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOtef6f6QCbA5oPS6iJgt/WanjCc/JKtrR2uP4/jgw+kq4qtrX3Dgu4LSl6B6+F9p
	 HgLvbiCdPiQSreeSrqo2uFgpMR8grgTWpX069ff0uu9ehZ32nRslhh5VRjJ3z1Cpeu
	 uI066AGRPXjj2GJm8ASagwpSefp/sGplLkpxL3X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/595] ACPICA: Fix condition check in acpi_ps_parse_loop()
Date: Wed, 30 Sep 2026 17:19:22 +0200
Message-ID: <20260930152349.224022080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3cf0687b99157..48352ca373622 100644
--- a/drivers/acpi/acpica/psloop.c
+++ b/drivers/acpi/acpica/psloop.c
@@ -426,7 +426,10 @@ acpi_status acpi_ps_parse_loop(struct acpi_walk_state *walk_state)
 
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



