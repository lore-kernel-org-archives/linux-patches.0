Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF6724A066;
	Tue, 20 May 2025 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750356; cv=none; b=nZ12RRCMxWsXbc5edq1rsxnVTdqz5iOUweIvBVQicFirQWMxxJqjMHFrUmMOcLCc4NPjlV5aW7vBboErMfkro4emGx3vy8zecfthhLgXZ6m3zAk8aAMKs9yZbkLADj9ilJud61qA/c14TxkZNrwaK/di6eqGTc7uyMI30/hx/eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750356; c=relaxed/simple;
	bh=dIQx1m+0ThsdkSAbYctbT8jJeUH/4AVuNYE04oL8qTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvSLyPeowiD0cRWfkFvNyLC8FptkSRzu88FJ4GU1ObKpPha58qDxrj5Kj8Lrl932l5E5WANJx0CnaRzHA49WcwXqzUdn465FajYLQ+ssbe7Nlnqhf6pke6vLbfjK7qmeY7xbIfsgh8VxzKWYPB2LWT+IX9tH9RoZ0SstjuO4WhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwnNHK5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwnNHK5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABAAC4CEE9;
	Tue, 20 May 2025 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750356;
	bh=dIQx1m+0ThsdkSAbYctbT8jJeUH/4AVuNYE04oL8qTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwnNHK5VQvnwhVPnyvpD9p+fWZIFYPrFdMy38UVH5cOsF7FBZewTkyoaulqKt+P9u
	 QCd+/mvMnQ4EnPknnO8Z61oWflXNQlKMsi2uF3EoBNcfp9Fo4Oh/eWG0xCsy4emyWd
	 oWsaeKJANWaHruG1ZzdIfT8/SfUdMKxs4sMz9cYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 125/143] dmaengine: idxd: Add missing idxd cleanup to fix memory leak in remove call
Date: Tue, 20 May 2025 15:51:20 +0200
Message-ID: <20250520125814.943437168@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit d5449ff1b04dfe9ed8e455769aa01e4c2ccf6805 upstream.

The remove call stack is missing idxd cleanup to free bitmap, ida and
the idxd_device. Call idxd_free() helper routines to make sure we exit
gracefully.

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Cc: stable@vger.kernel.org
Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250404120217.48772-9-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -915,6 +915,7 @@ static void idxd_remove(struct pci_dev *
 	destroy_workqueue(idxd->wq);
 	perfmon_pmu_remove(idxd);
 	put_device(idxd_confdev(idxd));
+	idxd_free(idxd);
 }
 
 static struct pci_driver idxd_pci_driver = {


