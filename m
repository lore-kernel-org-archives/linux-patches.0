Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D081AD3FA;
	Mon, 23 Jun 2025 21:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715450; cv=none; b=M6wDWy/M2MqhckIQZHI63FtSTqzuwOXkkKkVywT+4TiljXrYBuRPM33jnocUbsIzLSG5NwcM9XUiQOmiFg2MXpAGqhT16uGmJgz0jTDbannXeUBLeG3wx2UKYFLdRWrQcBrdoXv8qml1Q3Lay3J25j0aYeW/vgc1nrh8bpPCTMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715450; c=relaxed/simple;
	bh=CcB0//16VI6GeGcMt9pfYetZwlD0a26JqMdNZ4HrMnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+3yZNMasQ08oeM3qCMtOhhuzJpSiCE4ACJrUx2t/hSvHWbzWZrWVFVsbMe0KmzknNDuZxrLq6ijxVeOb1JISMVI9fZuPqO+Ag/DSEjoH2hkifAMVUf+hvZNTirRXxbaYworrCMAo4QISTwIprLqw+eEbPIa649uWnqJVvY7ViI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoFpn7ZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoFpn7ZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0306FC4CEEA;
	Mon, 23 Jun 2025 21:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715450;
	bh=CcB0//16VI6GeGcMt9pfYetZwlD0a26JqMdNZ4HrMnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoFpn7ZEFF6u1drCEQXvZgPpXTyZKfrBNqrpLfZyWRBwt8VDxD6QNRRYFrfs0eHhF
	 +cGXoZ1HWX8joV2687DA0vzCo6/s07qsz9F3lB/I6GKagYBicHt69vkh3oARZu/sHv
	 exH+rXU9t5Waa3YKHjqJM09CIe1UuwRUuCuph1g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	gldrk <me@rarity.fan>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/414] ACPICA: utilities: Fix overflow check in vsnprintf()
Date: Mon, 23 Jun 2025 15:05:20 +0200
Message-ID: <20250623130646.598334158@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: gldrk <me@rarity.fan>

[ Upstream commit 12b660251007e00a3e4d47ec62dbe3a7ace7023e ]

ACPICA commit d9d59b7918514ae55063b93f3ec041b1a569bf49

The old version breaks sprintf on 64-bit systems for buffers
outside [0..UINT32_MAX].

Link: https://github.com/acpica/acpica/commit/d9d59b79
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4994935.GXAFRqVoOG@rjwysocki.net
Signed-off-by: gldrk <me@rarity.fan>
[ rjw: Added the tag from gldrk ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utprint.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/utprint.c b/drivers/acpi/acpica/utprint.c
index 42b30b9f93128..7fad03c5252c3 100644
--- a/drivers/acpi/acpica/utprint.c
+++ b/drivers/acpi/acpica/utprint.c
@@ -333,11 +333,8 @@ int vsnprintf(char *string, acpi_size size, const char *format, va_list args)
 
 	pos = string;
 
-	if (size != ACPI_UINT32_MAX) {
-		end = string + size;
-	} else {
-		end = ACPI_CAST_PTR(char, ACPI_UINT32_MAX);
-	}
+	size = ACPI_MIN(size, ACPI_PTR_DIFF(ACPI_MAX_PTR, string));
+	end = string + size;
 
 	for (; *format; ++format) {
 		if (*format != '%') {
-- 
2.39.5



