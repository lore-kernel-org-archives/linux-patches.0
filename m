Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092061A841C;
	Wed, 19 Mar 2025 14:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395145; cv=none; b=c22o4NXwYl0ClOT/mTScr7ce3NhWf18wMAJ9LnAaTV0P4zy9wFNHb5UR9ghWwaLQ5evZ4nADsh2zBcvwkg1ndNrl1SY8n2gJD9gPA5UQ+8nX/naKWBceFJKH/BJt+IRLxnGYBi/AA4OwjAkxfHz5QBr6nb7DgUKM7gPUl97kRCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395145; c=relaxed/simple;
	bh=WzGjFRhq1v9ENcZGAGZaGSD8HlLPevsf1uREkNmUXYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoBx0lCGvOBvorE7+8j/rybqR2yjpLt39Y7HgnYm1J1FyryfzHM8yzRUti1SwTbUMNd/ZCKIQSsB/0uqjwUgNS3Mx0o9VgSknSIE7Js2z5ZsH0DIULcYsFnAjBi7vglwWV4ULUrDBzdcQjOG8RYLhqeMireUBEaVKGVprueKPXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAX7Aszq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAX7Aszq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4095C4CEE4;
	Wed, 19 Mar 2025 14:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395144;
	bh=WzGjFRhq1v9ENcZGAGZaGSD8HlLPevsf1uREkNmUXYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAX7AszqOyYPi+W0RyvFJvTuNX06pFMqffMHPYUZu6odzNzut9wCg0I20zCECDIc7
	 I0hZ7hirsLy8vDbz8JI6fJSovAQFalTZ3lb24QMdTq3flQP58a9eJgn6ZljUA2NINW
	 swBoUBgqiu01PwQyZYf+wdrPiJKeM1sFJAfIVD4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Yifan Zha <Yifan.Zha@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 175/231] drm/amd/amdkfd: Evict all queues even HWS remove queue failed
Date: Wed, 19 Mar 2025 07:31:08 -0700
Message-ID: <20250319143031.163368233@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zha <Yifan.Zha@amd.com>

commit 0882ca4eecfe8b0013f339144acf886a0a0de41f upstream.

[Why]
If reset is detected and kfd need to evict working queues, HWS moving queue will be failed.
Then remaining queues are not evicted and in active state.

After reset done, kfd uses HWS to termination remaining activated queues but HWS is resetted.
So remove queue will be failed again.

[How]
Keep removing all queues even if HWS returns failed.
It will not affect cpsch as it checks reset_domain->sem.

v2: If any queue failed, evict queue returns error.
v3: Declare err inside the if-block.

Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Yifan Zha <Yifan.Zha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 42c854b8fb0cce512534aa2b7141948e80c6ebb0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1199,11 +1199,13 @@ static int evict_process_queues_cpsch(st
 		decrement_queue_count(dqm, qpd, q);
 
 		if (dqm->dev->kfd->shared_resources.enable_mes) {
-			retval = remove_queue_mes(dqm, q, qpd);
-			if (retval) {
+			int err;
+
+			err = remove_queue_mes(dqm, q, qpd);
+			if (err) {
 				dev_err(dev, "Failed to evict queue %d\n",
 					q->properties.queue_id);
-				goto out;
+				retval = err;
 			}
 		}
 	}


