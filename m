Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC14253B5E;
	Thu, 17 Apr 2025 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914405; cv=none; b=H1jEBIEGcR84/rlXZ7hNLRocgwFZY5n1mI5En3aHxBWp7y2wDKSSbgdJnR0AoH0zHId+FXP0HYXbl0mRMmmbw9EKx2sOHRahGgFL/2ZHeI5qPhz5A+vzdhyj5iZJe4emN8J/O1DPa3W1gLAyT9dlTjUYB+mG5JhJesLuePiK0Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914405; c=relaxed/simple;
	bh=lyfkRhoyrzgcQGzrFtzZiYzhQ6DGaCeWAF+pzgHOBn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiYzcIhME5NyCPNA4nk5KIMuzEisFXk0zFWNWa/IAfHx5s+7to2E54kxxYLXaWpS666I1unqI0zq2hF5Eku7fRcPK0jgzpofUmwPY7RYQF9u9V24nnhc2JJZQ9CKhu35l03Ab05QjVHL5SlmhAtbK7+YIrWJgJyFWHsXp7NEHKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeYUI9lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeYUI9lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7015EC4CEE4;
	Thu, 17 Apr 2025 18:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914404;
	bh=lyfkRhoyrzgcQGzrFtzZiYzhQ6DGaCeWAF+pzgHOBn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeYUI9lhXlZFP3F9l8pqQpxQJ+tIWtKvLNzKS8WDEJDnJMI5SAX+zjeDgR2YfU/LW
	 Yuvofq6efU03ABPDD2DLjUVzm8gNNW5A+YvPnRO73nmqZMLyfRb1sjZ53ROn1aA4v/
	 ITHmfTYxa6EQD1KZi8cNyH9UNRKStbR7Y1G0CWjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 204/414] media: venus: hfi: add a check to handle OOB in sfr region
Date: Thu, 17 Apr 2025 19:49:22 +0200
Message-ID: <20250417175119.643331207@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikash Garodia <quic_vgarodia@quicinc.com>

commit f4b211714bcc70effa60c34d9fa613d182e3ef1e upstream.

sfr->buf_size is in shared memory and can be modified by malicious user.
OOB write is possible when the size is made higher than actual sfr data
buffer. Cap the size to allocated size for such cases.

Cc: stable@vger.kernel.org
Fixes: d96d3f30c0f2 ("[media] media: venus: hfi: add Venus HFI files")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1035,18 +1035,26 @@ static void venus_sfr_print(struct venus
 {
 	struct device *dev = hdev->core->dev;
 	struct hfi_sfr *sfr = hdev->sfr.kva;
+	u32 size;
 	void *p;
 
 	if (!sfr)
 		return;
 
-	p = memchr(sfr->data, '\0', sfr->buf_size);
+	size = sfr->buf_size;
+	if (!size)
+		return;
+
+	if (size > ALIGNED_SFR_SIZE)
+		size = ALIGNED_SFR_SIZE;
+
+	p = memchr(sfr->data, '\0', size);
 	/*
 	 * SFR isn't guaranteed to be NULL terminated since SYS_ERROR indicates
 	 * that Venus is in the process of crashing.
 	 */
 	if (!p)
-		sfr->data[sfr->buf_size - 1] = '\0';
+		sfr->data[size - 1] = '\0';
 
 	dev_err_ratelimited(dev, "SFR message from FW: %s\n", sfr->data);
 }


