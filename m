Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECC12EA15C;
	Sat, 17 Oct 2026 17:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257586; cv=none; b=u1MGQShztmU8lh7E9uSwmxyCBX7qVoI3oXJAMkfEApf5EXgjFebfFdiz7O6o/KTIRk1a4J5nb7VwVx4T/hzwkk7jbkyqdwdW9o4m83wBShwV0LTNKbEJpRNX10BUyt+IYh+/gEvms7SNPOmWVEmlymyUQrfoYoi8SNNLrBTkSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257586; c=relaxed/simple;
	bh=3HDFf3ezsz4ILQ9uJu5ZSrK6qRg47FYNLWoui+rUBBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B72987lj83DSzCbyeJVlayo0vCsJtGNc1OhWAMFQieFD9UKr6DyhBI3xVZRBYhVRmIRWBnEHdrsORLG6wYyjWylc+1G19E/2SccqSZtKqJf3PyNazjW8S2D1UmMZaYXXHdJKVEryzJmdXe6aFbn+BEHvD4n7NHK+e2PW3y/k6Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prN6phq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prN6phq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CE71F000C5;
	Sat, 17 Oct 2026 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257585;
	bh=ZTOI+/Bmr32Iq2UIFBqYpbGgz3a6ssam4qytNhJJOuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prN6phq7xOoXyoxs27OuQ08tQyffwFIDKxpELlGswKK7FV4rk+HLS4lbHZdRvq8Ms
	 DMPajfOPI4/BMQa62dCGJxeDyCybw9/Vj9ohrA9zewuwHCzdwsw3K0+SgRkITfugwM
	 saDCxXTuIeXXlTVRWx0AhODYrJZFjxff/56NQ/uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0605/1674] scsi: ufs: core: Add debug log for MCQ command timeout
Date: Sat, 17 Oct 2026 17:47:57 +0200
Message-ID: <20261017160446.612710054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 3abe4113e784b4a1135fe0e89828afecbfebf862 ]

It is difficult to debug situations where an MCQ command timeout occurs,
the corresponding CQ tag response is received, but the request is not
completed.  Add a one-line log to indicate when the CQ entry is abnormal.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260210070837.1820710-3-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 375f3a5691dd ("scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 90314980deed1..846d4c3eb3923 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -280,6 +280,8 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 		ufshcd_compl_one_cqe(hba, tag, cqe);
 		/* After processed the cqe, mark it empty (invalid) entry */
 		cqe->command_desc_base_addr = 0;
+	} else {
+		dev_err(hba->dev, "Abnormal CQ entry!\n");
 	}
 }
 
-- 
2.53.0



