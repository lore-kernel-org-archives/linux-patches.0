Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92DB16A94A;
	Tue, 29 Apr 2025 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950351; cv=none; b=IWRlWNcLV3bOOWgVWT2rwisYY6x95abFkY3a6IARe/XEOYKemEoWnyRcgJ58kgEtcYbP7rIMYZbSIgYP9+HKazmzITz5oPsZP06HWNsGqUgAS+XCuhAwHt2/4IPGc+cxC4GU/46KVnaxtCWGJNzx9i9aF1LHZXa86FmsKNiXQUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950351; c=relaxed/simple;
	bh=QaumpdS/ooIMBTUBDlimVVDQrENMFdSmUf2DL6F+zlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhAdK0fZTmevZeo2vjEosfK4zHj7szQCaPS+aQnQdsWmZxOQAAvoP4CFdRLOCcOy9PZTzTAy+EIjPET1U9/CHZcOdx1xhwySatdMD7w2Hoq5XQl5/mavkk9cdcEuEj6W6tpxm1OPNxBFFRYhVvFUyGW/ub8OlMY8ja14gUbaA0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMD5p7cS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMD5p7cS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F07C4CEE3;
	Tue, 29 Apr 2025 18:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950351;
	bh=QaumpdS/ooIMBTUBDlimVVDQrENMFdSmUf2DL6F+zlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMD5p7cSxhkM1PWNhejoXFYtXFC8CEHPr6+b67YA5hFSOPjGMBFzCC1FolwrpvEZL
	 QoMwTdBkOjhRF4rYBgq/Vf05ReiamCChXxaJlQ71RwX8/RQ+w4wpojN3BMsmfac0VS
	 ASFh6Nar1UX33s1PgsKuYZfqtDdTTqXCeGJFVfmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/204] s390/sclp: Allow user-space to provide PCI reports for optical modules
Date: Tue, 29 Apr 2025 18:42:07 +0200
Message-ID: <20250429161101.011052681@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit e9ab04490667249633fb397be17db46a8fa6d130 ]

The new SCLP action qualifier 3 is used by user-space code to provide
optical module monitoring data to the platform.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: aa9f168d55dc ("s390/pci: Support mmap() of PCI resources except for ISM devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/sclp_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/char/sclp_pci.c b/drivers/s390/char/sclp_pci.c
index a3e5a5fb0c1e7..c3466a8c56bb5 100644
--- a/drivers/s390/char/sclp_pci.c
+++ b/drivers/s390/char/sclp_pci.c
@@ -27,6 +27,7 @@
 #define SCLP_ERRNOTIFY_AQ_RESET			0
 #define SCLP_ERRNOTIFY_AQ_REPAIR		1
 #define SCLP_ERRNOTIFY_AQ_INFO_LOG		2
+#define SCLP_ERRNOTIFY_AQ_OPTICS_DATA		3
 
 static DEFINE_MUTEX(sclp_pci_mutex);
 static struct sclp_register sclp_pci_event = {
@@ -116,6 +117,7 @@ static int sclp_pci_check_report(struct zpci_report_error_header *report)
 	case SCLP_ERRNOTIFY_AQ_RESET:
 	case SCLP_ERRNOTIFY_AQ_REPAIR:
 	case SCLP_ERRNOTIFY_AQ_INFO_LOG:
+	case SCLP_ERRNOTIFY_AQ_OPTICS_DATA:
 		break;
 	default:
 		return -EINVAL;
-- 
2.39.5



