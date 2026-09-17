Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C73C4E01EF;
	Thu, 17 Sep 2026 15:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660199; cv=none; b=Fa4YlRL7s6XqMe68i48g7Euv46mtXliqmIMjGavjoMBRKFlYKB3NH3CotpCZKRrjCDy04NugwYcqGvARbr9AWo9MWkcZz+OY6ZS8PVLqB1ogLyy7js9TL1ASEzyKE1j/67pzcxJ0Cr8yY/MmD7E337oHy/t4TuDL/9f72pLGCq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660199; c=relaxed/simple;
	bh=Cf6blnZ2vb0LLTWrf6uw5NTIoWXj+yFeh9PhttNWsy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk3LXUg+1Q7qsXkk4kQgAnYKHhc78Zox7Hi2JOewUnkE8/qiUBF9bJVo2Qb33R4351rLxzYWQroeMhb1P2pZTlF1+8Kczzw08ZAT6wkiwgI7h0Dczg8hRM0oz2Rq2v45wVp7QBq7UbbJlFMoJZQLrGp2dnuIcCwTgVozfPYt76Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xLbYCjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xLbYCjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C8D1F00893;
	Thu, 17 Sep 2026 15:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660194;
	bh=eK3i/jT6bLpQTnbSSo6kDMCT0NOMVtVOv1QIprRyns4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0xLbYCjxbfKAH0vbbTWmiE1mkzOZtnnL6hNvanXmOP+CiPLBd3nMPYh5mTII9EhW2
	 5GdqMEA1OU7Dux0SvJQ3VyvYqVw+UbuwOn6qs3AaDyBfG7TQNNLdYjd68iB1gaDLFV
	 68x1Y2uSJsF1najdiTuiuzRfEDGrX8IC+muuKKPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 511/733] accel: ethosu: Ensure SRAM region size matches job
Date: Thu, 17 Sep 2026 16:13:39 +0100
Message-ID: <20260917151404.861336371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

commit 2b39d680c9e0fb4d625f2916980977622e84248c upstream.

It is possible for userspace to set the job SRAM size to 0, but then still
have SRAM accesses in the command stream. When the job SRAM size is 0,
setting the region base register is skipped and a stale base address from
a prior job is used.

Check the region size against the job's SRAM size instead of just the size
of the SRAM. The job's SRAM size was already checked against the total SRAM
size.

Fixes: 9cff90774872 ("accel: ethosu: Validate SRAM size on submit")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260827-ethosu-fixes-v1-5-346f9ea8791c@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_job.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/accel/ethosu/ethosu_job.c
+++ b/drivers/accel/ethosu/ethosu_job.c
@@ -425,13 +425,13 @@ static int ethosu_ioctl_submit_job(struc
 			if (!cmd_info->region_size[i])
 				continue;
 			if (i == ETHOSU_SRAM_REGION) {
-				if (cmd_info->region_size[i] <= edev->npu_info.sram_size)
+				if (cmd_info->region_size[i] <= ejob->sram_size)
 					continue;
 
 				dev_err(dev->dev,
-					"cmd stream region %d size greater than SRAM size (%llu > %u)\n",
+					"cmd stream region %d size greater than job SRAM size (%llu > %u)\n",
 					i, cmd_info->region_size[i],
-					edev->npu_info.sram_size);
+					ejob->sram_size);
 				ret = -EINVAL;
 				goto out_cleanup_job;
 			}


