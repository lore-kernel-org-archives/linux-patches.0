Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96808264FB6;
	Tue,  8 Apr 2025 11:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110578; cv=none; b=jnRaAtFZcTZgLc57bwShhaovDYLuMC/2QfaNXMIun+JKK2bZCzyvboSntG2LS2inZjLDHkNsKrJuJW9/TUyumjFYOPeFV67aqpYJ1hFNyijHEDKeNR1GcZTtEmYqWI42cOyJ1otBma8SfCecFVee7P0NTvYtIl4DRV+05s5dJkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110578; c=relaxed/simple;
	bh=3tXvpb2J88DdxIR4K4rppUQFNmc5aWwc/vX2qm/ymSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIABnMrJT/yCGR03vghCcFswQrryovqS8gImGCUS8Ov4oyADp2IdksHECuFyTsWtdIeNIVL4fu8C6CaWR5TtEy85wjgRuq17vhxjTEskXzTb7Yk+JnIZMVOWHDw+H33DFaoBJEbzBEbpCVotfL4feOLrsgyBAI+VPn8AkMtGZ28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQANpWbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQANpWbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AE8C4CEE5;
	Tue,  8 Apr 2025 11:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110578;
	bh=3tXvpb2J88DdxIR4K4rppUQFNmc5aWwc/vX2qm/ymSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQANpWbc5KB2Y9d8Pia0ho3NlRc8vFqJJP2CocRADXxEjMymydT2FEaObrx15nCT9
	 kfLnqWtI5XIGKBJUfMj3Jt5XcflVh0iLuD23VYCgBaLgYpus8EYS+DVSRObw7NJN0x
	 yNrmE+PwpD0iZGzXy+RKntZTCnfWt+JOgynodtXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Homescu <ahomescu@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 115/731] firmware: arm_ffa: Explicitly cast return value from NOTIFICATION_INFO_GET
Date: Tue,  8 Apr 2025 12:40:12 +0200
Message-ID: <20250408104916.952266121@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 3e282f41585c4dd49b688bd6395fd6f21a57c9f7 ]

The return value ret.a2 is of type unsigned long and FFA_RET_NO_DATA is
a negative value.

Since the return value from the firmware can be just 32-bit even on
64-bit systems as FFA specification mentions it as int32 error code in
w0 register, explicitly casting to s32 ensures correct sign interpretation
when comparing against a signed error code FFA_RET_NO_DATA.

Without casting, comparison between unsigned long and a negative
constant could lead to unintended results due to type promotions.

Fixes: 3522be48d82b ("firmware: arm_ffa: Implement the NOTIFICATION_INFO_GET interface")
Reported-by: Andrei Homescu <ahomescu@google.com>
Message-Id: <20250221095633.506678-2-sudeep.holla@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index ce1ec015e076b..25b52acae4662 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -899,7 +899,7 @@ static void ffa_notification_info_get(void)
 			  }, &ret);
 
 		if (ret.a0 != FFA_FN_NATIVE(SUCCESS) && ret.a0 != FFA_SUCCESS) {
-			if (ret.a2 != FFA_RET_NO_DATA)
+			if ((s32)ret.a2 != FFA_RET_NO_DATA)
 				pr_err("Notification Info fetch failed: 0x%lx (0x%lx)",
 				       ret.a0, ret.a2);
 			return;
-- 
2.39.5



