Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4386282E1;
	Tue, 12 Aug 2025 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022824; cv=none; b=fWxOHEmdX1MslwbXKG3SBGYUcRMIRrNEIVO/2JPwt3U0WxfWzhQ8o2MbOF9WzpD+Y21OESwhx2NsSx2I3oMEd7vOEHPciKe0R1Hl0W75QaUD+Xp2cWWHYIxCx6lG61HmS6jV6qg8OAbNICePFnnm3MclXjdbdTQcRMh/bmfBqj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022824; c=relaxed/simple;
	bh=RHmEfLxO0QYKG3ZEuoD0Cjy++r1ZZRV6EJewZlLJ1Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvAYhS+2DV1bZmPpESnqw0toU4SfR2wVzkoJclo2vTGvGHByX5u+crzSsc/gQxYZ3SZ0dBO6rNOWibQL/PhsDjlugQAY/aBhgbqIaTjPCWqU0hQLFG5NHTo+9oDPrtqln6q2LXYJXIg1fRiMRrB+D6+Hq9Dfz0/cJzUT5aO+8U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZM/kPJ4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZM/kPJ4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40C1C4CEF6;
	Tue, 12 Aug 2025 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022824;
	bh=RHmEfLxO0QYKG3ZEuoD0Cjy++r1ZZRV6EJewZlLJ1Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZM/kPJ4uhgKRe5bgvodGOUHVDhtGfIJQ34YkJ7MD7VeB0vir13ewn6d+rodg6RI9t
	 Qk4tEWrrEQSkFEVub8n+l1dXMTbg0ZStGcqtd9ZE0HRR6kIfiNlxwHzStQmIHvBhSm
	 3ACFsng1ojrhk5P1o6TxOu1m5jsZ4mvjF3zct878=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/369] scsi: mpt3sas: Fix a fw_event memory leak
Date: Tue, 12 Aug 2025 19:29:26 +0200
Message-ID: <20250812173024.877365749@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 3e90b38781e3bdd651edaf789585687611638862 ]

In _mpt3sas_fw_work() the fw_event reference is removed, it should also
be freed in all cases.

Fixes: 4318c7347847 ("scsi: mpt3sas: Handle NVMe PCIe device related events generated from firmware.")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20250723153018.50518-1-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 9599d7a50028..91aa9de3b84f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10790,8 +10790,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		break;
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
 		_scsih_pcie_topology_change_event(ioc, fw_event);
-		ioc->current_event = NULL;
-		return;
+		break;
 	}
 out:
 	fw_event_work_put(fw_event);
-- 
2.39.5



