Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7052FE56B;
	Tue, 12 Aug 2025 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021658; cv=none; b=e4uTxj9jL8szNLT/rbeYbxJiQVI8wdkQr5AfZpLy754idhZ2INXc5Q7kB8gKI4V3Utn0FK4Op/Y1XwVeWgn5FW8x7fnNifnPKcQdfYJJ+m7G5nEhxcXEDzyLQqjUPWLbVY52vht9XKTasI9bAXSye4oqaB7nVYv9LQ8jcN4S9t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021658; c=relaxed/simple;
	bh=IabA50+qEhuzBlHTOINISpa6kA1CtUcvDRFVm0LWnlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISaB5NGLqircPWrHPYipyrO2ZGzFBkmDkw0yWMX4krTtgpMakParf0X9Igr+uMxv8+9vYpciDAyEI7wKpaqFpSJoeb9IOpV5lOVxcm4s/AfHm958J19R4lWtBUwTC8UBw9hNKtNgnNW9GiJBBvtImjMgk9Zr7Ub9p126v4EJRL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Izm/y5Gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Izm/y5Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38FCC4CEF0;
	Tue, 12 Aug 2025 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021658;
	bh=IabA50+qEhuzBlHTOINISpa6kA1CtUcvDRFVm0LWnlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Izm/y5GcM+zkNJueTKVMhSWmBYldEbRLlmoy3hLBrN372EF8QViSz0MwuIoBmlfrc
	 eET0m8JtRFYgzZjzoA/0f05+1+rPY3v60u2d7aoQx4q/F6+CVqARxQRZ5laRttuOFL
	 Q5ifWvbPd5zQhbzdFPHrjBbjio8kCTKL5a1hCt/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/262] scsi: mpt3sas: Fix a fw_event memory leak
Date: Tue, 12 Aug 2025 19:29:33 +0200
Message-ID: <20250812173000.999786526@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f270b0d829f6..0afa485fb300 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10818,8 +10818,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
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



