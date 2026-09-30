Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2FC46F48B;
	Wed, 30 Sep 2026 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794170; cv=none; b=tfGvUIaB4rvZlgHwElCvwG4JR1KN3Yr6UPWhZx+kEyMrTyxOG8e4iXapE0Cso3q9Xv8+9xZAzzi7jlBuj3Y4FM/4Qh7dRVHo2Mr204lPxAQbPFa2jdwY7wTadXyr+w3Wuf5SJ3rOx163z3LssZ8NHoag3jXC/dvpLOvXithUrUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794170; c=relaxed/simple;
	bh=cl6lnZqq4ggz6U5TVxH8TWIfeeG6AOs5LAsoYd16Zok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKyaQ4tebUBOmaWSLSKDHN65nWMXTsFhRmnnc1sVVSCHPOQQQ9vP1y9GUkQbwnzfYsTgsLn4bLFWoFdK9Mxkfwc126A0LC1fQ1PbVgW1t5N3TNddtAbRB9FdPTSLL89FCslCh/2eCuTSkrAwqBttLcxwNVbOZjlHvMyJNDr653A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMMYM0T5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMMYM0T5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087C21F000FF;
	Wed, 30 Sep 2026 18:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794168;
	bh=oQRgTTb3QtQZwsBfnKectZunsI84L+UMQLee6OBJxqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMMYM0T54wkp9FwlpBg1D8tc28IiTY+6+0ISER448+y4WibF9jB0eNNr0xPy9dcT4
	 k3yFtVOj7R+eqBtLPPBGRqoiMVtLuiZ5R7T1HtZp9eQ1lDbh1+3cWhM4qGuB6kGHWL
	 QfHOECpx+T1WSQjwZqYAHVs1bktV9zEAjHIidfTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0117/1193] ACPICA: Fix condition check in acpi_ps_parse_loop()
Date: Wed, 30 Sep 2026 17:13:21 +0200
Message-ID: <20260930152436.825150093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



