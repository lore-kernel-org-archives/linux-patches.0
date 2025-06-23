Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2A16136;
	Mon, 23 Jun 2025 21:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714613; cv=none; b=YPSoDSJVSFCTQFg80ZvsDTFnRg0ZaOTwJR+eR5Z+GjPYw8+sy+eJ+UbTTdzSqsHFhw3YT4DkWpDOvjLWfhGc8U7jK3Lj8WuWBYObsGEBQqCvx3ubevFS8gioKUqsH0e/RQvFckLs4E45vUqjtCJw+T1AOQF+7aXwbaf86R9SOJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714613; c=relaxed/simple;
	bh=x5tNAGD2OvBWzT8LDXTUd0GJsP50TtHL8vOLXRbY+OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRtHZ7dqu51HJBZpfLDAaB7Ds2QybqQ90Zpax6SbprsNcd5X4KHofffQ0/NOez1mC4FnrKIOwZxAxrkWeWoU5HHqI0aJxo2c1Wqs+4zkDYTcxdRa0scilAAbCTRw6eqgZp5n97FmJsTnpGd44WbY71Ou7ctlKSFdpQUgck+/K1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynGkyq7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynGkyq7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86170C4CEEA;
	Mon, 23 Jun 2025 21:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714612;
	bh=x5tNAGD2OvBWzT8LDXTUd0GJsP50TtHL8vOLXRbY+OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynGkyq7dOOq8EriuESs08tvwcGxNqMV9vR6y9iFyOMJDCKGyTWEmCxIkN5afKbKc5
	 ANJTieg9z46yaQ8/Tpl7cyYvkEXdbz6QgLefRF8TaZ5GteFl/25pLR+Hh1uUptA8cl
	 70A7wohCP9Hp/SPSuVyb6D+qC+4T3W2eQFsUn1j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	gldrk <me@rarity.fan>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/355] ACPICA: utilities: Fix overflow check in vsnprintf()
Date: Mon, 23 Jun 2025 15:06:59 +0200
Message-ID: <20250623130633.296526745@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 681c11f4af4e8..a288643e8acd3 100644
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



