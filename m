Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6208B26E71A;
	Wed, 30 Jul 2025 09:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869335; cv=none; b=bMY76V/IVMqW3FStnto01ULVIm7l0LLsmQs/v/QOtQnl4T2ruQHIVbyVqlZbdfdWrYOj3z0gL5qQKzV1ordg1Kp6wKZ3po6aOvqWqP8c4m5ADdPjZ3Z7G1j/u/VTiADnL1erW6fsaUCFfcbk9io2LOOZVBEZRlqczLesaxKtu18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869335; c=relaxed/simple;
	bh=Jld5m5RUZizbLmVkJO4RRLSl9zzBBT4t1MZyeIrNPtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlRTZlFIWneWNdmxERWVQZJ5hMhOgPG3ymBRtIv3iM+lRtnBVHdxwdtUx4qRUxG5vPR59gmvthJnK7mGt73Hx6GavaPFNzEDvofHp/yHdJB9HlkrKgvNil5R6QNcbWLGnQwBP+0SaGOCj1TvTQjbb/GnfWBGnuzNxXoCIe0jX9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFc/nhq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFc/nhq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C25C4CEF5;
	Wed, 30 Jul 2025 09:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869335;
	bh=Jld5m5RUZizbLmVkJO4RRLSl9zzBBT4t1MZyeIrNPtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFc/nhq0KFWpDQPa6BhJevLxhKA3Qatrl/l6C/hgFdibsFLyowtZdb42FF6eegvUl
	 qteZUlwdDIj9HtahtznGk+DoXm7tL5wpab4u/I/Qx+5pgbgt6MvYdUAbC8Khum4n+p
	 uvOf+O8BSBJ4kH+20v5lyN4HptU+JnJjb9C89Hls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Kowalski <jacek@jacekk.info>,
	Simon Horman <horms@kernel.org>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.15 67/92] e1000e: disregard NVM checksum on tgp when valid checksum bit is not set
Date: Wed, 30 Jul 2025 11:36:15 +0200
Message-ID: <20250730093233.345647128@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 


