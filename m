Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CA732AAB5;
	Fri,  9 Jan 2026 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959101; cv=none; b=nO65PLS6YCTqp5mLksl/lnajKbf+FqtR1szgL19io8Ko+nIfrv8oPZ+QQFW+YBWQM/k42/onyUe0JeXnhKtxgQDkNEGqf1OZWIL2MChSGll+x+2awecs0svWG5mIz1Y/3HVoJc+/+EJKkpGto6YupkNxDoWXIucxdEUS03sP42A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959101; c=relaxed/simple;
	bh=ESAwJg5GC7gopkhc1sBp4OowaDlWKa9bQHBOTp2aonk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aTGTPwEYhg9ub662o7AtANALYXsDwRsBu6hymictSRwIelN04J2efIoDWcpBW2AM83KFA7K5aCNyAlkjK846/4vwm6nkkIsr9TF48tXzVd2jFHbiQ7lK3l5cqTVPgwALpdLx2FM3q6DQOuXAVENlA0EYXos22lYCIMmM+U0vBWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4qFnEvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4qFnEvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05A3C4CEF1;
	Fri,  9 Jan 2026 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959099;
	bh=ESAwJg5GC7gopkhc1sBp4OowaDlWKa9bQHBOTp2aonk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4qFnEvxKTBKO4n69onVqOzU8D/E1XCN4iV65PqTb+3vybfnbMi0q9WLdIijjzPYn
	 2b2mV6ZIzRVNCKXuhuYy1oUlG859/F5w3nFjjV1D4n3uJ0jnMQgNPuZPnk97jNen36
	 1S88j/49PVUXS0LpxUG3eTLnuTVwQCUxdTk0yZaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 08/16] drm/amdgpu: Forward VMID reservation errors
Date: Fri,  9 Jan 2026 12:43:49 +0100
Message-ID: <20260109111951.736965048@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
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

From: Natalie Vock <natalie.vock@gmx.de>

[ Upstream commit 8defb4f081a5feccc3ea8372d0c7af3522124e1f ]

Otherwise userspace may be fooled into believing it has a reserved VMID
when in reality it doesn't, ultimately leading to GPU hangs when SPM is
used.

Fixes: 80e709ee6ecc ("drm/amdgpu: add option params to enforce process isolation between graphics and compute")
Cc: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ adapted 3-argument amdgpu_vmid_alloc_reserved(adev, vm, vmhub) call to 2-argument version and added separate error check to preserve reserved_vmid tracking logic. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2747,10 +2747,12 @@ int amdgpu_vm_ioctl(struct drm_device *d
 	case AMDGPU_VM_OP_RESERVE_VMID:
 		/* We only have requirement to reserve vmid from gfxhub */
 		if (!fpriv->vm.reserved_vmid[AMDGPU_GFXHUB(0)]) {
-			amdgpu_vmid_alloc_reserved(adev, AMDGPU_GFXHUB(0));
+			int r = amdgpu_vmid_alloc_reserved(adev, AMDGPU_GFXHUB(0));
+
+			if (r)
+				return r;
 			fpriv->vm.reserved_vmid[AMDGPU_GFXHUB(0)] = true;
 		}
-
 		break;
 	case AMDGPU_VM_OP_UNRESERVE_VMID:
 		if (fpriv->vm.reserved_vmid[AMDGPU_GFXHUB(0)]) {


