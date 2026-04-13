Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A193314D0D;
	Mon, 13 Apr 2026 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098779; cv=none; b=JkzhswNC27PT0xqG1eJCmTxv+EdoA47vNmzQvfwq6qstgvCbKwqTXQ4HYx1mkAd8+zvTAMMaa966pHHHimEayF6kvzYSuPpbh2Eipycu8qV1iqshOYUoMSdAMxdZYOUKq2yx4qw6o+dg4xG3XwPwrms3F2AEpZj9KY0vcnf/1OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098779; c=relaxed/simple;
	bh=G9bNrzT4dUGu/XqKAvcwojIEv8q8TD7hta0xIMCYkTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVGUNFUsUYcRFOGkhhkHA679VRVzraVQ4LDOCBxKvSSRGpvXJPX8DZZ6CP7eLfLVh8z8dI65w/VZ7cFq/gGBvakv9f/CoI5pfaxBQcHrZtZ1ESYw3SR7wRJeQ343ouDW8yDqLRNz1Crgb2JCM3QvHj/ZYwPInWP33Zb33kRnHyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1YNKOfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1YNKOfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49E4C2BCAF;
	Mon, 13 Apr 2026 16:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098779;
	bh=G9bNrzT4dUGu/XqKAvcwojIEv8q8TD7hta0xIMCYkTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1YNKOfWIQx8CKxmK2w771ACB7Aa/ClAXA/0/I7vJdbjxsrUrAqZ+OEJzsUYWJCre
	 0DZkKS11nsZLKrrC5yQdewH7f4lpC4cVT+V2l4c2yTp6dlEYBvxHN9oOevp0T9nsWj
	 4AaXh/Ri5swltzI5Vm7LjsCy8s0gemFiAT52/3K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/491] ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()
Date: Mon, 13 Apr 2026 17:55:31 +0200
Message-ID: <20260413155822.263173223@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
index 0418febc5cf20..6ed849172167a 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1755,7 +1755,7 @@ acpi_status __init acpi_os_initialize(void)
 		 * Use acpi_os_map_generic_address to pre-map the reset
 		 * register if it's in system memory.
 		 */
-		void *rv;
+		void __iomem *rv;
 
 		rv = acpi_os_map_generic_address(&acpi_gbl_FADT.reset_register);
 		pr_debug(PREFIX "%s: map reset_reg %s\n", __func__,
-- 
2.51.0



