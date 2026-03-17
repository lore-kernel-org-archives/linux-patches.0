Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8742FE053;
	Tue, 17 Mar 2026 16:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765932; cv=none; b=BsAsxZdBZw2jajfDm23a5GJqWVY+M/BFgLwrv77npcgFtZkMW+P15w1H46v5ZbuspTWKBBovgRMsfIhVEDoUU0cStKl7ARNb+Y+xyicU5KabmCZYiPpUcMYW6yosjoeIdKWSqXD46qWmWTfbkJG4EuCiD+hnZo/TRApM8DwVBs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765932; c=relaxed/simple;
	bh=tlxoHxS118UjfaChid4d8R5fTWfQ98EeRblznj7yaIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhN81oG49iRpU2q41J4Er43aYpzW+/482OdSnukR0S1uR+5ZPoyDBcpYxSesyiun6iK6X8aLeE4ufbBvQZiyq91JrNROw46HQKgdk1QlI8R7d9E2KaI8kjmpKPKWZ4Ko9SrNoIycxFyjQrsH7TEk98ZNhyWwgdItTwX5KQ2hGJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObzgKMpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObzgKMpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089EFC19424;
	Tue, 17 Mar 2026 16:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765932;
	bh=tlxoHxS118UjfaChid4d8R5fTWfQ98EeRblznj7yaIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObzgKMpbl+rrESNGQejRbxY2K8aoXxTdzTtA1BuQjyKxpFKhUBqVau0Xrj32ezO7J
	 oxOVRVE5XWldLuUWEbezjzSaWF82tEePU+05el5PHlYYbJVKAR4mpzQG/ARpHRJGY9
	 kvLLc3pkW+nzqAhtC51koA4avk6nqa6gk1Apar7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 097/378] ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()
Date: Tue, 17 Mar 2026 17:30:54 +0100
Message-ID: <20260317163010.587243404@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 393815f57651101f1590632092986d1d5a3a41bd ]

The pointer returned from acpi_os_map_generic_address() is
tagged with __iomem, so make the rv it is returned to also
of void __iomem * type.

Fixes the following sparse warning:

drivers/acpi/osl.c:1686:20: warning: incorrect type in assignment (different address spaces)
drivers/acpi/osl.c:1686:20:    expected void *rv
drivers/acpi/osl.c:1686:20:    got void [noderef] __iomem *

Fixes: 6915564dc5a8 ("ACPI: OSL: Change the type of acpi_os_map_generic_address() return value")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
[ rjw: Subject tweak, added Fixes tag ]
Link: https://patch.msgid.link/20260311105835.463030-1-ben.dooks@codethink.co.uk
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 05393a7315fec..2addb40961b60 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1681,7 +1681,7 @@ acpi_status __init acpi_os_initialize(void)
 		 * Use acpi_os_map_generic_address to pre-map the reset
 		 * register if it's in system memory.
 		 */
-		void *rv;
+		void __iomem *rv;
 
 		rv = acpi_os_map_generic_address(&acpi_gbl_FADT.reset_register);
 		pr_debug("%s: Reset register mapping %s\n", __func__,
-- 
2.51.0



