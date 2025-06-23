Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DE3220686;
	Mon, 23 Jun 2025 21:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715621; cv=none; b=Uc4lKJay97YUkMe+aBSAeJ9hccpPXBCqOoB1PHi27Zc9IB2Vr/PKiDyw/LDpMweHulcdwgQ20WCmSJ9x3wR0WDL0DPu3+act6p87SgKFtdvQ+T3j94bLv6hHiX3eD5Zfyrc61zyXdNL7J3qiHXx5/+s/9aXHOt/ZNhDbhz7nJhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715621; c=relaxed/simple;
	bh=LOkFX0td23e2YcaKYMO4IxFmSo6B8QVteq5/c21z5hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfmMlE+Z0tU7Wkh+REr5H1Qqy44C0p4nq07UHPCj6NaHZB2g8Gqr4NInaeQ73PdffCeuzY76glfk6ZGSkxnQtFjTp3+49Kd6w3yYBjMhnNupatbqUdFroWfdmUG77/R5KX026+6n0pf9XAErjg63sw6DMhQjxEC+Upr/a0+W6sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GICiKght; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GICiKght"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004F9C4CEEA;
	Mon, 23 Jun 2025 21:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715621;
	bh=LOkFX0td23e2YcaKYMO4IxFmSo6B8QVteq5/c21z5hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GICiKghtLwrTSwpPNMTHy5TFytaMmRjtOVwWrJS/bM8SVwOL4OFVIE5fZVsa+yiy7
	 jKLRM6Qht4SFcnBD8kL9xcYr/vuIDfQhAIHG776QT9+9vOpZ9LwotrLcubOi7Yn5xZ
	 QfPxZkp3MG/uCQg2SC+OhS/u5uMDZJJV1PLTVv2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	gldrk <me@rarity.fan>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/411] ACPICA: utilities: Fix overflow check in vsnprintf()
Date: Mon, 23 Jun 2025 15:06:52 +0200
Message-ID: <20250623130640.402979388@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 05426596d1f4a..f910714b51f34 100644
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



