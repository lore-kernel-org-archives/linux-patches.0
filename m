Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743C12BEFFF;
	Wed,  8 Apr 2026 18:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673892; cv=none; b=kAJSsHgpsxJG54tRe/x1yOU4jELSmHxs48ErYIZHA4VwD6HYPHuppNU/S5xcjx6y1+UT78QI8LcSIQUtESm80hujkh/QneelvrVgqb9E4JdhmhtgI6Js2+Ew1NMviSNZLSy2T8e5UAit1Qwnse13GUtxJGLlDhmRV48KoUdohZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673892; c=relaxed/simple;
	bh=w2K0wtB6HXak9ubKNuZnJAr8OqKjlYSgf8QdFfCWM4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TQwASqXhA9AgKHHT8x8/W6e3yFyQYv34Kz6izkV1xBeG29WyoOq8cC6k+zdN3nxr0BozZnFLxFqZXd1co7wy+LmSPMim8uhjcwpyQ7mt5TPC57ZJUiafnB9iu31rmD1MZp8XErKjYK45HcT4n5CLU3v3YMXVQgmE/qHVtpT8NuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b604gevn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b604gevn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A28AC19421;
	Wed,  8 Apr 2026 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673892;
	bh=w2K0wtB6HXak9ubKNuZnJAr8OqKjlYSgf8QdFfCWM4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b604gevn3Tl8k5n7l559oLySi5nkpZ81wtk4n/YLsL4om8PP4k4GEf9uYMfBoTPWX
	 /UUQ3KRVJk8BY5X3zCofSCYFsbtn6zNeAm+oH6BQhNpYinktcc+p5R2Q1Zo3/igyZ6
	 4p7oqvn23NAX14lAgmGLN7a4zrV/+TN5JhPIa4mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 129/242] drm/amdgpu: fix the idr allocation flags
Date: Wed,  8 Apr 2026 20:02:49 +0200
Message-ID: <20260408175931.919153615@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

commit 62f553d60a801384336f5867967c26ddf3b17038 upstream.

Fix the IDR allocation flags by using atomic GFP
flags in non‑sleepable contexts to avoid the __might_sleep()
complaint.

  268.290239] [drm] Initialized amdgpu 3.64.0 for 0000:03:00.0 on minor 0
[  268.294900] BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
[  268.295355] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1744, name: modprobe
[  268.295705] preempt_count: 1, expected: 0
[  268.295886] RCU nest depth: 0, expected: 0
[  268.296072] 2 locks held by modprobe/1744:
[  268.296077]  #0: ffff8c3a44abd1b8 (&dev->mutex){....}-{4:4}, at: __driver_attach+0xe4/0x210
[  268.296100]  #1: ffffffffc1a6ea78 (amdgpu_pasid_idr_lock){+.+.}-{3:3}, at: amdgpu_pasid_alloc+0x26/0xe0 [amdgpu]
[  268.296494] CPU: 12 UID: 0 PID: 1744 Comm: modprobe Tainted: G     U     OE       6.19.0-custom #16 PREEMPT(voluntary)
[  268.296498] Tainted: [U]=USER, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
[  268.296499] Hardware name: AMD Majolica-RN/Majolica-RN, BIOS RMJ1009A 06/13/2021
[  268.296501] Call Trace:

Fixes: 8f1de51f49be ("drm/amdgpu: prevent immediate PASID reuse case")
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ea56aa2625708eaf96f310032391ff37746310ef)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -68,8 +68,11 @@ int amdgpu_pasid_alloc(unsigned int bits
 		return -EINVAL;
 
 	spin_lock(&amdgpu_pasid_idr_lock);
+	/* TODO: Need to replace the idr with an xarry, and then
+	 * handle the internal locking with ATOMIC safe paths.
+	 */
 	pasid = idr_alloc_cyclic(&amdgpu_pasid_idr, NULL, 1,
-				 1U << bits, GFP_KERNEL);
+				 1U << bits, GFP_ATOMIC);
 	spin_unlock(&amdgpu_pasid_idr_lock);
 
 	if (pasid >= 0)


