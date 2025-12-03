Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCE931D38F;
	Wed,  3 Dec 2025 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780297; cv=none; b=L3L/5hEdL4EKDcSsB4wsCpUKsaWHfOwiMTwiaxfj9Fa4L/y/erBe4+PpdPxwc2bUw2Od+n9HoHXNdvSn+Owi/M/lEDHf59s7Pf6F8pPp8icl1Zadr8n0V26N1BhvzItm5iqaCqOTfmmTRYg6yirMVCZQExtFZvbPwi4W4kqKgfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780297; c=relaxed/simple;
	bh=kv8lLp+0MfiS8LmmbXdVW5ZquUA03phRf8PbXmkM4y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnS9+wC8tFZWQFVp3af/PSTCK8CyR3ZRHLhs2veylwSTy0TFKlEvnaNjabZdO1Ct2Ks7MnNypxVKA/AAou+vqbR6D+SBBq6k/ro0X/HLI9Rgtq2WYchHIrw/eoebKpzryWS53I17/w2ZN6PLhYwWXDUwJxACyZIyWRxF2RAPjh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8UYDy0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8UYDy0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A557C4CEF5;
	Wed,  3 Dec 2025 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780296;
	bh=kv8lLp+0MfiS8LmmbXdVW5ZquUA03phRf8PbXmkM4y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8UYDy0PQ04OuDuI8gVV1O2W1wFdR4w+P9Sjtsg3K/2Zn8CE8g7jfBRJ9XBsfZycQ
	 gyf8YnAQKoKCGj8ozH5Mc+A9HE1FCv5y7bXJIgkjModcA19h71GhOth+Y3LUZU6BkV
	 WeqGv/jLy8hi+OhcRyJW1VI5r49ohtqcP1f6p2PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Iles <jamie.iles@oss.qualcomm.com>,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 514/568] mailbox: pcc: dont zero error register
Date: Wed,  3 Dec 2025 16:28:36 +0100
Message-ID: <20251203152459.540710841@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Iles <jamie.iles@oss.qualcomm.com>

[ Upstream commit ff0e4d4c97c94af34cc9cad37b5a5cdbe597a3b0 ]

The error status mask for a type 3/4 subspace is used for reading the
error status, and the bitwise inverse is used for clearing the error
with the intent being to preserve any of the non-error bits.  However,
we were previously applying the mask to extract the status and then
applying the inverse to the result which ended up clearing all bits.

Instead, store the inverse mask in the preserve mask and then use that
on the original value read from the error status so that only the error
is cleared.

Fixes: c45ded7e1135 ("mailbox: pcc: Add support for PCCT extended PCC subspaces(type 3/4)")
Signed-off-by: Jamie Iles <jamie.iles@oss.qualcomm.com>
Signed-off-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 94e99b87496d2..0729988467554 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -278,9 +278,8 @@ static int pcc_mbox_error_check_and_clear(struct pcc_chan_info *pchan)
 	if (ret)
 		return ret;
 
-	val &= pchan->error.status_mask;
-	if (val) {
-		val &= ~pchan->error.status_mask;
+	if (val & pchan->error.status_mask) {
+		val &= pchan->error.preserve_mask;
 		pcc_chan_reg_write(&pchan->error, val);
 		return -EIO;
 	}
@@ -662,7 +661,8 @@ static int pcc_parse_subspace_db_reg(struct pcc_chan_info *pchan,
 
 		ret = pcc_chan_reg_init(&pchan->error,
 					&pcct_ext->error_status_register,
-					0, 0, pcct_ext->error_status_mask,
+					~pcct_ext->error_status_mask, 0,
+					pcct_ext->error_status_mask,
 					"Error Status");
 	}
 	return ret;
-- 
2.51.0



