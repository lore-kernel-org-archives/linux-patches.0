Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B3C279915;
	Tue, 12 Aug 2025 17:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021024; cv=none; b=CmUmDLxkqBy4nuRlEi0f5mOQ04p/DfRD+GW8oeXv2pR6ypN0BjjN1zZLMUHiaq7CYPI5tvpvVUAIHqQxu8i5MNDLcQE1p4VNX2XjsA0GF5L2XYft0kZHr7mlKyhSkp+HGkfPk6CjrNl542sbs7bKYHDqDwMd38ORayI6Bgc07Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021024; c=relaxed/simple;
	bh=Je0FYIalwXPjRn6QNWJ+DhfFYG82/uBeqrJv/dMbeR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0zfKbttX0QPQTZcfX/SPVh4wErTuPVS+faFIk1HJTCxFSe/ngcexH8f84OgMaB3Iz8r1wyrHSTLJcdyyxTNc2dbISP6J4qvEvPQ6fdF9eEkoOhdVrfJnJ5lwqQ3ivoV0w0U2QGA3cwAGGrqZzqepakSe/TCTDI4RZ5ai4pwHf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHVajOWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHVajOWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FD2C4CEF1;
	Tue, 12 Aug 2025 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021024;
	bh=Je0FYIalwXPjRn6QNWJ+DhfFYG82/uBeqrJv/dMbeR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHVajOWNYF2RfBHSnqYLRzP+5ZY3axyMSqmJNRLlpsgAQvdolPXd008Bo0+pJrYm0
	 PyGaVPCUSTnznrNerl0TMTfO3e7MRJ9Gn6YGFpS+q/fQjEWMBFSFdMYnWXTfZoBUks
	 h0zEub7SVqbUCpaHbsnlxoP5Ja/toScJel7dNCxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/253] scsi: mpt3sas: Fix a fw_event memory leak
Date: Tue, 12 Aug 2025 19:29:49 +0200
Message-ID: <20250812172957.360908281@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 31768da482a5..b5b77b82d69f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10819,8 +10819,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
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



