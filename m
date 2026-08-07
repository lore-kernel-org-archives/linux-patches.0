Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270E02F1FDF;
	Fri,  7 Aug 2026 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115134; cv=none; b=I1C02VdT46OAFaBKN6SpOzp3wIxrmYTWWQTfFIlJwVlZca0fDg9bz1DadW6HuMGnpYukq/EnAJoW+Xrgk1gVs9gS4vTxrBMffIkUbz1I4OTV+pRpA91NgSecKwC5Gxpmi5VhEkw4mnhFgfZbYdVQpJwwEM2OHf5pnV0mgQDWOi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115134; c=relaxed/simple;
	bh=+UIhg4YyTI6htrC/9TCt1XDAVkIqjyCyB7jHwJVaWpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVAsnCdoOcs0VLkEVmwlRD8t/MfCDJxMP4cnxFckYyXHU8ddD1uh5Dlztnm2xEMRbkqBfyDr4u/iITuZ648w1rXEYoZDj0RSWMINOsl1p5MhKtYxtj6r4cES5m74W4BNlEJUuHAyTboshDadYIvIXgvdXNq5zF/48Dp5xEtB1NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlDTJaoT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlDTJaoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9BB1F000E9;
	Fri,  7 Aug 2026 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115133;
	bh=BbiiuQBgRv/RJyXHV0G56WmX33JcJeCq5B7LEPs+228=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlDTJaoTGb1+NTjDbbqk6Wrsnx7oL4Q+nMXGHqh8Xt1w20TLcW4MxdK3UGpk6js18
	 1kcfxsTcmPj2J4HNMlge9Q9GlnabInga8oo+Yd17LIlXKRc54dugOMXha1br5sTc0T
	 S4QgTYX7Gh3pparrvXtPK+aYSJszvAWt6vJfVdfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/396] accel/qaic: use sizeof(*trans_hdr) for transaction length check
Date: Fri,  7 Aug 2026 16:35:02 +0200
Message-ID: <20260807143427.372738487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit d6c075f797a672a6e3bd2fd44aee713801698ec2 ]

In encode_message() the per-transaction lower-bound check compares
trans_hdr->len against sizeof(trans_hdr), i.e. the size of the pointer,
instead of sizeof(*trans_hdr), the size of struct qaic_manage_trans_hdr.

Every other length check in this file (encode_message() at the loop
guard, decode_message(), etc.) correctly uses sizeof(*trans_hdr), so
this is an inconsistency. On 64-bit builds the pointer and the struct
are both 8 bytes, so the check is correct by coincidence and there is
no behavioural change. On 32-bit builds the pointer is 4 bytes, which
weakens the minimum-length check below the 8-byte header size.

Use sizeof(*trans_hdr) so the check validates against the actual
transaction header size on all builds.

Fixes: ea33cb6fc278 ("accel/qaic: tighten bounds checking in encode_message()")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260617212520.59801-1-meatuni001@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_control.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/qaic/qaic_control.c b/drivers/accel/qaic/qaic_control.c
index 8eae30fe14f98..8759b53ba38eb 100644
--- a/drivers/accel/qaic/qaic_control.c
+++ b/drivers/accel/qaic/qaic_control.c
@@ -782,7 +782,7 @@ static int encode_message(struct qaic_device *qdev, struct manage_msg *user_msg,
 			break;
 		}
 		trans_hdr = (struct qaic_manage_trans_hdr *)(user_msg->data + user_len);
-		if (trans_hdr->len < sizeof(trans_hdr) ||
+		if (trans_hdr->len < sizeof(*trans_hdr) ||
 		    size_add(user_len, trans_hdr->len) > user_msg->len) {
 			ret = -EINVAL;
 			break;
-- 
2.53.0



