Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1974F4CF5;
	Thu, 17 Sep 2026 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661271; cv=none; b=oWdVhiySAqv2o/CtuHXNz0gFTW7yYv/o04G5gELswOI43SLH7i2TSKmW2E5DLWd9N1wHg8BCK1xT+2V4tVqZNTtbXVhvLmX/q1zq1X9Ik3YlZnhHf/Hw9PQCt++ueorGln8W2myHtPLBytxd1Pd4XzdoqnOptuMeypXmCu/irow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661271; c=relaxed/simple;
	bh=vCKURV5mzqc+f8v+ZDI/YEIbBQipxFit3HIect8JHeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8Lbfuj2P7wBMKg+MVJsxDR8rO3JBjbjMrggIvphrRuSKeVXRPtJ0KN45H+XnTNfy4PJyMPVFz2bEy/lxD/eSY2pa/PHA953OYalkLFRyI+vbvsGmzGfz/OoPjrMwOvfL2M42uvgWXbDWDIDkbq6TU/WMVPPIoW099dn5NUUkNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7OW4k51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7OW4k51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229381F000FF;
	Thu, 17 Sep 2026 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661270;
	bh=uL5sUvM9gQycdWScrRDk9m+4sY52pltHmbi2im0oSyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7OW4k51URV4x5LAfze5tljMvIlIfn+X6E1sZ1gCDUryj2ut+piO3LXzBm3EuaOO0
	 CGmYBIYx8yAkSnApj1rr8qL4vVrKdIIbLht8Cn7I806oYHgk/tNNoh5QCA4IdfLf77
	 1m4XQdlF1KEhDZproHWe0HiaSzoyHVv/3Mf+U+TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0140/1250] drm/amdgpu: use atomic operation to achieve lockless serialization
Date: Thu, 17 Sep 2026 15:58:55 +0100
Message-ID: <20260917151555.848963969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit 4d50a14d346141e03a7c3905e496d91e048bc30c ]

In amdgpu_seq64_alloc there is a possibility that two difference cores
from two separate NODES can try to and could get the same free slot.
So this fixes that race here using atomic test_and_set clear operations.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
index a0b479d5fff19..f4be192235889 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
@@ -175,11 +175,14 @@ int amdgpu_seq64_alloc(struct amdgpu_device *adev, u64 *va,
 {
 	unsigned long bit_pos;
 
-	bit_pos = find_first_zero_bit(adev->seq64.used, adev->seq64.num_sem);
-	if (bit_pos >= adev->seq64.num_sem)
-		return -ENOSPC;
+	for (;;) {
+		bit_pos = find_first_zero_bit(adev->seq64.used, adev->seq64.num_sem);
+		if (bit_pos >= adev->seq64.num_sem)
+			return -ENOSPC;
 
-	__set_bit(bit_pos, adev->seq64.used);
+		if (!test_and_set_bit(bit_pos, adev->seq64.used))
+			break;
+	}
 
 	*va = bit_pos * sizeof(u64) + amdgpu_seq64_get_va_base(adev);
 
@@ -205,7 +208,7 @@ void amdgpu_seq64_free(struct amdgpu_device *adev, u64 va)
 
 	bit_pos = (va - amdgpu_seq64_get_va_base(adev)) / sizeof(u64);
 	if (bit_pos < adev->seq64.num_sem)
-		__clear_bit(bit_pos, adev->seq64.used);
+		clear_bit(bit_pos, adev->seq64.used);
 }
 
 /**
-- 
2.53.0



