Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FED63E;
	Mon,  1 Apr 2024 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990490; cv=none; b=Zm3rxfmNChytmjgSoJXb8TDo0PiwhqKJOnnMwqsTjXZlJ1cUaPVil+erog/DFlHQVwrR0Hjt8l+sDoW4+2o+5KaYpNTuqICgc3KwaV5vW/M3Q11PbPlWU14w4a4FSRRRBYw5a/p2o2w8AxTjjpxX28e/ZweuVXS25LAQfEJQSRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990490; c=relaxed/simple;
	bh=kkjKIQCTttz20BNoFtySvEWvcH0lh5a02zmyzIfozv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmiNnDHt8h27i47u1kyIgVctOGkzNGV/hghCt5Uq8SN07/5uTrj96mRPon9LbAQM781zCLjHrmSH4ZOSFxSm6fkVlUnVCHzaKP42qi2Z44VaZ6UTTYFJ/SWANRDmvoikgYHto+9dY2qFMuxuxOMK13QdKtpGcUeGktvRaZUEzrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDkrqXi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDkrqXi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B595C433C7;
	Mon,  1 Apr 2024 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990489;
	bh=kkjKIQCTttz20BNoFtySvEWvcH0lh5a02zmyzIfozv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDkrqXi6O4dVpAGMlkaeqMZHu74tTKld2UrMQbFDBe/dLzKHDJ7CAGCZ6zum/xXDY
	 urCXslC+nmGDVA1RB+CZ7FuPiMODmNFCSwmyo4QbBvP0Hc8UwCU4E5PMW6CGbYrsJE
	 X6zVCWOPzbCOv9T8qmwtZz0CWm0TNRh+aq0bz4y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 340/396] drm/amdkfd: fix TLB flush after unmap for GFX9.4.2
Date: Mon,  1 Apr 2024 17:46:29 +0200
Message-ID: <20240401152558.050708298@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1466,7 +1466,7 @@ void kfd_flush_tlb(struct kfd_process_de
 
 static inline bool kfd_flush_tlb_after_unmap(struct kfd_dev *dev)
 {
-	return KFD_GC_VERSION(dev) > IP_VERSION(9, 4, 2) ||
+	return KFD_GC_VERSION(dev) >= IP_VERSION(9, 4, 2) ||
 	       (KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 1) && dev->sdma_fw_version >= 18) ||
 	       KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 0);
 }


