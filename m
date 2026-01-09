Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C81233290A;
	Fri,  9 Jan 2026 11:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959687; cv=none; b=OID8pEBnT2OisRWvxoIf0T6NlEOxn5w7ETkjXKjG8iiyPkqnOqNI2NXqyab5lwt1uh9aH+K/xpkLtoPJ/lVXQFAMIqXy9bRKxp118V871MtpelxdilO/790Bfh7Z7EDlxmv8bzy7pAMf4NSnPHJayidaIMbmwTvPv9CBvCo8JS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959687; c=relaxed/simple;
	bh=kG90H2qMi1des/07A/gZ/D1LRTyy8KEbJ5f/JJy7r1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEpzY4UaC63ZCw2RebD0OFpgox3NM8s46l+WxKNhX3HCJ+J5w403NSX2mH0gTUGHCYvYBVYFrKjxgE0JGV/6Kv6wwH2RRCXIer454EnPi3zf22pNCRRKhxxPLxVlmlynVK3rZHZCMwsw612+Ps+BGHg0s5qAekSTPyeMvwqO5S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuSLYTkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuSLYTkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3B6C4CEF1;
	Fri,  9 Jan 2026 11:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959687;
	bh=kG90H2qMi1des/07A/gZ/D1LRTyy8KEbJ5f/JJy7r1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuSLYTkw97+HnlsbD22QU8noDh3mmn3MN8NWR7Vbe1ikvLiMoxdwSroaiWHMUqWTs
	 Op47/wnSwz5+dC4DPchwCAebr8BQeLFwGCa87Vunwe6c6CDqDqretNwcIGQUNavyfM
	 V4uYoE8Ryitii73JNdSKWNil30tjzdh/+FMuzk4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/737] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Fri,  9 Jan 2026 12:34:37 +0100
Message-ID: <20260109112139.191487677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit d794b499f948801f54d67ddbc34a6eac5a6d150a ]

The function ufshcd_read_string_desc() was duplicating memory starting
from the beginning of struct uc_string_id, which included the length and
type fields. As a result, the allocated buffer contained unwanted
metadata in addition to the string itself.

The correct behavior is to duplicate only the Unicode character array in
the structure. Update the code so that only the actual string content is
copied into the new buffer.

Fixes: 5f57704dbcfe ("scsi: ufs: Use kmemdup in ufshcd_read_string_desc()")
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Link: https://patch.msgid.link/20251107230518.4060231-3-beanhuo@iokpp.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 01a7c1720ce15..9d6a47abe4bc6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3738,7 +3738,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
+		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.51.0



