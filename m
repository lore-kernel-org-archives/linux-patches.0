Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60A840876;
	Mon,  1 Apr 2024 17:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991311; cv=none; b=Q0TWvQWJXOhSDgNSqlMzwHYxHB6B+6j+suS2OfubHvCI5/eKuVYyqUpYxia1geVa+qWrmhBZS8WTZ6nQ5muY99R7+11bHs8fxsrjhLqGMZYB60hz18BIaKAVnygkV6HVj7s8EhDYwjJpH9XgFZdo/ncxVhuJi0auIzLBQdbjDoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991311; c=relaxed/simple;
	bh=luENMCKU+tFVsy6p6pIql2iH5LAKGprW3TZ1M0Ow3DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KH/Vt33QhgYt4oEeDSS/yuf6Afuh2G7Jc1D++YueE/dO3CjXTZlJy6WRJ1A9XP0cuaPZf7DubSTy8m76eYqmwoC35T7OZVygFrNQAwpHcGM+7/ulbFq3FZtfZntHCsZuuEl2TwlSmvythJPCUf0bAE9s/oiNJVDI7SK3cU+7XAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXdpVco2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXdpVco2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561A2C433F1;
	Mon,  1 Apr 2024 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991310;
	bh=luENMCKU+tFVsy6p6pIql2iH5LAKGprW3TZ1M0Ow3DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXdpVco2dVb3A0Fz7vp9qgsphu6ROy/gIdCFjTHjFPAnEkLbn2KW6oy4TlORjDuCt
	 OES8TU/EK3YxMK1UVcw+0eh4523mvKHgg6lojv+LhzYoF01gtvk+reiTknn/xVidJy
	 2uUOFHOv8obAyoe6j13CGf2TuQlhFdP7/NN+2U6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 227/272] drm/amdkfd: fix TLB flush after unmap for GFX9.4.2
Date: Mon,  1 Apr 2024 17:46:57 +0200
Message-ID: <20240401152538.049003572@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Huang <jinhuieric.huang@amd.com>

commit 1210e2f1033dc56b666c9f6dfb761a2d3f9f5d6c upstream.

TLB flush after unmap accidentially was removed on
gfx9.4.2. It is to add it back.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1349,7 +1349,7 @@ void kfd_flush_tlb(struct kfd_process_de
 
 static inline bool kfd_flush_tlb_after_unmap(struct kfd_dev *dev)
 {
-	return KFD_GC_VERSION(dev) > IP_VERSION(9, 4, 2) ||
+	return KFD_GC_VERSION(dev) >= IP_VERSION(9, 4, 2) ||
 	       (KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 1) && dev->sdma_fw_version >= 18) ||
 	       KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 0);
 }


