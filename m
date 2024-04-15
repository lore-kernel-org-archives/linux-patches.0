Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB6378685;
	Mon, 15 Apr 2024 14:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191912; cv=none; b=PjAzz4TA3SVl+mVGvY/QUKrj7km3k38nW0rQS+QPuZ5bZwfiiLsU3T14tBY7hBm4BneQ0cr1AGMbIqGu95aTR0RXW8UW/myPNaSuGvzZL5h8Jr4gwaQNoMvWHu3IM5BLu/QLENziLroUaaCKoOH0eqtMSDvZ3kgXerdjXbV69zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191912; c=relaxed/simple;
	bh=d5M6rfrRhvUaHwBxEu3ERiV1+LvGQNsbtfVESlKLTi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPextSpq3gOBil7UYJ72y5OOKHID2XnQB/2RvzuzEwf3sG+7EwlMIwMkM4h82ytgSnQjip4pyelgt8bWQUS5vXVFoEfQt46o5vAuOGzHPqpqrcrg06Sf+pluIzShJq6f84hNcicRjsVNnCrV4N1Bx+Y6pSjBeNLm1n8sAJc45Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmCBiyUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmCBiyUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564B0C2BD11;
	Mon, 15 Apr 2024 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191911;
	bh=d5M6rfrRhvUaHwBxEu3ERiV1+LvGQNsbtfVESlKLTi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmCBiyUH7JYeNMDX13l4aO+pST0a5x9/GOM1C3RIx6PnLwo0Kg62PDg063dXGRzYy
	 SWoZFhubhcPlmt8k/f9ife4Rq/aifS9X+wcoarFDQW4+mW1oC0WJHquGOHF9fPx2eI
	 ymNWgS6uXBWPuNT8F5/QoU0TZSqvTV5bTzRrRymE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>
Subject: [PATCH 6.6 090/122] drm/amdkfd: Reset GPU on queue preemption failure
Date: Mon, 15 Apr 2024 16:20:55 +0200
Message-ID: <20240415141956.076198252@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

commit 8bdfb4ea95ca738d33ef71376c21eba20130f2eb upstream.

Currently, with F32 HWS GPU reset is only when unmap queue fails.

However, if compute queue doesn't repond to preemption request in time
unmap will return without any error. In this case, only preemption error
is logged and Reset is not triggered. Call GPU reset in this case also.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1980,6 +1980,7 @@ static int unmap_queues_cpsch(struct dev
 		pr_err("HIQ MQD's queue_doorbell_id0 is not 0, Queue preemption time out\n");
 		while (halt_if_hws_hang)
 			schedule();
+		kfd_hws_hang(dqm);
 		return -ETIME;
 	}
 


