Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8206F2FE;
	Thu, 12 Dec 2024 15:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017962; cv=none; b=P1mCpdZxQrGqe3yWM1Az+kYYmX+/lh5ocpF7wn8/fYv4TIe4oixLT6ZTHfX21NwPlAgYrOuAUg0aYG+gu/Ggg4W8jeOibbt2wuVq2dMwnFLqGx6eUGpwflkYtxVccxDi7GiXkovKnZqPZCF4UizTqcnrRXyNNVkxpHDYclmX508=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017962; c=relaxed/simple;
	bh=syeLXdsQb9KmwodDQ7ph1dxyi3VeHFfAkQAN9H9u9kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2P+CyhURMCvhE6HgNfuzKS/6KeGHFhLRDUXEmSeNLlDkqmB/RqApS0l7HnIKBlM5X4t8nBnMQ42pRfLMh3qECbhMVx0G3zc1xD2iQzAA/UdButWI3hwmb41ozoWcO7P8vlAmQ4g+epayqiiaNUH6tgM/XtPUaLgD/qQyl00dh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxb3RvQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxb3RvQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D966C4CEDD;
	Thu, 12 Dec 2024 15:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017961;
	bh=syeLXdsQb9KmwodDQ7ph1dxyi3VeHFfAkQAN9H9u9kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxb3RvQio/4uajL7jo7O4ZyU6S2q6T4+nhhtfRh6TgaNA1s0YHs03jrmXDSR+OsDT
	 U88QrAAtDcIW/Dpoy3+qlm5ZypNGpj1lFskMMHqIch9yCdAx/SZ941aBPQOwfqpcj1
	 V1Cqi+hHr6yP8SziiFlyds3FdWmjnKcZlHoLdo5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/356] drm/v3d: Enable Performance Counters before clearing them
Date: Thu, 12 Dec 2024 15:57:28 +0100
Message-ID: <20241212144249.750932755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit c98b10496b2f3c4f576af3482c71aadcfcbf765e ]

On the Raspberry Pi 5, performance counters are not being cleared
when `v3d_perfmon_start()` is called, even though we write to the
CLR register. As a result, their values accumulate until they
overflow.

The expected behavior is for performance counters to reset to zero
at the start of a job. When the job finishes and the perfmon is
stopped, the counters should accurately reflect the values for that
specific job.

To ensure this behavior, the performance counters are now enabled
before being cleared. This allows the CLR register to function as
intended, zeroing the counter values when the job begins.

Fixes: 26a4dc29b74a ("drm/v3d: Expose performance counters to userspace")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241204122831.17015-1-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_perfmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/v3d/v3d_perfmon.c b/drivers/gpu/drm/v3d/v3d_perfmon.c
index 73b9c92dc0fc5..141b8abf08629 100644
--- a/drivers/gpu/drm/v3d/v3d_perfmon.c
+++ b/drivers/gpu/drm/v3d/v3d_perfmon.c
@@ -51,9 +51,9 @@ void v3d_perfmon_start(struct v3d_dev *v3d, struct v3d_perfmon *perfmon)
 		V3D_CORE_WRITE(0, V3D_V4_PCTR_0_SRC_X(source), channel);
 	}
 
+	V3D_CORE_WRITE(0, V3D_V4_PCTR_0_EN, mask);
 	V3D_CORE_WRITE(0, V3D_V4_PCTR_0_CLR, mask);
 	V3D_CORE_WRITE(0, V3D_PCTR_0_OVERFLOW, mask);
-	V3D_CORE_WRITE(0, V3D_V4_PCTR_0_EN, mask);
 
 	v3d->active_perfmon = perfmon;
 }
-- 
2.43.0



