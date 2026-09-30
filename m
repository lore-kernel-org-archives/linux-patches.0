Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860D5503BD3;
	Wed, 30 Sep 2026 15:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782648; cv=none; b=HXRYFW34IlqPb4X0So84ZNfObHZZZF7/5r78jBDDiS8Q3dzRCHOgJLQNopoIw6vja0B1mqJAw7qCU20c6NbQtUjze4eyd/V+rqKGt2arzkL6bRYMfdrG3zUlymiQTttUdp8anBEjB5/l8EbSeI7aFNBbwGm3o1HYIfexgkrPi/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782648; c=relaxed/simple;
	bh=p3iZ1XwgMJxFx4jgjYD7zi2AGyvFpYi908NxAUp7Xsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ig7qJT/cHABkQ1wugujQwt2oGBqKeFTKlDw8PDO1WLCPdYNha/BkHjEXd5zr4lVI0iDdMB2d47YXmTXQNMfQt7xbBeQ2lwOqznGcHofQJkiw0hpwDp9LWd5ZfMegUN70BCFO7VXmYz+ikCKRW6IATi81DNVgcmt5YRbRw8HZUH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qi6GDbss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qi6GDbss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAFE1F00898;
	Wed, 30 Sep 2026 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782638;
	bh=E8fMwJ2QC4QWc+8V6TzFXQZV/1YaMnAVocNd9GFdm5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qi6GDbssrdnPuhMFY0bomBmfWxToYL6p2ZqKv3FNZL6EwFj31c5ygAIgd99tCvdxt
	 FNPmrrKHvoFRFibRWNJ4z2EZM3701bCmPlwTixXIdRSv1eLDGS+3qAiCC5KZnBkWKR
	 yEJ2/0LU+rSK+Vyr8wM+lM0fMm6bCuqo101MjXzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/595] ACPICA: validate byte_count in acpi_ps_get_next_package_length()
Date: Wed, 30 Sep 2026 17:19:25 +0200
Message-ID: <20260930152349.286963707@linuxfoundation.org>
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

[ Upstream commit d49c6ee08365a8596f639da46eb7e71752b0cd42 ]

Validate package length reading in acpi_ps_get_next_package_length().

Link: https://github.com/acpica/acpica/commit/40e03f9941e2
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3616255.QJadu78ljV@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index ce060adeefa91..dcfed84a7f3d4 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -48,6 +48,7 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state)
 	u32 package_length = 0;
 	u32 byte_count;
 	u8 byte_zero_mask = 0x3F;	/* Default [0:5] */
+	u32 remaining;
 
 	ACPI_FUNCTION_TRACE(ps_get_next_package_length);
 
@@ -55,7 +56,23 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state)
 	 * Byte 0 bits [6:7] contain the number of additional bytes
 	 * used to encode the package length, either 0,1,2, or 3
 	 */
+
+	/* Check if we have at least one byte to read */
+	remaining = (u32)ACPI_PTR_DIFF(parser_state->aml_end, aml);
+	if (remaining == 0) {
+		return_UINT32(0);
+	}
+
 	byte_count = (aml[0] >> 6);
+
+	/* Validate byte_count and ensure we have enough bytes to read */
+	if (byte_count >= remaining) {
+
+		/* Clamp to available bytes and advance to end */
+		parser_state->aml = parser_state->aml_end;
+		return_UINT32(0);
+	}
+
 	parser_state->aml += ((acpi_size)byte_count + 1);
 
 	/* Get bytes 3, 2, 1 as needed */
-- 
2.53.0



