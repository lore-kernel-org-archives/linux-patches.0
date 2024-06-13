Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB70145359;
	Thu, 13 Jun 2024 12:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280335; cv=none; b=GcK0YauX4H8dZE446r/Siz/Tn53kgloelxUIiUoRd6TnnCb93oGkd0YM+U6lVquVetOK7LZYcK3UshKOYEk7dv9YJyvtZz5eDD7scHy5WUwivqO8Nt9T+vNSGizXPUQFE4mQBqY3gsH9YXXVb/wuFxh4Xs4wCPpK+yz0195wTGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280335; c=relaxed/simple;
	bh=dW1q/yuhHWOymMZkqqG431RPpeD1vNIcUMKGs8hLYN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U+F+EPdAVZCmfHmivKW3XKrywWuZQ57EkwAtMF1BOrk2b7Po7cfld1MRyFf4oDZljgrnnY2UilYZdBHz/Jc/JoJ3dF7J3C/x0Ig7REH/sfAT3nWAvNgnlVI0tRp1uCMIEuhfCaTqiwz4CNg8gYJo5FzHlKByIzVgr9gprRqvOv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaXrYrWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaXrYrWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F07C32786;
	Thu, 13 Jun 2024 12:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280335;
	bh=dW1q/yuhHWOymMZkqqG431RPpeD1vNIcUMKGs8hLYN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaXrYrWIGeuHOB6ZZG4WlZ3EtrTV5oXGA+mo64wH6HKljMadZb0SpxndyqHaEsm42
	 eDDgAx7Xx6wA4Zd9zfNTOwJUDspo9gjF359uEUWdiGnJn+lTak5K2N4BB824STVyDq
	 gjD8QWoNql0j6NhDasisA4eAfIegeWJWb6cBbevA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Le Ma <le.ma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 019/137] drm/amdgpu: add error handle to avoid out-of-bounds
Date: Thu, 13 Jun 2024 13:33:19 +0200
Message-ID: <20240613113224.036090607@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2031,6 +2031,9 @@ static int sdma_v4_0_process_trap_irq(st
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);
+	if (instance < 0)
+		return instance;
+
 	switch (entry->ring_id) {
 	case 0:
 		amdgpu_fence_process(&adev->sdma.instance[instance].ring);


