Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497251DB34C;
	Tue, 27 May 2025 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366264; cv=none; b=tFCNLNdWS2LQhTDWkIoLjQPbsbONmRsRKrRGzTWB2qg8Geb1Zf8FMJtJIoOAX4w29k7Y/6pusfiJD7g3ZNdGfAdtEJR6bIlBFhTRI+izuLz3bce8BDQTshpbE4pQcYVx8oq79b57QA+PW146GCngFJq6ETZl/wlEtOt64kKnMHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366264; c=relaxed/simple;
	bh=E4y1DOCch5XjT4XOQvaGgz1eS+nSL4qHGIA1d5Ifen8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bB82/5GxffqzATeKVVYnpx4iez1yO7CP/MR13VKmM7UPsLHhYo5vjz2P7fKLpQlSBDc4Z3dK5wrptvIjNs/2mEvxPaUX5UHlIqxGZ8BwLuhKQyS8z3YJh6459yT065FZU/y94K0NjFIqHpGW7Lu63jGjI2x2m3uSJ5Zrc2Nu+2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCx2bkwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCx2bkwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9DDC4CEE9;
	Tue, 27 May 2025 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366264;
	bh=E4y1DOCch5XjT4XOQvaGgz1eS+nSL4qHGIA1d5Ifen8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCx2bkweAzI2d/kiz6pDWH3l5tZ3vfwzI45UJztE7YoCvWPrj+XlK874Gk0nl6w92
	 1BvFVi97zCNth+4TR0Joj05ZpFCfvRHxfOMYfPZF/zzU4FEBO+X2VYD8a/NpD2pwnf
	 FTjNH3GtHf8VOTd4OCuDCt2dlc/Zdy3eMwnTNEGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 013/783] nvmem: core: verify cells raw_len
Date: Tue, 27 May 2025 18:16:50 +0200
Message-ID: <20250527162513.585800726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 13bcd440f2ff38cd7e42a179c223d4b833158b33 ]

Check that the NVMEM cell's raw_len is a aligned to word_size. Otherwise
Otherwise drivers might face incomplete read while accessing the last
part of the NVMEM cell.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250411112251.68002-10-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 7872903c08a11..7b8c85f9e035c 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -605,6 +605,18 @@ static int nvmem_cell_info_to_nvmem_cell_entry_nodup(struct nvmem_device *nvmem,
 		return -EINVAL;
 	}
 
+	if (!IS_ALIGNED(cell->raw_len, nvmem->word_size)) {
+		dev_err(&nvmem->dev,
+			"cell %s raw len %zd unaligned to nvmem word size %d\n",
+			cell->name ?: "<unknown>", cell->raw_len,
+			nvmem->word_size);
+
+		if (info->raw_len)
+			return -EINVAL;
+
+		cell->raw_len = ALIGN(cell->raw_len, nvmem->word_size);
+	}
+
 	return 0;
 }
 
-- 
2.39.5



