Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30A32FFDF9;
	Tue, 12 Aug 2025 18:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024959; cv=none; b=DUy8DXmWbopYQlhSmZAkb6FY8W1P4gRlfZqSYT7PzmJ7Rsm5MvHxczNvUrFcAJ4g3Ef7mHbvBZXtILpdmS0woYp/QDU++BM9Qgj99zv/OwCYqVNAT7H7qBzKxhLjpQaBW6t2cJpzJoJdaJwY5MD774tQ3Q0hmUoFLsTGdyItBLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024959; c=relaxed/simple;
	bh=Tnmua9pHuL50L/n9zww8t3DA1wLg94LEXhJdt6OjApM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAw2Zs9lL8pEhyx8VR8uTajlm3ZgAtwVtyReJhdzVt/3GrSNF1xgBYqt61ptAHYuRhGBluAolBfG4iVX/bymImOBjJS7hBIA/4GfXmBKe3/6wW8+iluK4Rx6MJvB9uFCyDP6Sda7/fYGzdXAZzjvoUfEykXBqIYNYeOeMyApkAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYk+30uX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYk+30uX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF901C4CEF1;
	Tue, 12 Aug 2025 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024959;
	bh=Tnmua9pHuL50L/n9zww8t3DA1wLg94LEXhJdt6OjApM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYk+30uXvEwSnzectSmkhTfqgOkjngeVT/Q2l2hqMtnq8fai2wNcET2zS6zfFpgNR
	 XO765ULpwjw5ctqSqbTxxMAEXH6xcRvHJxBIAgqf3XFLhDTfr814jRlg+tD8EH05nb
	 k8vdK6M48iU2PH/QPktCGHIBZJ6Rr79z3lbIpKbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 494/627] scsi: mpt3sas: Fix a fw_event memory leak
Date: Tue, 12 Aug 2025 19:33:09 +0200
Message-ID: <20250812173445.907060788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 508861e88d9f..0f900ddb3047 100644
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



