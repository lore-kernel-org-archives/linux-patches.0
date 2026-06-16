Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D153290AD;
	Tue, 16 Jun 2026 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623711; cv=none; b=lTQavpc1ZnrMu+678Ua9tiJlRP3rf0xpRp/Us0ICusueMOG9S1+Q40D0+GbBuiJ5rcE9TZi2qGE10vnqE3mecngC+bKnu272+b0/Gv/Y+UmKFoqn8rNp88qSyKRFbcZ1Mv2F49jQLiEecWudurm0/0ZBbaUocMgqTcpVsd/jt3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623711; c=relaxed/simple;
	bh=6IZDVLgphkdMEH+lMryYU/2+NhVVcfnTiz7p0QA14x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El1xDPCzofBUQuwPL/L0rNQ06ms+cFNhPCkh5pAR2ezsknqJKazJYjsNpAM17MnZox1JOUr8809QkRGPX4VT4kz0dXzhWqN3b7mtSZpRJQgy5LLsb6bATYZi4d5ThXrtPho2cTcsB0IZRIr9QIoJdPGXls2mLYWDqk6dweV8d+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuurO4NV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuurO4NV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DFE1F000E9;
	Tue, 16 Jun 2026 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623710;
	bh=ksViBFsZsogAvBLDR8eke2eRS1i0TOixcSBg15A+rlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuurO4NVdN4W/WylgbB7hG0SnHNWjI9AW5RrdycTp4CcqDKma4RrFZ0Ki6ar+Zfze
	 sh5sqehWC0Skreo/Vf7NlzLOKlWsL28aYJBRGOmfTeyeA/rvRktrRlSqoBa6gEfEPu
	 Om/az8rq7vx5LUKF9G03a2H8aUGPNYJzxGGMtlGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 7.0 182/378] accel/ivpu: Add buffer overflow check in MS get_info_ioctl
Date: Tue, 16 Jun 2026 20:26:53 +0530
Message-ID: <20260616145119.956486075@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>

commit fb176425837693f50c5c9fc8db6fbb04af22bd0a upstream.

Add validation that the info size returned from the metric stream info
query is not exceeded when checked against the allocated buffer size.
If the firmware returns a size larger than the buffer, reject the
operation with -EOVERFLOW instead of proceeding with an incorrect
buffer copy.

Fixes: cdfad4db7756 ("accel/ivpu: Add NPU profiling support")
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260529120841.135852-1-andrzej.kacprowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_ms.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/accel/ivpu/ivpu_ms.c
+++ b/drivers/accel/ivpu/ivpu_ms.c
@@ -291,6 +291,13 @@ int ivpu_ms_get_info_ioctl(struct drm_de
 	if (ret)
 		goto unlock;
 
+	if (info_size > ivpu_bo_size(bo)) {
+		ivpu_warn_ratelimited(vdev, "MS info overflow: %#llx > %#zx\n",
+				      info_size, ivpu_bo_size(bo));
+		ret = -EOVERFLOW;
+		goto unlock;
+	}
+
 	if (args->buffer_size < info_size) {
 		ret = -ENOSPC;
 		goto unlock;


