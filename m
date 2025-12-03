Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9718B32E75C;
	Wed,  3 Dec 2025 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777064; cv=none; b=dXdY8KlmSzzxRHYmFpzZ7oV6DE8a9wwGB1gTzIE1DddnxIcgGi3lCX/5cNtROKA656zCRt2R4t9+sDfuPYYUMHGBjn7HLo2F/X7QBW4n+Yedl2F9kyrJutMtjkWc9uAW+1OXZqZqdOPQHv7zrQo07xwqIX0MUlg5Jt8VU2ySI1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777064; c=relaxed/simple;
	bh=tSRQB9EEMpXUmM2E+LP2FU+fVWZSZjxEEq+KAHsUqVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L41q4V+/QGHm4reVMuhFyVgJAkZKPDb3152zL+ke9sJPygmU77sSFvzW+MaLwynpUDvpJeqOwYADYLTbPa46wItm74vk60ODNFl76vXdmWCZfiDlzbj8Pk/T98oj/mPrhUuOVwIV7zUm19ICUo6fRl/pLnebaBQ5fQurYCqm9lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ly5rrSrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ly5rrSrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA74C4CEF5;
	Wed,  3 Dec 2025 15:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777064;
	bh=tSRQB9EEMpXUmM2E+LP2FU+fVWZSZjxEEq+KAHsUqVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ly5rrSrJwnKmmAMIeerc9RoUvYnO9EcT698nUBCTUFaDBpTujcaKmrr9RLInqZzym
	 hUc5QpywoxaIlSfSk8WxhD7UTRA06bzdMmNaeJRqchqcIyf+t8iQJkqT2/YxSZw6SM
	 Ci0QMMTqRZ8ISHencUJiEJ9Wxc1O3h79A4LwFhdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Iles <jamie.iles@oss.qualcomm.com>,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 038/146] mailbox: pcc: dont zero error register
Date: Wed,  3 Dec 2025 16:26:56 +0100
Message-ID: <20251203152347.868560220@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0a00719b24827..ff292b9e0be9e 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -276,9 +276,8 @@ static int pcc_mbox_error_check_and_clear(struct pcc_chan_info *pchan)
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
@@ -745,7 +744,8 @@ static int pcc_parse_subspace_db_reg(struct pcc_chan_info *pchan,
 
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



