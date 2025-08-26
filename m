Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9BB34A325;
	Tue, 26 Aug 2025 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218753; cv=none; b=ku2kGqv4EhQIHzUV4/3edV3ooy83teerBTt1DPA5PvDNS5Xy6I4HmOO8N6g7a4IeXK/Xa4x18kc5XtZSPpzFR/69fLDr1b9pgYNebJdnrdMo/b8cY5MUAPngLDIb144u8HrjJ3ZUUhUDDOzVl8eENwTWtvI5HOKgL/IxWeRO3Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218753; c=relaxed/simple;
	bh=/pX1RvXR9XeVPiiTacPGPWtN6OLCt3oLF55y2SOrE3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfnB5DGqnw6JyJh/HXZRWka0Uwd5PpDBgszxN5tmNX+84G5mk/QFPTE7Z9plz8RH6d5UPwNtYf9kdGqFUgoo34wZQlcHpLkPVFSYHmc3domNVXw77wU6hR1cCZogqr8KWsVE49QNvJaAHgJo01zY1n5IejplVBnP5+5CVxws9MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOZl3GvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOZl3GvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B669C113CF;
	Tue, 26 Aug 2025 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218751;
	bh=/pX1RvXR9XeVPiiTacPGPWtN6OLCt3oLF55y2SOrE3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOZl3GvSsyKgqmUAsm2s2qEUpecqaftmiUdzQDBE91XI4BMlUEZEvJ6+n1VaHN0Gq
	 8NcXytjqT6snZlpQbiJb5qEhtV435OAYhfbRIoHhdOwp2KiyJ4kfMYi/thA6dXLgcG
	 jsrq4uzvtOUxQhXdnYdEaebk30qIxGHEnYHkIRYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/403] wifi: iwlwifi: Fix memory leak in iwl_mvm_init()
Date: Tue, 26 Aug 2025 13:06:54 +0200
Message-ID: <20250826110909.094544661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit ed2e916c890944633d6826dce267579334f63ea5 ]

When iwl_opmode_register() fails, it does not unregster rate control,
which will cause a memory leak issue, this patch fixes it.

Fixes: 9f66a397c877 ("iwlwifi: mvm: rs: add ops for the new rate scaling in the FW")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://patch.msgid.link/20221109035213.570-1-xiujianfeng@huawei.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 18c5975d7c03..70ba91d2bedf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -123,8 +123,10 @@ static int __init iwl_mvm_init(void)
 	}
 
 	ret = iwl_opmode_register("iwlmvm", &iwl_mvm_ops);
-	if (ret)
+	if (ret) {
 		pr_err("Unable to register MVM op_mode: %d\n", ret);
+		iwl_mvm_rate_control_unregister();
+	}
 
 	return ret;
 }
-- 
2.39.5



