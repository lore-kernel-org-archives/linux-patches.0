Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18351448C6;
	Thu, 13 Jun 2024 11:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279298; cv=none; b=WNfb2888txVKQVQFM3VyR3Z2Pi9DdTJAuXHL50Ad8VtH8VMXntCJSLUu4MuBmVBW0LPfiUF93zLu7BnejDXl0uSz6wcTpLFulzG2NyUxCeYtONld+wty74SPm39znBP3dVzzvVQQ6kwwiIPCwAUDyHooI9Wcolb+frL0/1shlAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279298; c=relaxed/simple;
	bh=+NmkCYCzzGn4Q1Zxs4nwC//99o23la8EHcq4lAOZgRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3DpK0Ykl6dM88hy5OWledi9UOmsWWCa+2bOzn78zgO7jG5EtNFGChmOwih+pWeSM4FrEjr5Lb2fm134YBTkPnbKimYHLrR0dTBLZ5yo6gHJmx3TbuCbwpRtxaIRux+W2SGXC+Cigz3DsPLsHQuVRUJcBdMR+kI5Wn7XQt+srkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yegnUSwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yegnUSwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C96C2BBFC;
	Thu, 13 Jun 2024 11:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279298;
	bh=+NmkCYCzzGn4Q1Zxs4nwC//99o23la8EHcq4lAOZgRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yegnUSwWtC4F5qS+F2OdpqYOemnEQVKb/cG0x+Ah4/6k1fwn2lCzRn/BWiVRWmyVg
	 7qhvaqIBtLbkfQzeLTWcC0U+0giyEqHndYBtv+6zcAeG9NWmEh0BKodv+JXDqlcjMs
	 RDb2+d7zLUbf87mpq00d4ZS7PWf2eo0IIS6NS2vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Le Ma <le.ma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 009/157] drm/amdgpu: add error handle to avoid out-of-bounds
Date: Thu, 13 Jun 2024 13:32:14 +0200
Message-ID: <20240613113227.763105460@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2021,6 +2021,9 @@ static int sdma_v4_0_process_trap_irq(st
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);
+	if (instance < 0)
+		return instance;
+
 	switch (entry->ring_id) {
 	case 0:
 		amdgpu_fence_process(&adev->sdma.instance[instance].ring);


