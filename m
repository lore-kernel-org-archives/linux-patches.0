Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA66F2957AC;
	Wed, 30 Jul 2025 09:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868704; cv=none; b=MQaO6EENtjL1sQ7j3EMwRN3ag5z78v4as8lZ11hPtH1Bed4L74jnQfF9XAzcnVtK8Z31J0XnGV0nbhd4+s9FGe6BvK5FZSKtJW4wQAFTD0pT+UJD6kowf8vNhYePLwdbRyzIy5QuZiR6net8ba76FAISgmYP/7D4e1zBIMWTUYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868704; c=relaxed/simple;
	bh=OIlD6iW3pCdiXIexBQZmXN2bPW/ZilHaUzfKnceyVdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrwOib3Pxep4YZcI1K/GF0W+wAtllKdAHkeUIEPkHz4g7HEAGr987USaHFjQxr17M5y0/7/QxyFuIZOmJyOqo22JW0xlyf2uc+P9uhzqA4+y+V9cHtsaIKypTx6RZ9n0IgAdousJHmtQsu5MJMFzeErDnQqnDD+KN0TWHvMS118=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kcMS0WC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kcMS0WC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB36C4CEF5;
	Wed, 30 Jul 2025 09:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868704;
	bh=OIlD6iW3pCdiXIexBQZmXN2bPW/ZilHaUzfKnceyVdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kcMS0WCZRqwoU04EfaXJfd1WGyWWPam8cO8lvhbNbo9JLw+hPebokIp91664O963
	 /pRya+8JxNLMfSydEefdW7ooR6e516iPuaYlRisOkdTKIRpZsjaJIIe+yqI+svY63z
	 s1p2+d2Hen2XP7UgGDGRz1vyh+IkCsGKhsKY0+UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Kowalski <jacek@jacekk.info>,
	Simon Horman <horms@kernel.org>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.12 056/117] e1000e: disregard NVM checksum on tgp when valid checksum bit is not set
Date: Wed, 30 Jul 2025 11:35:25 +0200
Message-ID: <20250730093235.737091738@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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
@@ -4274,6 +4274,8 @@ static s32 e1000_validate_nvm_checksum_i
 			ret_val = e1000e_update_nvm_checksum(hw);
 			if (ret_val)
 				return ret_val;
+		} else if (hw->mac.type == e1000_pch_tgp) {
+			return 0;
 		}
 	}
 


