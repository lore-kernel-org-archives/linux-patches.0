Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6941AC2E0;
	Mon, 23 Jun 2025 21:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714294; cv=none; b=dkx5maFO1GhS1UFNsh/cmVtsTLhFq73MXuZcqEmzoSes49t2RQaOfCSQTqkhOVHrJ/Jfprv4ckmkCSbM9WAuYI0qFGjy/4VtFv5eTU90YVHXeU8MtQUJXmvBu185OLpGyrQTnFuSNCSnTNRB1mz6JjbD/bx0vvRRJak3BkgIV8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714294; c=relaxed/simple;
	bh=Ub8PjA/HF98iFhbpZHsCQTNRvGqDDUMdODXkxtYAn9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSZWOKA9/gNwBtrdPFrO990SH5/ZcGS2P5K8L8mWeR6IflHLAwYAlSx8Pan+UIoOhGKNctL/5XCEuFpTOPTEGp1HfZeCPT4qgJQZONzqxVEeikH7K/OzUwzrIdZ7Eh5yj1L2w8MVh34jZr9NQn4EFDNh79ZGQSZpXrvRo4pd1Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEXhy291; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEXhy291"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC91FC4CEEA;
	Mon, 23 Jun 2025 21:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714294;
	bh=Ub8PjA/HF98iFhbpZHsCQTNRvGqDDUMdODXkxtYAn9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEXhy2917sDqKGzSGGwqHraTWpVYaDtxz0QJnrwej/qCfMErjulzVyS2SINYXZFSG
	 +bOiusbS0QhJNf7sqykHIHbOIEqmEyoMTJ+ZNcOGyTQgEckNif7fSibQOpDxAsPd79
	 vhlPWuI7n1gYjyY68Y1zHWDXL60tPZkFgntXV46w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	gldrk <me@rarity.fan>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/290] ACPICA: utilities: Fix overflow check in vsnprintf()
Date: Mon, 23 Jun 2025 15:06:29 +0200
Message-ID: <20250623130630.775583833@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



