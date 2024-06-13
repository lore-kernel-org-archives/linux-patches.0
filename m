Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4029C1411C5;
	Thu, 13 Jun 2024 12:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281501; cv=none; b=Wzw5Xq/lzN/wHFlaoQmEaqrwjXd5zhGiZUwpqDL2PptycYXAkCK1NFNMnN/L2NbKSaV3W0xFy/w1YZHebLJPv7cuXaDhCwyb7tP3Uf/Kke6l3K4kKailmV35papA2fONG2kNzXjThrNgmifIO4j4z6LiBrJf5fbp1+SmpanwPRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281501; c=relaxed/simple;
	bh=Yn7WeUE3bUb9DmZMZCyUaO3Sw2T9QYapMBS3p1EOrdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WH4zEijtNxxpw8QMegu3Rqf85uoLEXARAXDWOxk4NwjoCRPGYIi3sxdmmoyQHgUL+hYY5aWrTsszhtFcyNKrVRduWhsKKaMQ+hkZ2OI/JEGImmmwtW/Rabgje4EDZgux0Vk5Bsge+k2fOcmmCRMKNEUc0kvkW+arab1jVCnsC10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AVEhmCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AVEhmCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF5DC2BBFC;
	Thu, 13 Jun 2024 12:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281501;
	bh=Yn7WeUE3bUb9DmZMZCyUaO3Sw2T9QYapMBS3p1EOrdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AVEhmCez4AZVA6GDKz1Ga631+Lw8SZAMywPAeXxtCypUoyyl+Eh8jqu9/p6Snaqe
	 vPMcyuGJhQTylz2ts4WIkTfM8x0xX51DKbkcdlzd56p+CaIpTAEbmhO/dBQv87/F0+
	 QJ9QKk4MDqlllx6gAEE6MHbTxH7lCnywQTLhiAes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Le Ma <le.ma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 277/317] drm/amdgpu: add error handle to avoid out-of-bounds
Date: Thu, 13 Jun 2024 13:34:55 +0200
Message-ID: <20240613113258.267295131@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Zhou <bob.zhou@amd.com>

commit 8b2faf1a4f3b6c748c0da36cda865a226534d520 upstream.

if the sdma_v4_0_irq_id_to_seq return -EINVAL, the process should
be stop to avoid out-of-bounds read, so directly return -EINVAL.

Signed-off-by: Bob Zhou <bob.zhou@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Le Ma <le.ma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2073,6 +2073,9 @@ static int sdma_v4_0_process_trap_irq(st
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);
+	if (instance < 0)
+		return instance;
+
 	switch (entry->ring_id) {
 	case 0:
 		amdgpu_fence_process(&adev->sdma.instance[instance].ring);


