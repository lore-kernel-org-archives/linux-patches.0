Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454351A6192;
	Tue, 30 Jul 2024 16:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357640; cv=none; b=TgVMSyhz3M+SZ60jduxaHRT+p+dI365alPBTzmmZqN6/EpbgsNUIvuqAZLi9tejT0UV514Ras107aOe6+kAYqT4eKtzJE5h3z+yHZORJfkREN65sFoesduf7ZgQm2Cz0mcO03Zl4EBxW/XV3ZUGkRK6hJKj3EaEnJazIlZIq9+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357640; c=relaxed/simple;
	bh=dODyhXslc3jf7ieDPhZraeW1hjjlWI+a+QDDmWb4aRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbXWAxnkANI7hw5mqqvmgDV7YWPgt4KVRwLEgMHcV9iXmTeXL4+0BZ4UT3AyO2EtUENCdEDlyGOsZPR4c/y5Z14j7VxyuVF8xB/aKe/1Fx79l0aikgzhlLOow50wCtPRUCcsFFmEDdqFs/1fw6HSd9VUK8LJ52nr/sTboYJ+ytk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jyq2hRSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jyq2hRSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD164C32782;
	Tue, 30 Jul 2024 16:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357640;
	bh=dODyhXslc3jf7ieDPhZraeW1hjjlWI+a+QDDmWb4aRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jyq2hRShLFJutbFvjgTs53nMzB6uqSNjV5w+9W4Es99ZUgAmVe/SzjwtBW1vahYg8
	 GWPTVqxMVhSuTm98BIr8RynokkqJptBehfhM/HM1847VxkwdPdlWsyxBkqIKAHlDRm
	 7BZg/+rEoyMIFddpm09DXX0+ZxwW7DGh+JFmpD1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/568] scsi: lpfc: Fix a possible null pointer dereference
Date: Tue, 30 Jul 2024 17:46:24 +0200
Message-ID: <20240730151650.704957162@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huai-Yuan Liu <qq810974084@gmail.com>

[ Upstream commit 5e0bf3e8aec2cbc51123f84b29aaacbd91fc56fa ]

In function lpfc_xcvr_data_show, the memory allocation with kmalloc might
fail, thereby making rdp_context a null pointer. In the following context
and functions that use this pointer, there are dereferencing operations,
leading to null pointer dereference.

To fix this issue, a null pointer check should be added. If it is null,
use scnprintf to notify the user and return len.

Fixes: 479b0917e447 ("scsi: lpfc: Create a sysfs entry called lpfc_xcvr_data for transceiver info")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
Link: https://lore.kernel.org/r/20240621082545.449170-1-qq810974084@gmail.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 79b45ea5fdb5e..8123062ec2faf 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1904,6 +1904,11 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
 
 	/* Get transceiver information */
 	rdp_context = kmalloc(sizeof(*rdp_context), GFP_KERNEL);
+	if (!rdp_context) {
+		len = scnprintf(buf, PAGE_SIZE - len,
+				"SPF info NA: alloc failure\n");
+		return len;
+	}
 
 	rc = lpfc_get_sfp_info_wait(phba, rdp_context);
 	if (rc) {
-- 
2.43.0



