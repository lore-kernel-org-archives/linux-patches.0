Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1925A4F055E;
	Tue, 13 Oct 2026 11:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892540; cv=none; b=AXGzTGKiPcHIWWlRC2A7Yrll3exPWUt/fi8PFPzWvqinwMkm8XrN4vPllkxdK6ENko5nA8KWQZOVmX19iGvUmeocBJwn+46ugU2lsJayGrpIvm+2b81skLMn6qi6rnbXZ8fJoacb4TDyYybZ2hU0r7f7dmnDvkAtKDBbeByVGeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892540; c=relaxed/simple;
	bh=MOieaKk+b2EoFX6lZXcBCUjJceHPq0yjCMZhYWRX3Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDFXPAGoR+r2Cyd7QSoitZtViHbZCND0GNUjE8Q5X5apLKjuN6luF0y8dO3li/x+pI3qcHj5YiybvfsOjqgmjVkpk5lWsMJn+oqOXATiVicsYiTnM7UghF4OVZRiL0iH8KUSm0oFqhD8E2LvxVfj06qvfsdWWhqDHi2TboTZDgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPZmZgwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPZmZgwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623991F000FF;
	Tue, 13 Oct 2026 11:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892539;
	bh=mEbdWAxJAbts7Oj8ITcvNVo76cRLUO//vvON1f6A4tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPZmZgwA5dqs3z1/wHOgJDQrLQn067iKAutXxae+vXrE/gEhku3iaT7dvN06FpzJr
	 4ZszYmc5o0OPXH/lK9Fthmx9NQgYMV83BHpw7IiYmj16psC0rsW7Fze99uxB5YpHYU
	 DvtejRRgjtGMeXAQ4TISZgCoNawtJ1qaKAPju8Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 206/281] nvmet: return Invalid Field for invalid NSIDs feature 82h
Date: Tue, 13 Oct 2026 13:38:42 +0200
Message-ID: <20261013112900.161189058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit d99bc5b456fd63be46c8bda20dbf6ede93d2fc11 ]

The Reservation Notification Mask feature (FID 82h) defines its own
status code for namespaces that do not support reservations:

  "If a Set Features command or a Get Features command attempts to
  access the Reservation Notification Mask on a namespace that does
  not support reservations or is invalid, then that command is
  aborted with status code of Invalid Field in Command."

  -- NVMe Base Specification, section 5.2.26.1.33

The Set Features handler routes the namespace lookup through
nvmet_req_find_ns(), which returns Invalid Namespace or Format for an
unknown NSID.  That is the correct status for the generic
namespace-scoped admin commands, but not for this feature: a Set
Features 82h naming a nonexistent NSID is aborted with Invalid
Namespace or Format instead of Invalid Field in Command.

Translate the lookup failure to Invalid Field in Command.  The
broadcast NSID, the namespace-without-reservations case and everything
else keep their current behavior.

Fixes: 5a47c2080a73 ("nvmet: support reservation feature")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/target/pr.c b/drivers/nvme/target/pr.c
index ad07f55e7f173..acb44df15fc7e 100644
--- a/drivers/nvme/target/pr.c
+++ b/drivers/nvme/target/pr.c
@@ -51,6 +51,8 @@ u16 nvmet_set_feat_resv_notif_mask(struct nvmet_req *req, u32 mask)
 
 	if (nsid != U32_MAX) {
 		status = nvmet_req_find_ns(req);
+		if (status == (NVME_SC_INVALID_NS | NVME_STATUS_DNR))
+			return NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		if (status)
 			return status;
 		if (!req->ns->pr.enable)
@@ -75,6 +77,8 @@ u16 nvmet_get_feat_resv_notif_mask(struct nvmet_req *req)
 	u16 status;
 
 	status = nvmet_req_find_ns(req);
+	if (status == (NVME_SC_INVALID_NS | NVME_STATUS_DNR))
+		return NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 	if (status)
 		return status;
 
-- 
2.53.0



