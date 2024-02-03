Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0251BDE2;
	Sat,  3 Feb 2024 04:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933790; cv=none; b=hV6Su6Az6V+jVmubVrR4CHivHxnJE/LbWNYC3z6rGAmlZxcSB7r0dJXOLpMzVDDmcytp2KJyRkudlg/GHckVO+gJ7EUHPc6KwfjU43uBzk7Uu8IT4Q40qt3zvj2wFsse46q7IGhpkpw3qmm00aVq6Q3pFVVcVCvvtwy+IoQjfog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933790; c=relaxed/simple;
	bh=zhQ3KfCcZNdY5LrOm14HRInbaNQKHTBoGNbXEIyk3rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxsEq1DQ5+WRWYD0zcF746XlGeZxMZeDvdFzCo16WJ6NM6XroJJ6WGqNZdODN53NS2UP/OEQe1kqQHJZDAlX605r10c7cZZ8EKQpWoabvyfPPFpgNoCNirVXBkepjGgqygKzcASXAybBYxZQw2oPwcW5+olj6VX9uhduaPXXXlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4yTIik6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4yTIik6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07834C43390;
	Sat,  3 Feb 2024 04:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933790;
	bh=zhQ3KfCcZNdY5LrOm14HRInbaNQKHTBoGNbXEIyk3rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4yTIik6EVms/lGJwuZzMIkcgwnoMa6b2NDWlM/FAP8jaXv4jrPvRvWegn8OeaNlF
	 70hYnZ9oJQhJXJASJo/U3zIM/8xYqZdzQis8rjhU7yJ/76W4Kw2CP1oZB5Us99Vl87
	 Daph+/LdPh7OipWpCHYuPLvp98BcuX91pYKanUDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 099/353] scsi: libfc: Fix up timeout error in fc_fcp_rec_error()
Date: Fri,  2 Feb 2024 20:03:37 -0800
Message-ID: <20240203035406.922291129@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 53122a49f49796beb2c4a1bb702303b66347e29f ]

We should set the status to FC_TIMED_OUT when a timeout error is passed to
fc_fcp_rec_error().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20231129165832.224100-3-hare@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_fcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 3f189cedf6db..05be0810b5e3 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1676,7 +1676,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
-			fc_fcp_recovery(fsp, FC_ERROR);
+			fc_fcp_recovery(fsp, FC_TIMED_OUT);
 		break;
 	}
 	fc_fcp_unlock_pkt(fsp);
-- 
2.43.0



