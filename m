Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71148215F7C;
	Tue, 29 Apr 2025 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948178; cv=none; b=dHaLN6c+Vk94Sbd5GW2qhyWqtbStKFA0a3NaAnUCkbWpuYr18dpTYHOmTdVhs85iT187UQkZRkL1UuQVVNO1xxBKN0AI7HDj8zSbFCCIAczwM/fNoeCRkDfCQMeEj6cZLfVJLOwURVYBQpl5rNUCoEOD1j3f70xdFRPTTItDuso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948178; c=relaxed/simple;
	bh=HRseR40gore3aWYI3o/OnJBfUPoI0Tcr9/K+FgbwXuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0WeC5ADL0CcIakN0Oeoze87kWdDL2BYG0JqeWcR1B41wHWtW20PVYQt5zT+Gpi50ujIJOBrxhNOGNVsjV+vH+90hY5OxJ68f8h23/fIoBF08aPPNk/u3RnbpaBTY6XRscE2fWxR67PK5Ix8NSDoUMnxmaM7Ovpu2HvfN3UdK0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVuYY6Tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVuYY6Tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FDFC4CEE3;
	Tue, 29 Apr 2025 17:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948178;
	bh=HRseR40gore3aWYI3o/OnJBfUPoI0Tcr9/K+FgbwXuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVuYY6TuxMdLSdlP/qcy87Qfvpk8MjusakoBlVzM362s7vg8R9s8G6QgEBQ3eW22R
	 LHpwQzTeK3Ph1rEsnyLwNWzukjN1CMyU9ASyvITOZkujzRGAhCOZw05MeJS7YPr6g2
	 kzCOkHoSVdVJKPqcLs4C9jbbogkwDex89j4ATK2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/280] nvme: re-read ANA log page after ns scan completes
Date: Tue, 29 Apr 2025 18:42:33 +0200
Message-ID: <20250429161123.799680688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 62baf70c327444338c34703c71aa8cc8e4189bd6 ]

When scanning for new namespaces we might have missed an ANA AEN.

The NVMe base spec (NVMe Base Specification v2.1, Figure 151 'Asynchonous
Event Information - Notice': Asymmetric Namespace Access Change) states:

  A controller shall not send this even if an Attached Namespace
  Attribute Changed asynchronous event [...] is sent for the same event.

so we need to re-read the ANA log page after we rescanned the namespace
list to update the ANA states of the new namespaces.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 587385b59b865..f7519c07ed3c4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4277,6 +4277,11 @@ static void nvme_scan_work(struct work_struct *work)
 	/* Requeue if we have missed AENs */
 	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
 		nvme_queue_scan(ctrl);
+#ifdef CONFIG_NVME_MULTIPATH
+	else
+		/* Re-read the ANA log page to not miss updates */
+		queue_work(nvme_wq, &ctrl->ana_work);
+#endif
 }
 
 /*
-- 
2.39.5



