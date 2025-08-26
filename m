Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27D02BE058;
	Tue, 26 Aug 2025 14:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217279; cv=none; b=GzULSxugOrF9EgnYnkcALPW+hpWi9MZM/k2b6wrRP2DiUQfjEid8B9MjHCSuAPxcUDaho/8tulfMPprSWpvWqUp3PGoDQpFcY1AEwsHVDUL6fAFFjMTJqI1h0b5E5MVtWJ0fe6xLZVHyXZj/ddkjFpeVpr25ZobkLuQzng7Fwh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217279; c=relaxed/simple;
	bh=xE3qvhymuQnaeQ7rPqnGqCt73bX1lBY5G1zfSjylw50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9sxLIbHHPV6qVlkpDOWHQwXptSb1fXp43h18kwTptv6TUxiLk9jtJo7/8guYvH10DX2AgyVOtRtJdrtT8x/LIhJeEHI0UjRZzy/Z3C/4uxzdn9QIYwa+SNJo4/fPqDjMKSDfSLiG6nu0CB6t8pUuIF6SliWqin8hn6IKaBNTQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCHY68j6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCHY68j6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB492C4CEF1;
	Tue, 26 Aug 2025 14:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217279;
	bh=xE3qvhymuQnaeQ7rPqnGqCt73bX1lBY5G1zfSjylw50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCHY68j6oz8bbd+HznrtYL/HLx0gnz5Eh27yrfYTUAwtDftpc7rYLYX5AnDREK1et
	 GRYatUJ2hSxrVafCLXbPG7nxiZtYxCcxNh5gEgt9wcfk5mmpLqVhhdYnY7g4Rbo8m6
	 Wk6GiS5oK4L0uHWaKWchT/VnAKQK0KwLKV3nwuO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Kowalski <jacek@jacekk.info>,
	Simon Horman <horms@kernel.org>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 066/523] e1000e: disregard NVM checksum on tgp when valid checksum bit is not set
Date: Tue, 26 Aug 2025 13:04:36 +0200
Message-ID: <20250826110926.205998142@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
@@ -4144,6 +4144,8 @@ static s32 e1000_validate_nvm_checksum_i
 			ret_val = e1000e_update_nvm_checksum(hw);
 			if (ret_val)
 				return ret_val;
+		} else if (hw->mac.type == e1000_pch_tgp) {
+			return 0;
 		}
 	}
 


