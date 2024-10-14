Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5E939FCE;
	Mon, 14 Oct 2024 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916677; cv=none; b=IyKQ2jm79aRNvZQElDLAM5gFNm0c1G5uO9c8D6HWYKII2w6sV3lG8gLGBCQvpGp+3RFDAnIn4cYN5r8paJ6C/Y2Thyp7HMxcGpX1rzA4j84NUh3vcF7/WnAERPvAa9OPG8nrvN37ArM9S2hYaWpPlALTgz6dW+Xeo2ES2NFeQdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916677; c=relaxed/simple;
	bh=r2fy/UptG0vmJKytxheZ7hcFcHDcvbS2b0m8Kxuggd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZrVwpbI01w/ctdBNjNq7C/Dnxp+ezLRwPBMOe2Dn0ItcJIRfQBfqvLHvdkhdyUlKXFjgU8dDzLEZ44ZK2k4RxzyXFcdEn7bmlBipSMNoqSOUxXT5heMnpKGW7Y2M4cFmnuztwr02bO5bDmimt2lKgCvHfTroOFq5PI+je+kPG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8xfx1EY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8xfx1EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469E1C4CEC3;
	Mon, 14 Oct 2024 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916676;
	bh=r2fy/UptG0vmJKytxheZ7hcFcHDcvbS2b0m8Kxuggd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8xfx1EY0KsK2qAXPRu8ZUVWm/69703XBtFzjkFnxPACRLUXQiDMQ3KqxH75tpwsF
	 CHMOSakm3CrPjESW0mTVncZEMkGCkQNmBVAA0KgH5Ma84d7uPpGRDfXr9D2tWaVhYg
	 teYLH8AQavKTPHIQCUC9xmeyH922ZM3+nwiqH/u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Zaharinov <micron10@gmail.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH 6.6 033/213] i40e: Include types.h to some headers
Date: Mon, 14 Oct 2024 16:18:59 +0200
Message-ID: <20241014141044.281897623@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tony Nguyen <anthony.l.nguyen@intel.com>

[ Upstream commit 9cfd3b502153810b66ac0ce47f1fba682228f2d2 ]

Commit 56df345917c0 ("i40e: Remove circular header dependencies and fix
headers") redistributed a number of includes from one large header file
to the locations they were needed. In some environments, types.h is not
included and causing compile issues. The driver should not rely on
implicit inclusion from other locations; explicitly include it to these
files.

Snippet of issue. Entire log can be seen through the Closes: link.

In file included from drivers/net/ethernet/intel/i40e/i40e_diag.h:7,
                 from drivers/net/ethernet/intel/i40e/i40e_diag.c:4:
drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h:33:9: error: unknown type name '__le16'
   33 |         __le16 flags;
      |         ^~~~~~
drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h:34:9: error: unknown type name '__le16'
   34 |         __le16 opcode;
      |         ^~~~~~
...
drivers/net/ethernet/intel/i40e/i40e_diag.h:22:9: error: unknown type name 'u32'
   22 |         u32 elements;   /* number of elements if array */
      |         ^~~
drivers/net/ethernet/intel/i40e/i40e_diag.h:23:9: error: unknown type name 'u32'
   23 |         u32 stride;     /* bytes between each element */

Reported-by: Martin Zaharinov <micron10@gmail.com>
Closes: https://lore.kernel.org/netdev/21BBD62A-F874-4E42-B347-93087EEA8126@gmail.com/
Fixes: 56df345917c0 ("i40e: Remove circular header dependencies and fix headers")
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20240117172534.3555162-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h | 1 +
 drivers/net/ethernet/intel/i40e/i40e_diag.h       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 18a1c3b6d72c5..c8f35d4de271a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -5,6 +5,7 @@
 #define _I40E_ADMINQ_CMD_H_
 
 #include <linux/bits.h>
+#include <linux/types.h>
 
 /* This header file defines the i40e Admin Queue commands and is shared between
  * i40e Firmware and Software.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_diag.h b/drivers/net/ethernet/intel/i40e/i40e_diag.h
index ece3a6b9a5c61..ab20202a3da3c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_diag.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_diag.h
@@ -4,6 +4,7 @@
 #ifndef _I40E_DIAG_H_
 #define _I40E_DIAG_H_
 
+#include <linux/types.h>
 #include "i40e_adminq_cmd.h"
 
 /* forward-declare the HW struct for the compiler */
-- 
2.43.0



