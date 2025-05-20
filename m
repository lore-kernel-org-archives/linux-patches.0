Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB351253B65;
	Tue, 20 May 2025 14:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750823; cv=none; b=lBNxN0ez77CGO5spixa5OrwqzA244G+SaU25HKDB0Ux2SA9KoxCQIydacGyxS2DFT8fMjumwolY0u2wq/R18bqKvubzHSa24YYiqwZHDt31cFM1VEhiye83OOcvdJyrHqW2yRx36K44a9cpWu6TBJ2jEUmeMMAvjft/0jPXZ/f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750823; c=relaxed/simple;
	bh=/bNzTeP6YbqejTsvon8AU2F/dZPQfx+YnGhrSiHGNPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4o19obb1OGyWFhs2hgc9mij8kro2gZJzAUrRkLduKvlBe/48jWI5azGFT6TPT6YiG4W4fXW+0crKYXn9XO5ktWtaBBav7uRwZeewy4ElOrMi3vpS8NYKnyuek4j0k6ZULlI+1Z5ed8rs8/S6YxbqHk0wUDpa9HZc3Tj0l0SUuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsHQLP61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsHQLP61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370B2C4CEEA;
	Tue, 20 May 2025 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750823;
	bh=/bNzTeP6YbqejTsvon8AU2F/dZPQfx+YnGhrSiHGNPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsHQLP61HSzttC6B4vuJWVUtm1WQcaxgpHGacI3o51ai4O96mqkOx1k0QRS7AaWZ3
	 Rzhgw7HPZjaGoid6AKsZJ/cP8tkTm0b9GEgpGdubl5j04+nA2iKuEcDnX2mCvgRFxX
	 s+PlVZs7hmd8M9hKRp6ssnIt2+odWOpCXLhVENMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.14 132/145] dmaengine: idxd: Add missing idxd cleanup to fix memory leak in remove call
Date: Tue, 20 May 2025 15:51:42 +0200
Message-ID: <20250520125815.710527449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1319,6 +1319,7 @@ static void idxd_remove(struct pci_dev *
 	destroy_workqueue(idxd->wq);
 	perfmon_pmu_remove(idxd);
 	put_device(idxd_confdev(idxd));
+	idxd_free(idxd);
 }
 
 static struct pci_driver idxd_pci_driver = {


