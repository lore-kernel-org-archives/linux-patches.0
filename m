Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6621F4275;
	Tue, 21 Jan 2025 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482551; cv=none; b=pjQpnV4ej5/nxRncmuSJ+VjXY+sglTky/urEhglRdSvSsN8VF3Ula63sAzKmVDrGeq8OW+lgXwfuAPHKZQFUyxWF9Zp+wqytL2HiW7W2QLmTCWYuCXjH1DhSpX5vkV4cUjOSjwygHQ0Fdjd4tlKCadraokNPXsFP4ouvsqyw4Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482551; c=relaxed/simple;
	bh=RtEJTIFR8Xl9c11f9WY45in3FLjYL9k4sdga5Jaujzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk6kRQ9FMt/WFq7CajlHIZdNGgd1iNBnQkdBcmu6bJ/OB3X3BeDok5QlgY3PckM5Bf6AQDyocUPKyUke9VTFgq2HcBXYCBnmKcSnk6hhCeKbxIKGid3GgPDewq9QvSi6ybZ4jm+7HnqQtSblkG4vBMLy+jkz39aDVlgTnXr5BhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxR3OTPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxR3OTPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC0EC4CEDF;
	Tue, 21 Jan 2025 18:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482551;
	bh=RtEJTIFR8Xl9c11f9WY45in3FLjYL9k4sdga5Jaujzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxR3OTPoH18QBucK7rx0J3KTriENtx8fTZDqE0XOEdBNaJU0Z2l9Jpp8pfKZDj8GL
	 F9XebwATOnl2zpxn9n5nrlqfM3/9G8wFlWELblxWqL4Hi8MCK362/wXej+RctZIyt6
	 5Uukcflk7mVDshiqJT3Z24bpb/c65MLysZiBz/fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 115/122] drm/amdgpu: disable gfxoff with the compute workload on gfx12
Date: Tue, 21 Jan 2025 18:52:43 +0100
Message-ID: <20250121174537.486994248@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Kenneth Feng <kenneth.feng@amd.com>

commit 90505894c4ed581318836b792c57723df491cb91 upstream.

Disable gfxoff with the compute workload on gfx12. This is a
workaround for the opencl test failure.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2affe2bbc997b3920045c2c434e480c81a5f9707)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index 3afcd1e8aa54..c4e733c2e75e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -715,8 +715,9 @@ int amdgpu_amdkfd_submit_ib(struct amdgpu_device *adev,
 void amdgpu_amdkfd_set_compute_idle(struct amdgpu_device *adev, bool idle)
 {
 	enum amd_powergating_state state = idle ? AMD_PG_STATE_GATE : AMD_PG_STATE_UNGATE;
-	if (IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 11 &&
-	    ((adev->mes.kiq_version & AMDGPU_MES_VERSION_MASK) <= 64)) {
+	if ((IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 11 &&
+	    ((adev->mes.kiq_version & AMDGPU_MES_VERSION_MASK) <= 64)) ||
+		(IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 12)) {
 		pr_debug("GFXOFF is %s\n", idle ? "enabled" : "disabled");
 		amdgpu_gfx_off_ctrl(adev, idle);
 	} else if ((IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 9) &&
-- 
2.48.1



