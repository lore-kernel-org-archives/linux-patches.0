Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA241C688E;
	Tue, 27 Aug 2024 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771716; cv=none; b=mlxO46+8w2I9BTJBsOUiIJ7xzNuegAbVKKjvLIOKAioMMlUBSw3z67wLI0QiC/jWlzLZk7klC6vIIoe87i7ddI5F3odRHtPLhWTT37t05zB8ggKHsE/sGp1YZDMpAVqR4tjAPUAkgY1Tye19DJoaffaDTGiytxHGKwdSjdszhc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771716; c=relaxed/simple;
	bh=Vuizdvi6Ode9Ppy6g+XoWWIOm5O4v4NYQZUZQRuJgj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KkqDhUQxw6+eidFHAkvqtQTPeNNX/RhToC9UI8pdzSLfEN+65sWhNAfrUTVoCR1TA5VA/XRpdAwcyDoY8gYvsubSZHpfk0VV5JaNbKOoh7cxSRvRr/t0psOcwOyn6r2doa/XTQV2L7LT4RWD2pCq0uwaFp4zub6yaVqNY0qcNQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYrFKqwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYrFKqwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269EFC4DDEF;
	Tue, 27 Aug 2024 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771716;
	bh=Vuizdvi6Ode9Ppy6g+XoWWIOm5O4v4NYQZUZQRuJgj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYrFKqwezbMRsEguvbZQqZLxIOGknmroKXcqUwpS60+yM2r+6UdUykADvB2yNWAZg
	 aK94xkuBhPAopOzNhGOCwZQ6yXZxrXMtUP+HlEffzjq93OVom1rYUeFUuGl2Z5qACA
	 vssEZKPjLg2q/z3WZFKBYKvOaF6Jw6+r2FFQat2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.10 231/273] platform/x86: ISST: Fix return value on last invalid resource
Date: Tue, 27 Aug 2024 16:39:15 +0200
Message-ID: <20240827143842.196062660@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 46ee21e9f59205e54943dfe51b2dc8a9352ca37d upstream.

When only the last resource is invalid, tpmi_sst_dev_add() is returing
error even if there are other valid resources before. This function
should return error when there are no valid resources.

Here tpmi_sst_dev_add() is returning "ret" variable. But this "ret"
variable contains the failure status of last call to sst_main(), which
failed for the invalid resource. But there may be other valid resources
before the last entry.

To address this, do not update "ret" variable for sst_main() return
status.

If there are no valid resources, it is already checked for by !inst
below the loop and -ENODEV is returned.

Fixes: 9d1d36268f3d ("platform/x86: ISST: Support partitioned systems")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org # 6.10+
Link: https://lore.kernel.org/r/20240816163626.415762-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -1549,8 +1549,7 @@ int tpmi_sst_dev_add(struct auxiliary_de
 			goto unlock_free;
 		}
 
-		ret = sst_main(auxdev, &pd_info[i]);
-		if (ret) {
+		if (sst_main(auxdev, &pd_info[i])) {
 			/*
 			 * This entry is not valid, hardware can partially
 			 * populate dies. In this case MMIO will have 0xFFs.


