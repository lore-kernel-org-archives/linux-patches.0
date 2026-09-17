Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A8C4E3231;
	Thu, 17 Sep 2026 16:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664039; cv=none; b=PymZsVnpHryXoPfnDSRX0j4YXjyK8TzaPIEGQVJ0h8mU9XK2E81vRWSw0qiLee42/wcZR8VOAbJEnqv5PO0h/QK9GlWH75X2hRaXKbSP4yAYRsOuezZILv11gBY1jmyUp+i8UDxv4qRwpf/0jP+PgwlCN4wUHIl9npUGWb5fayc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664039; c=relaxed/simple;
	bh=Yza/pM14tzUVMIO8/zy2441HlYxbs8FsHNNjxGUvt+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1iuTOASF21bNtkmnmN9kfQMaZl31vr1zN9MqrDakhELQnHfnt46si5gZ4bOrUpPWMTNWXv6e0hip4ICh8Bapp8+2ODJ/UigPOLI21sAhu8kp/fYJgeh/7PeCACy5rSpEnxlRavt8mN4hYNwT6jNx/WCVcot1BEV30/kWn82qDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFBGppeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFBGppeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F241F000FF;
	Thu, 17 Sep 2026 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664037;
	bh=PtFgZjrtRFRC3eqZYo8HqwUMYnDDmXvFYL+/MPoQjts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFBGppeWPg8iejuzWqDtDulL2K6LPQeMOACpCxUfTmwXfdvzz5TiDCtifjfqmx6oE
	 d0l/Hu+gZfSC5PE7aaM6xMB9w7ISU3L7CAZhjeOSbGDKPEZxqIMr4RvIDb3i2Ktfsa
	 p5BbM1OGGTC+EVZcmHiEa4k3KdKAOqQU9/ALqYiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0238/1250] ACPICA: validate byte_count in acpi_ps_get_next_package_length()
Date: Thu, 17 Sep 2026 16:00:33 +0100
Message-ID: <20260917151558.593124884@linuxfoundation.org>
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
index 55273cbbfc67e..3526ea1094146 100644
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



