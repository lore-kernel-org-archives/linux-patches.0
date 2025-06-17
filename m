Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8B72FA624;
	Tue, 17 Jun 2025 16:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179455; cv=none; b=SOO7H5m35+FZljFiGayn2bQ7ukwotBK0WKrLtqJfQ1tljJwtQZVcNcc0mVJp5pKKAJIB1HJwu6RupLgRzC56lLc/0X4x682pA43/j4Qe13zSvt9CaV5fUrEgNlZzNlYCx8AOqqFQxPYALIxQgbX5ZVAKTCAZ4s07DMe8RZJIxFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179455; c=relaxed/simple;
	bh=mYO40vBGiCJpcdjHE0DBahhWJ1/e511UFm2h5fAtQc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUUq3oC6wZtlcVkZ6LvEEzZGz+NeT+BtBadrf0UPWCbHp/M9y+yrGXHPbVO9e6ZRZFMXqSvIQ28tMjnVWQqoYQCXPzZS5Hf+RY5Pno7Hdp5j9NR/XdnbxnsAVP1T4RIIQpY/uIZggghScEBITq315FdPUdHDVTHQpAtTMV5amW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URagdDtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URagdDtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A61C4CEE3;
	Tue, 17 Jun 2025 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179455;
	bh=mYO40vBGiCJpcdjHE0DBahhWJ1/e511UFm2h5fAtQc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URagdDtBKjWwx/ALN6JOpYi5MFiDVuGyW3A00jBY4FjjmBFmSBtM7NOuW+pvfTfiV
	 RMdqfGaHbf9ZJg7yI1rFQkJ2Fyg93SbnHD+DMCjcIlNu8mzLqB54T6FcVX3jHircc4
	 imPmSLXYOFJpu1RV7wMSxP6TCJS1Im7wLsjW3EgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Korsgaard <peter@korsgaard.com>,
	Michal Simek <michal.simek@amd.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.15 752/780] nvmem: zynqmp_nvmem: unbreak driver after cleanup
Date: Tue, 17 Jun 2025 17:27:40 +0200
Message-ID: <20250617152522.126403011@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <peter@korsgaard.com>

commit fe8abdd175d7b547ae1a612757e7902bcd62e9cf upstream.

Commit 29be47fcd6a0 ("nvmem: zynqmp_nvmem: zynqmp_nvmem_probe cleanup")
changed the driver to expect the device pointer to be passed as the
"context", but in nvmem the context parameter comes from nvmem_config.priv
which is never set - Leading to null pointer exceptions when the device is
accessed.

Fixes: 29be47fcd6a0 ("nvmem: zynqmp_nvmem: zynqmp_nvmem_probe cleanup")
Cc: stable <stable@kernel.org>
Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Tested-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250509122407.11763-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/zynqmp_nvmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvmem/zynqmp_nvmem.c
+++ b/drivers/nvmem/zynqmp_nvmem.c
@@ -213,6 +213,7 @@ static int zynqmp_nvmem_probe(struct pla
 	econfig.word_size = 1;
 	econfig.size = ZYNQMP_NVMEM_SIZE;
 	econfig.dev = dev;
+	econfig.priv = dev;
 	econfig.add_legacy_fixed_of_cells = true;
 	econfig.reg_read = zynqmp_nvmem_read;
 	econfig.reg_write = zynqmp_nvmem_write;


