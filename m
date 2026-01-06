Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7576727FD76;
	Tue,  6 Jan 2026 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721924; cv=none; b=mDQc27JbQyp08ww9I3ImLQ/v6NjIhvyNQNwHHM6GdR4x+9ySBgJoKWyhYL6MJVTyuSc7PfFu42Y9YOMz8g+6woVgDGx1oIp/2jQCTLDDlH/T6boagl7SxAi9+tNRt0jm9EDNBEc7R0Ok1zb44P9vflj63lgyhyYR4MlnFqYKEJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721924; c=relaxed/simple;
	bh=IL7P2bFvjkKX6vSZFytsOIyhxZmgrUHUJHH2OAFHaYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBv/W+y/H7pcm7mrPJlNQ6a+ZxYt3KnnbBdLmSSVP9JRm9J3vq2HcSzb5fslY8knK49qTEJKtnrSLb6LiJgJS1VMnkxiWm5o4Plomx77MNF7ShLXrwF2DvVcJjkqkaz3i88ZQVl/+Y+knfYcXd6KR9/BJkR6b4nDZnFxWgC7jqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/Pwa2k0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/Pwa2k0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D599FC116C6;
	Tue,  6 Jan 2026 17:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721924;
	bh=IL7P2bFvjkKX6vSZFytsOIyhxZmgrUHUJHH2OAFHaYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/Pwa2k08HTeYUnmuWqKzUTuJ+1/zwkR5mWHkaTH+ZVb7EqW/2WD1CJiUkPANz27l
	 2s1PpH99zpwRjp1E2Wm/pHfo4YvxJS09VTL/NP1BpVogQ+90Ahcu0c+4/u05zCdnyS
	 98g3ESelbrkI+D+TvANbi1FRSrtPE4BMAB9vvH5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Damm <damm+renesas@opensource.se>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 112/312] iommu/ipmmu-vmsa: fix device leak on of_xlate()
Date: Tue,  6 Jan 2026 18:03:06 +0100
Message-ID: <20260106170551.888268644@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 80aa518452c4aceb9459f9a8e3184db657d1b441 upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Fixes: 7b2d59611fef ("iommu/ipmmu-vmsa: Replace local utlb code with fwspec ids")
Cc: stable@vger.kernel.org	# 4.14
Cc: Magnus Damm <damm+renesas@opensource.se>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/ipmmu-vmsa.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -720,6 +720,8 @@ static int ipmmu_init_platform_device(st
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(ipmmu_pdev));
 
+	put_device(&ipmmu_pdev->dev);
+
 	return 0;
 }
 


