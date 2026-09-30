Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF4151596E;
	Wed, 30 Sep 2026 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787603; cv=none; b=Mthlx7iQh8Cr5lzL0ui4zhzLxLgb92PWil5Npc6Wwo8hyb6ZcyTD87QNJGnIZP5733pR3K45itbPpPQyz7uUbmrpf+2vJJ5IEu1OTV3alBwH1vsHLxtxxe1lQWAQE4PJTgy5C9z0YVMy4AkR6A7bc54H45dWSjveepG+gCpkHFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787603; c=relaxed/simple;
	bh=XHyc9OOttYn6ve+M3vc9umOswNAmCB1RGe4Qj3yioSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l330BfP4jd008dvqzcMaNL0RNgc95i4HIGY8fQWxXR6m88t0jyG5WErkZJmnv2cG67ACTKZQXi2dozzx8ig2DwSn8U1IuKu70PupLI/IcpDH8J28h8nfKW3KuEhbp/Evs/vMZgTvaVHQrTaFD0tHk9GCDd7Oh2fNoIEShXjQgws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuMlEfxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuMlEfxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28091F000FF;
	Wed, 30 Sep 2026 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787602;
	bh=5VE8+H/Ta/YqklP4MAtWdHjyZ4kB0lsXab7TK/zRjoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuMlEfxlHFni46y5XGqFRpsTbgx9LUQpFCgVbCx0GFCSN00G+SVPpUlFPOYdbvTG4
	 oJZnRFWGm3Oeqb8hI9/tp+nYk8f1w1gcgIVD0b/FUV3+xfinvsyZ8CrtwTodQMcLy7
	 S/S7amIUJL9fU86eQDTpPzbj3jysdld9y/m7fZC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jesse.Zhang" <Jesse.Zhang@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 287/457] drm/amdgpu/vcn5.0.1: fix video_timeout unit mismatch in jpeg reset wait
Date: Wed, 30 Sep 2026 17:26:32 +0200
Message-ID: <20260930152352.228561537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit f952ed353a27b46c86c9525a39b7a642850b8139 upstream.

vcn_v5_0_1_reset_jpeg_pre_helper() passes adev->video_timeout directly
to amdgpu_fence_wait_polling(), whose timeout parameter is documented
and implemented in usecs (busy-wait loop decrementing by udelay(2)).

adev->video_timeout is set in jiffies by
amdgpu_device_get_job_timeout_settings(), via msecs_to_jiffies().
Passing it unconverted means the intended ~2s wait for outstanding
JPEG fences to complete before the JPEG queue is torn down actually
lasts only a couple of microseconds (HZ jiffies interpreted as usecs),
so pending jobs are almost never given a real chance to finish before
the reset path forces completion in the following helper.

Convert the jiffies value to usecs with jiffies_to_usecs() before
passing it to amdgpu_fence_wait_polling().

Fixes: fab47d2db5ca ("drm/amdgpu/vcn5.0.1: rework reset handling")
Cc: Jesse.Zhang <Jesse.Zhang@amd.com>
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b8334fec8b90ebffcaa01001a23edca9f29a05e9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -1318,7 +1318,8 @@ static int vcn_v5_0_1_reset_jpeg_pre_hel
 		/* if Jobs are still pending after timeout,
 		 * We'll handle them in the bottom helper
 		 */
-		amdgpu_fence_wait_polling(ring, wait_seq, adev->video_timeout);
+		amdgpu_fence_wait_polling(ring, wait_seq,
+					  jiffies_to_usecs(adev->video_timeout));
        }
 
 	return 0;


