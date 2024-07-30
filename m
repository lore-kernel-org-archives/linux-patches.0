Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC51A1A6192;
	Tue, 30 Jul 2024 17:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359032; cv=none; b=n4WynhNkZ04SiOnPQWPBmycL3DmAEFR0RVpUSfkrKFJahKBiSrk9gcC4za2A8OpBRD7XPvz6BL6TqQORlb09PYrJDrSV8v/uwd2gsexXvn9bqymWi71WWJLUlFCpTfBb0jC4OPnNkKhw5kQEi3uzXUQ+mgkM1cECtYs676BZWrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359032; c=relaxed/simple;
	bh=/toWureeY1kZe8o7k+z1G+l6XMhBGLfhwdtu40zOSBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRI+1sSnhHCA6c0NWE/PdQd18G89V2I4Kzgw39lSJY1GuMgQLf0Py18uRYZvV0ka9gSBR62hojTdpixhHpAlZW8SwACYAQBQcEUhqAQgb28oStp5T8ZSBO0AIKMicxKef8t/0UlPu9Tk9gRmQHst++wwDNTluNat4lfgTnOqNgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnYZ/KkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnYZ/KkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A270C32782;
	Tue, 30 Jul 2024 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359032;
	bh=/toWureeY1kZe8o7k+z1G+l6XMhBGLfhwdtu40zOSBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnYZ/KkV5Z0NH0DMsOC6G+tQbNksdCmdQgErvGJWjqM3ZpjAG7pETqxujx4mgZm/6
	 ieRr71nFPKbXLIEnpUiu8NeoT72yAe2JaRLpQX3o8NTpKeN1/StPWa01eUnfqYsap/
	 8MAN8SXfcfZ/yfLicAAx0aERDvgC4MxYVvkJw0Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 424/809] scsi: lpfc: Fix a possible null pointer dereference
Date: Tue, 30 Jul 2024 17:45:00 +0200
Message-ID: <20240730151741.443219507@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index a46c73e8d7c40..0a9d6978cb0c3 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1907,6 +1907,11 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
 
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



