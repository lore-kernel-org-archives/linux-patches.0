Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A6546AA7B;
	Tue, 21 Jul 2026 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648211; cv=none; b=pmLjUO/wxlRMZCI2Zlq7U4V2UPTDwHm9asF7Flzs7qIsTRiwW+UY7afPTIK+yoHIMY0FFlSXwLhEEXcraZNGnuK/y5DO8g7vJgmlbFpTVOdMUDL0LCTeMyMNz7gEPB7VZmgwN5QGgr0ubdD8oOZNBR9r1xc2893ruV7MS5MeJFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648211; c=relaxed/simple;
	bh=89l2ax0JuY8XIMMUpQFy1gdQF5hWW/eqHvEGAcYt7Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8jBA2xyhkqhlGQXyd5JLg9V80fAwGyflYNz+O83tsgdmOECrEoW8pmlGaeNuIvaOMCV7fr9d3YDBQRPUqfRkKn0XPBSHJs6xZn69iGHkojPwmiWbPEM3U6634UjrADb9/g85Ws48/xiHlxZlsnCPN/4BCXxDZ2iVCOwPYq4iGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AS3yPYUL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AS3yPYUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FEF1F000E9;
	Tue, 21 Jul 2026 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648208;
	bh=Hxch1lGYZijd9EJhTKpLfGpvQSyjK3V5WTpGnTWGyAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AS3yPYULy2nYzDXEM4jEQkvgYoyJYnKLELiXU0U+efAa0XGFz+RrqlNx+MVcrOHUj
	 ppsomTlaAJ5/kRNsZmzxX5BHiLHrJ9OTIog4OADxGSJcd6Ttm0MEuorTRCa/RrtsZk
	 EDM0sO/kW2Qa9/Y+pOeqjJFT4TnfmBXBDA0LsvNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Rinitha S <sx.rinitha@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0112/2077] ixgbe: fix unaligned u32 access in ixgbe_update_flash_X550()
Date: Tue, 21 Jul 2026 16:56:25 +0200
Message-ID: <20260721152555.337154810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit eae23ec14a9c83b6af9bd616f3b86163688e2688 ]

ixgbe_host_interface_command() treats its buffer as a u32 array. The
local buffer we pass in was a union of byte-sized fields, which gives
it 1-byte alignment on the stack. On strict-align architectures this
can cause unaligned 32-bit accesses.

Add a u32 member to union ixgbe_hic_hdr2 so the object is 4-byte
aligned, and pass the u32 member when calling
ixgbe_host_interface_command().

No functional change on x86; prevents unaligned accesses on
architectures that enforce natural alignment.

Fixes: 49425dfc7451 ("ixgbe: Add support for x550em_a 10G MAC type")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Fixes: 6a14ee0cfb19 ("ixgbe: Add X550 support function pointers")
Tested-by: Rinitha S <sx.rinitha@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260430-jk-iwl-net-next-2026-04-30-v1-9-6f27ae1cd073@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h | 1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 61f2ef67defdde..eb5bf3b6bbb522 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -2798,6 +2798,7 @@ struct ixgbe_hic_hdr2_rsp {
 };
 
 union ixgbe_hic_hdr2 {
+	u32 buf[1];
 	struct ixgbe_hic_hdr2_req req;
 	struct ixgbe_hic_hdr2_rsp rsp;
 };
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index 76d2fa3ef51825..4a0ccbf448a2ad 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -1228,7 +1228,7 @@ static int ixgbe_update_flash_X550(struct ixgbe_hw *hw)
 	buffer.req.buf_lenl = FW_SHADOW_RAM_DUMP_LEN;
 	buffer.req.checksum = FW_DEFAULT_CHECKSUM;
 
-	status = ixgbe_host_interface_command(hw, &buffer, sizeof(buffer),
+	status = ixgbe_host_interface_command(hw, buffer.buf, sizeof(buffer),
 					      IXGBE_HI_COMMAND_TIMEOUT, false);
 	return status;
 }
-- 
2.53.0



