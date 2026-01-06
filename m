Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74992F7AAC;
	Tue,  6 Jan 2026 18:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722468; cv=none; b=Yf+14M9P7iFYMFktT/4LYUOC9ZzOwymvy6ppqeLFx57SmOxuaXqoDxhjk4nuOqTgWJh2B3SDt0j+QLk8g5C8jg+871JZAXbZeuTdEnawEyTF0OroXK5K7wCMk6tha2LXPTekH0dFQSe5azez0aJiOTpZlKLzvcvG0A0LqlnWFAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722468; c=relaxed/simple;
	bh=HeRelvJKt+62oarx6iCC5xiEJTzV7wTKYrB9XbEB5xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JtDoMqZi+WXQ54JgaKF5eFDmEmoutEaPA0XaKhd6bt1eQZjmdWL5WtSI/zZ+sJxwjFMFiqsZeRwpun/XR16xcFHTUHMmPWox+96BEWgdl+3PclWXx9lQpa/Q8qytaEr6U2HcXwiinYdkXw1jJ36PcqsAQ87avuPM9PnA20ANAmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Te+UjV2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Te+UjV2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCDAC116C6;
	Tue,  6 Jan 2026 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722468;
	bh=HeRelvJKt+62oarx6iCC5xiEJTzV7wTKYrB9XbEB5xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Te+UjV2x9YhH5GmXM9xj0+roj/KGUfMmewpK/jl1tjDjWyx3qH4qFMgK5lIESoZ9S
	 cU5h0qPMtMpWI7Fy9gZutxAiLFjLm+aNEAnM7MftAeA0CPWjTRZ482HrGjLsrxyfK1
	 P/3lBHjbMI9gW/1ymOk9V58TaqH6boOwZuvmYth4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Subject: [PATCH 6.18 266/312] drm/amdgpu/sdma6: Update SDMA 6.0.3 FW version to include UMQ protected-fence fix
Date: Tue,  6 Jan 2026 18:05:40 +0100
Message-ID: <20260106170557.468356311@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit c8e7e3c2215e286ebfe66fe828ed426546c519e6 upstream.

On GFX11.0.3, earlier SDMA firmware versions issue the
PROTECTED_FENCE write from the user VMID (e.g. VMID 8) instead of
VMID 0. This causes a GPU VM protection fault when SDMA tries to
write the secure fence location, as seen in the UMQ SDMA test
(cs-sdma-with-IP-DMA-UMQ)

Fixes the below GPU page fault:
[  514.037189] amdgpu 0000:0b:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:40 vmid:8 pasid:32770)
[  514.037199] amdgpu 0000:0b:00.0: amdgpu:  Process  pid 0 thread  pid 0
[  514.037205] amdgpu 0000:0b:00.0: amdgpu:   in page starting at address 0x00007fff00409000 from client 10
[  514.037212] amdgpu 0000:0b:00.0: amdgpu: GCVM_L2_PROTECTION_FAULT_STATUS:0x00841A51
[  514.037217] amdgpu 0000:0b:00.0: amdgpu:      Faulty UTCL2 client ID: SDMA0 (0xd)
[  514.037223] amdgpu 0000:0b:00.0: amdgpu:      MORE_FAULTS: 0x1
[  514.037227] amdgpu 0000:0b:00.0: amdgpu:      WALKER_ERROR: 0x0
[  514.037232] amdgpu 0000:0b:00.0: amdgpu:      PERMISSION_FAULTS: 0x5
[  514.037236] amdgpu 0000:0b:00.0: amdgpu:      MAPPING_ERROR: 0x0
[  514.037241] amdgpu 0000:0b:00.0: amdgpu:      RW: 0x1

v2: Updated commit message
v3: s/gfx11.0.3/sdma 6.0.3/ in patch title (Alex)

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
@@ -1389,7 +1389,7 @@ static int sdma_v6_0_sw_init(struct amdg
 			adev->userq_funcs[AMDGPU_HW_IP_DMA] = &userq_mes_funcs;
 		break;
 	case IP_VERSION(6, 0, 3):
-		if ((adev->sdma.instance[0].fw_version >= 27) && !adev->sdma.disable_uq)
+		if (adev->sdma.instance[0].fw_version >= 29 && !adev->sdma.disable_uq)
 			adev->userq_funcs[AMDGPU_HW_IP_DMA] = &userq_mes_funcs;
 		break;
 	case IP_VERSION(6, 1, 0):


