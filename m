Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E1D69D36;
	Wed, 21 Feb 2024 13:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521442; cv=none; b=HYEeZN7OJNsCYDCk1UhENZ/zypzQuwgdOGUdzwe1rLWaygPfFMOEKzkICJfxuNgSng07wW38FcB/hhQQqfY0iqmFgrLNuZ8OBTGa9m0dwUnep68AbZ8lVUIZDLtQl9HM9UPta2IWr0bjZAhFl4hiZ77T3wksj5baTj87f+JQ/FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521442; c=relaxed/simple;
	bh=0ObuXGYlrtfGyBC6koMOgWyaQDeMc53e9jtLw/JjbsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4gVDasf8Df4gP7zNGHS1oZ2emFfPQC3JheaRZu3fN6EpA/duumr2IxXDwJM5C08usEZRlRiVmZUTCmW5J3m4RJVlIqlum4qeDUeE+2+8TW1RyF/AdjcGMjbsVG6P47IK3CG/yoPGgYnuTwSigSZACVEN5vhwuah/0Ar5XDxfBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f89IkzYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f89IkzYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BE6C433C7;
	Wed, 21 Feb 2024 13:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521442;
	bh=0ObuXGYlrtfGyBC6koMOgWyaQDeMc53e9jtLw/JjbsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f89IkzYqBOGiYB7E2FPQF0aDWk3c/l72YpfZvdyI+VhMHzyfZhXACtZrSLl+eUfJ+
	 w2aIh8kBXxH8iK+ld4rBwfxF+gAZbxN6wcBAjXbah+u9w6k4MnNnlzIAb1a097gznC
	 8A2eWmLbcuVRZPSGL41hO6grgeU5xr99u7Q+Izs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/202] scsi: libfc: Fix up timeout error in fc_fcp_rec_error()
Date: Wed, 21 Feb 2024 14:06:24 +0100
Message-ID: <20240221125934.480165435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 119117443496..faea7333c7e8 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1697,7 +1697,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
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



