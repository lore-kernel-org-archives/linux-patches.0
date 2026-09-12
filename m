Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EC6364059;
	Sat, 12 Sep 2026 08:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202900; cv=none; b=jEdJPywWJuL5U07k9TRIZy5HcQJN1uCZBBS0oqxiyLQUPjmIHbjZGnApK+fTPQDIVnne85e6XhTiOS7YDP9vmu123xYXu7QSf69G1K58zn7HprJi7ny2AtCu8RLsR6HHDrekbg3p/2zIoB+T2krDBs5+/fImJjmmajFv1I3HGyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202900; c=relaxed/simple;
	bh=T8vuJaI7mUNYp/jxWziHCC5bqS7yNOn+kLnIQ8PpV0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErCx9SNIECIyPzunGURVlQCUCByN9R2s4QZqBfFb2NoSc9bh2wnsXDBnbYlDmjuVWWWk5Xwf9WoGRO2LNaL4Kiwbsd68s5Fo5g1wlDIzkYScekZ6aRf0eTkd/43f3xMvR7mroH4Gfy93Gt+aeP6AtVef/vdZqc3iVdS75sYNcwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOtwhM3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOtwhM3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEABB1F000FF;
	Sat, 12 Sep 2026 08:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202898;
	bh=Zi0bWp3+TLSlONSRnWIPEjQyXs//EOh11J1JSGswv8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOtwhM3/GuggNJrH/1C2lzJt8kyBr+V1fCaEBNizVKkIz/l7+fSnyTeHi20qaIDIE
	 hVMoIBI8RleGeXw5ZhJXkHMuC5OaY5ircX7kkEnix5K8DAZN6MP1CTQccwWUYk5puq
	 5KRZrnDaVi6aBe/qYLf+FXAq6RHqYbyspjNVscy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Bin Du <bin.du@amd.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1298/1815] media: amd: isp4: release partial allocations in isp4if_alloc_fw_gpumem()
Date: Sat, 12 Sep 2026 08:50:48 +0200
Message-ID: <20260912065719.488633437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Yifei Gao <gyf161023@gmail.com>

[ Upstream commit fea97ee13c5332f67850733d6cefc1fe99460bde ]

isp4if_alloc_fw_gpumem() allocates several GPU memory pools in sequence.
If one of them fails, it jumps to error_no_memory and returns -ENOMEM
without releasing the pools that were already allocated, leaking them.

Release the already-allocated pools before returning. isp4if_gpu_mem_free()
is a no-op on pools that were not allocated, so calling
isp4if_dealloc_fw_gpumem() here safely frees exactly the pools that
succeeded.

isp4if_gpu_mem_free() previously logged an error for a NULL entry, which
is a normal case during partial-allocation cleanup, so make it silent.

Fixes: 4c5feef6a62c ("media: platform: amd: Add isp4 fw and hw interface")
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Reviewed-by: Bin Du <bin.du@amd.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amd/isp4/isp4_interface.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/amd/isp4/isp4_interface.c b/drivers/media/platform/amd/isp4/isp4_interface.c
index 00a8179092921..4801617f95599 100644
--- a/drivers/media/platform/amd/isp4/isp4_interface.c
+++ b/drivers/media/platform/amd/isp4/isp4_interface.c
@@ -148,12 +148,9 @@ static void isp4if_gpu_mem_free(struct isp4_interface *ispif,
 				struct isp4if_gpu_mem_info **mem_info_ptr)
 {
 	struct isp4if_gpu_mem_info *mem_info = *mem_info_ptr;
-	struct device *dev = ispif->dev;
 
-	if (!mem_info) {
-		dev_err(dev, "invalid mem_info\n");
+	if (!mem_info)
 		return;
-	}
 
 	*mem_info_ptr = NULL;
 	isp_kernel_buffer_free(&mem_info->mem_handle, &mem_info->gpu_mc_addr,
@@ -201,6 +198,7 @@ static int isp4if_alloc_fw_gpumem(struct isp4_interface *ispif)
 
 error_no_memory:
 	dev_err(dev, "failed to allocate gpu memory\n");
+	isp4if_dealloc_fw_gpumem(ispif);
 	return -ENOMEM;
 }
 
-- 
2.53.0



