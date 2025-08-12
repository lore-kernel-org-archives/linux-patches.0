Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063DB6BB5B;
	Tue, 12 Aug 2025 18:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023151; cv=none; b=tAId13DqeFEs8klaGEAUKYvwAM1f1RfrOp+UW2kn3ZAYb5S1hb9+gqoO9jfj1ObnCB5k2qDCaA/lSMz9Sdoi8m4idibUpQwdDBZKZH3N4G5UEu4+PLx3m3KY2anaHiKKGNkKfX+GjI6KmwWO5lhH2EWqnX1VOMprYDWQbjKRSgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023151; c=relaxed/simple;
	bh=K/gy0S06FuLXcYtx/3PmcXwnJDZmBPCd7uL6tHeX7QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWOYYgay19x6kHskJvR+nPR4oPIQJbJPDzU6swvLyGeN024qYkKju4svKgiopIUqrF80WvInmi2zC+cOv+0u2dBB3Dfbic0TSM28843y88hutffkjS3q/8cGsvbCVLBeNG2HFRDLIE4+dRgAqeGKNVCD4K/stvtb5qcTGPB6uOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9hO+m19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9hO+m19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF2AC4CEF0;
	Tue, 12 Aug 2025 18:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023150;
	bh=K/gy0S06FuLXcYtx/3PmcXwnJDZmBPCd7uL6tHeX7QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9hO+m19GwUf2S6Nke3CeFnm+zzYF8ADiLSbytleN1ezBi0QfG2Bng6DdUBi7YRV8
	 awU5ntc15laCXY4Xi13ZdmtUOHlizmm+4FjmiKWHKEhDAPAQpKL3v74yCd4Ra5JimN
	 KMQTXL4YcQP5VkOfh7Leg1EoPY2BS5guNEsxt9YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Shouping Wang <allen.wang@hj-micro.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 365/369] perf/arm-ni: Set initial IRQ affinity
Date: Tue, 12 Aug 2025 19:31:02 +0200
Message-ID: <20250812173030.416332362@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

commit c872d7c837382517c51a76dfdcf550332cfab231 upstream.

While we do request our IRQs with the right flags to stop their affinity
changing unexpectedly, we forgot to actually set it to start with. Oops.

Cc: stable@vger.kernel.org
Fixes: 4d5a7680f2b4 ("perf: Add driver for Arm NI-700 interconnect PMU")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Shouping Wang <allen.wang@hj-micro.com>
Link: https://lore.kernel.org/r/614ced9149ee8324e58930862bd82cbf46228d27.1747149165.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-ni.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/perf/arm-ni.c
+++ b/drivers/perf/arm-ni.c
@@ -545,6 +545,8 @@ static int arm_ni_init_cd(struct arm_ni
 		return err;
 
 	cd->cpu = cpumask_local_spread(0, dev_to_node(ni->dev));
+	irq_set_affinity(cd->irq, cpumask_of(cd->cpu));
+
 	cd->pmu = (struct pmu) {
 		.module = THIS_MODULE,
 		.parent = ni->dev,


