Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE01E32570D;
	Mon, 13 Apr 2026 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099795; cv=none; b=UtEmmhvhfL3zfTfNPAiGSYD4GxM8rXpgemI4GCd7BH2hHryvQUUFImGpXgjcSl4L/6mldSevihNTQU/DHHUwyj2BX1RtGi9Qmxirx8jiMAZldFe8iwcdU+xo+o54Y9G9tKUjCpaIOoxqQ0tSWwCSLlqmMPirt4NLRXd3LQJl/6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099795; c=relaxed/simple;
	bh=Awx3KGxXSDX7vljcXKkc+WdqdZBi+k2F4aXscUD+Vwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8qbD1I4Oi8TvjcRDHIQC+roJjqio2JaHlkK5Jc1x/efYRz166pMgeE29KBBoDv8/KPA/ZSAbNSVCA7hVkRjc31AI1P+YF8CCPVJZ4haQyQCPj4Bhu/lqJiCgz9QScjYfGbhJ9DvDsmnvp8Is6qlS9sf3Iw19i2uhI64E29fswY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjXQ33QJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjXQ33QJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748ECC2BCAF;
	Mon, 13 Apr 2026 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099795;
	bh=Awx3KGxXSDX7vljcXKkc+WdqdZBi+k2F4aXscUD+Vwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjXQ33QJVKRbItlShVfmkCaXjrj15PgIJyzd9gag7fUFGrWnNdvj7n5u4KBgtvxvP
	 AfsvZQ0rDv52UoOw/1PhCGulVk9Mem9CkNeDeCryP549fuh/uqV1+NSPXIsAa5KIp3
	 3PaM644ccLofsUDf5CJiGHp9xQtRg5UhGKtg9D+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaskaran Singh <jsingh@cloudlinux.com>
Subject: [PATCH 5.10 477/491] Revert "nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()"
Date: Mon, 13 Apr 2026 18:02:02 +0200
Message-ID: <20260413155836.909288084@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaskaran Singh <jsingh@cloudlinux.com>

This reverts commit 3d78e8e01251da032a5f7cbc9728e4ab1a5a5464.

The backport of upstream commit 0a2c5495b6d1 was incorrectly applied.
The cancel_work_sync() call for ->ioerr_work was added to
nvme_fc_reset_ctrl_work() instead of nvme_fc_delete_ctrl().

Revert this commit so the correct fix can be applied.

Signed-off-by: Jaskaran Singh <jsingh@cloudlinux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3259,6 +3259,7 @@ nvme_fc_delete_ctrl(struct nvme_ctrl *nc
 {
 	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(nctrl);
 
+	cancel_work_sync(&ctrl->ioerr_work);
 	cancel_delayed_work_sync(&ctrl->connect_work);
 	/*
 	 * kill the association on the link side.  this will block
@@ -3322,7 +3323,6 @@ nvme_fc_reset_ctrl_work(struct work_stru
 
 	/* will block will waiting for io to terminate */
 	nvme_fc_delete_association(ctrl);
-	cancel_work_sync(&ctrl->ioerr_work);
 
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING))
 		dev_err(ctrl->ctrl.device,


