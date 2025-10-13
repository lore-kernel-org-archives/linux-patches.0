Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4047431A562;
	Mon, 13 Oct 2025 15:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369316; cv=none; b=FO2IpsW1EYzJhGVIMBIih9hqfrePRNoAD+VWawqRisAZr3aCN6jQI5sDQaMJRY9qmWnxO0D3CMAgneGFdbOhUS6N2yjsJKXmFslMAYPGcOUXclp1SHfLrNr4ASEtFvlJjBtw7Y2GOCtlDEInmntxYE8nGN/UOb/gBNXN27ziQlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369316; c=relaxed/simple;
	bh=jMSOF1Pa9lpCeGg5mzbIG9HO2ij97cf7KIeMabvq+2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjZtiPjXMEe+BgzkK1z4Ls+A1fkVz+5R3Wqk+wb6dK+KgABJDkX0UZFjP0M2/m2NzdIL49ns+NJLZfvxOP+t7MQfkEp8/awq+yLRQPx/shcX2YdoYedmNxPdOQgQUhFBEOQA3mChEkwk9CeSFL9QXPx9OGXAspTltLX/5WiwuBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhhOU+OL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhhOU+OL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D25C116B1;
	Mon, 13 Oct 2025 15:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369315;
	bh=jMSOF1Pa9lpCeGg5mzbIG9HO2ij97cf7KIeMabvq+2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhhOU+OLXmz7OkuWWvx+ovAjIfC96WT8WBX/dvMt+s3cJR5NccClpEq0VJHUjO6wl
	 KpLOnBI0SH24jo7rvYGsj470MmmpeQCVnxShxfp6H8/nue4y8rEdYprQN6uEYPP9fe
	 bUqpkZ1/c0QWLpAnokx4twp+yMJrY8dCr+vqMkbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 160/563] ACPICA: Fix largest possible resource descriptor index
Date: Mon, 13 Oct 2025 16:40:21 +0200
Message-ID: <20251013144417.087363193@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 8ca944fea4d6d9019e01f2d6f6e766f315a9d73f ]

ACPI_RESOURCE_NAME_LARGE_MAX should be equal to the last actually
used resource descriptor index (ACPI_RESOURCE_NAME_CLOCK_INPUT).

Otherwise 'resource_index' in 'acpi_ut_validate_resource()' may be
clamped incorrectly and resulting value may issue an out-of-bounds
access for 'acpi_gbl_resource_types' array. Compile tested only.

Fixes: 520d4a0ee5b6 ("ACPICA: add support for ClockInput resource (v6.5)")
Link: https://github.com/acpica/acpica/commit/cf00116c
Link: https://marc.info/?l=linux-acpi&m=175449676131260&w=2
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/aclocal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 0c41f0097e8d7..f98640086f4ef 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -1141,7 +1141,7 @@ struct acpi_port_info {
 #define ACPI_RESOURCE_NAME_PIN_GROUP_FUNCTION   0x91
 #define ACPI_RESOURCE_NAME_PIN_GROUP_CONFIG     0x92
 #define ACPI_RESOURCE_NAME_CLOCK_INPUT          0x93
-#define ACPI_RESOURCE_NAME_LARGE_MAX            0x94
+#define ACPI_RESOURCE_NAME_LARGE_MAX            0x93
 
 /*****************************************************************************
  *
-- 
2.51.0



