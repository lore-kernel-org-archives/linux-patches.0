Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B7B368D47;
	Sat, 12 Sep 2026 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228654; cv=none; b=JTeQh5K+3nFS+n/LgZIcBKC2TYe3/zGehARqLEP/2+6oQj7HcncoMfmiWlxV/BQAGba2FbGbGmp443nGKYK+v3IZjGHC/MfyJBUAggcGXkm0X+kMzmCzFOfHBqPOoyTm/lyEYlof77Anw13Ao4lwOOq1kuI/YYXQ7Y5eK1eZow8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228654; c=relaxed/simple;
	bh=5MzWdLN2L5+zBRjLmnMTv7W5udEgBebrKsBIK/MMvHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3n722Nzipt+wlU6vE34XuAE8TdmeCgtDa24wfoWXCVys9ZfCoLMbzsx2DoAJ0EJOFld37X9x3/W1CHdQ6tcuqJfrdXQkuRGyPsmdEsAIT18SJYzdf4RbsDCy9FkHGXsp2gehb7frzpmEH6sBBQnTb3snnD0ilT7PEBRHE7kPRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwjvQmDm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwjvQmDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3DB1F000FF;
	Sat, 12 Sep 2026 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228653;
	bh=4K/6or9QJZwiMNbIqsMyAYIlCysEvcyXBRXUAkSzJis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwjvQmDmSBhN3YwvriGX0G3xkEKZrlz2TJWO80InxQ83fe2So5dMflvy8EnFmksFO
	 wp+PIK8Y2h2iC3/0Mnk5jRreQMEThNV776sK47oOkypAv1BKYesku7xoFepGdruFQO
	 7/CC9ThtiNVg4IYWnmtT3K6YyPlvpu0x0R16kfaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 0430/1191] drm/nouveau: Use write-combined maps for coherent
Date: Sat, 12 Sep 2026 08:52:38 +0200
Message-ID: <20260912065557.893732989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Faith Ekstrand <faith.ekstrand@collabora.com>

commit 774b73428e6eabb4f0382aeeb76e569c7b106a29 upstream.

On Tegra devices, uncached maps translate to device memory, causing
unaligned accesses by userspace resulting in a SIGBUS. Instead, use
write-combined maps to ensure proper access.

This would also affect discrete cards on any Arm device. It was
determined that discrete cards regardless of cpu arch should use
write-combined maps for coherent anyways. Thus this change is made for
all gpu types.

Cc: stable@vger.kernel.org
Signed-off-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Co-developed-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Fixes: 1b4ea4c5980f ("drm/ttm: set the tt caching state at creation time")
Link: https://patch.msgid.link/20260821-tegra-coherent-wc-v2-1-2b1ddb67bf18@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -71,9 +71,7 @@ nouveau_sgdma_create_ttm(struct ttm_buff
 	struct nouveau_sgdma_be *nvbe;
 	enum ttm_caching caching;
 
-	if (nvbo->force_coherent)
-		caching = ttm_uncached;
-	else if (drm->agp.bridge)
+	if (nvbo->force_coherent || drm->agp.bridge)
 		caching = ttm_write_combined;
 	else
 		caching = ttm_cached;


