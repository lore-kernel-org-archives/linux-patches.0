Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A71A511E61;
	Wed, 30 Sep 2026 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790814; cv=none; b=LB4FLpUVyqLZzL1swBpxZJSn0X7SK//19LjQgcwnFoDKJUt6lucmQhZcIRRsXN0vB7OJj5avgnS+eXChPtOL3H0zm09j85GMWnMv95tm4FtxIktL9qunZdk9wWq3hXB4mwFzSCK3igcB4pdrY3FKdrIUKX/eZW7OZmIoHEDtSCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790814; c=relaxed/simple;
	bh=77ZYwgzO3/PFcqD1Wm2a9NsI9SyekptN4gBwyRwg6tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=musixbcDDn3r46s0Ke4Ppm7D1l0lk1cwKnzmirOoSuh3S1dUGHcsSjsb/q7XA2bYARcNv0Tl8KIbutloncY8boNZSs6nmSzTBtSfpQZFEZ+3oVbV4OrqtBU7JhGmIZV7FUInZOtOccD5wrGEy3V2sLvP5dh425rToTv7pTP/An0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjKMH+ZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjKMH+ZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866921F00899;
	Wed, 30 Sep 2026 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790813;
	bh=0YF5YK89gJV8RGHfyDluhdeLyviO4g8ikLOcZ9arbf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjKMH+ZSNUWsMBYugUu9DiP/v9sE1WSEkwhbuCZziXOcieEc/XC2si1I/MzK3XTQS
	 qNh++8f3hpQhFIkQfsrBRz8EaWwGcHA0slFf7SMSaSkeOULb+aqxm6mBqaSzgQ3b0q
	 3xvCCicgGnwEdhsDHVaciH7RpkaZFH8xZhle6bSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/752] ACPICA: Fix condition check in acpi_ps_parse_loop()
Date: Wed, 30 Sep 2026 17:19:06 +0200
Message-ID: <20260930152359.809761458@linuxfoundation.org>
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
index 4b51dd939f29a..c59f1a49844f2 100644
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



