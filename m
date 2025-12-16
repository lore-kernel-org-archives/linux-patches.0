Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C5334F270;
	Tue, 16 Dec 2025 11:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885658; cv=none; b=pg1e8iuYN7PafxY7xHDKBaeSc9TpsmIcuNRn+MOeFvqKC1ceHhohFBtB7bSnef0dAfLhoKBOhUkZJuKQ3k7W9OA7D16kdE+0/ONE8TUg9+SKlrE1JWLwvNdtLyo72wCgeEXQpe9UwvnbcnzIv/AtU2W9Q8Lefm6IRdpHhdmAofA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885658; c=relaxed/simple;
	bh=YuUQnVRQ0Lxzm9jwmr+SwL8Rkg2VgKl86RAeBjK2aXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfEUNgKtvyN1gff1rubKVS4X9NDPnGZe/HsC53hA+lNaBdpxJXMeWLmIj/mPTJCP+I/5SMzbAHKGget7HGxPKoDNMogTDz8okqjlm+BF6TSWBCxJaQHl/iK4ujLSkIwpnMKqt+SXjna2rTlNIR/+Eup8aBqNKBC+LH7Xn+FWocs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2xF2xY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2xF2xY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0BBC4CEF1;
	Tue, 16 Dec 2025 11:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885658;
	bh=YuUQnVRQ0Lxzm9jwmr+SwL8Rkg2VgKl86RAeBjK2aXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2xF2xY/7FxtS/JHnTUU+HYkvm8sZtpJlZlyHYHVNXUCMyCAr2mXsA/qWOKLyNmBe
	 PsUsuSgNkaH8A1dL0HsOai+47tA8RysmGKF+A3JrwNCAtpyuFDh0nHOhXwjECueJ7f
	 czV5Kr05Zc18FTFX/LSe83/1UBo6PMi35IS1Ehk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 204/507] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Tue, 16 Dec 2025 12:10:45 +0100
Message-ID: <20251216111352.902503290@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index f69a237262353..9331ee3599050 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3831,7 +3831,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
+		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.51.0



