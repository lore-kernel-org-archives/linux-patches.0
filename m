Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D382FA0FD;
	Tue, 12 Aug 2025 17:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020281; cv=none; b=aJSoaFTgBrHtbvNB1tjNmL0E1V7R0L/s8Pul0A4ZVujRhXNaCuRZeRZ+oTjbBbuLi62PwrGZt+oirkSC0ZLG7+vg4PSIF05SlhlgLndRKEFS5599xI3y+tjawIZOEdC5oZQu79EO8bF4U8udDsed5soqIw0JKYskp5foHJbZCXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020281; c=relaxed/simple;
	bh=6TTAOKQNxvEsg59VOmjp3OAIIPegXV8aHEmI1qJaq2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnvSBiYwIa5SfiTdKPdTGRs3MIWo6pzElO7hVn33515DxmqQPD/3p15+Sst/XeuqiCvs7Bi3KSMMQ49J8lqHI7gNb6G9D6bFkP2+//bqONbyNp89/s00duA6DbPZP9myd6DHWo/kQ5qji752ayr3I7KiHu2kN8Q7KTG72Gxx25M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DguTJ4q0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DguTJ4q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53730C4CEF0;
	Tue, 12 Aug 2025 17:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020280;
	bh=6TTAOKQNxvEsg59VOmjp3OAIIPegXV8aHEmI1qJaq2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DguTJ4q0D2wzZLBO8WbfX/6Z2QLXtIslZGzlKVkEul2LfLj3+zOhKg8js5T8mmKS+
	 +2k2SdAq77jbfzOkU6MGNYe2PQhFQlctyFSGGNpkgGQ8BeFfe4+5vicNumkKmNEUuy
	 pO6rV0cSFAa5BPkVK9Yi0JFEXyKIhwmmv0MGL/oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Kowalski <jacek@jacekk.info>,
	Simon Horman <horms@kernel.org>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 034/253] e1000e: disregard NVM checksum on tgp when valid checksum bit is not set
Date: Tue, 12 Aug 2025 19:27:02 +0200
Message-ID: <20250812172950.182318592@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Kowalski <jacek@jacekk.info>

commit 536fd741c7ac907d63166cdae1081b1febfab613 upstream.

As described by Vitaly Lifshits:

> Starting from Tiger Lake, LAN NVM is locked for writes by SW, so the
> driver cannot perform checksum validation and correction. This means
> that all NVM images must leave the factory with correct checksum and
> checksum valid bit set. Since Tiger Lake devices were the first to have
> this lock, some systems in the field did not meet this requirement.
> Therefore, for these transitional devices we skip checksum update and
> verification, if the valid bit is not set.

Signed-off-by: Jacek Kowalski <jacek@jacekk.info>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Fixes: 4051f68318ca9 ("e1000e: Do not take care about recovery NVM checksum")
Cc: stable@vger.kernel.org
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -4146,6 +4146,8 @@ static s32 e1000_validate_nvm_checksum_i
 			ret_val = e1000e_update_nvm_checksum(hw);
 			if (ret_val)
 				return ret_val;
+		} else if (hw->mac.type == e1000_pch_tgp) {
+			return 0;
 		}
 	}
 


