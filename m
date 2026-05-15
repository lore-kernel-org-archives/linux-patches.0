Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEA31DC9B3;
	Fri, 15 May 2026 15:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860397; cv=none; b=QJqxO1PZ+9DZwQrQtPpVr/1HVSFvdwJ5+OeYzMoRbhabZk/jNBfT0eYrJ8DxbkgWsWz3BsLOIthjcsFTTtmI3LR/SYiYccmV7R7IjJafmy08uv3m+h5pfKsR4e5zLfHEdgpMrMrarjkbEjIqwBv64x57s3TuA33Tky7hP3kFV0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860397; c=relaxed/simple;
	bh=moAgwfALQpcH1pMZmRq6niYJo7euRGaxXPfFYW8BRaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrHWmLs/itz18uu5cVCfrTu/Lb+N+Kb2FYAcB9DDzFXsMHaoWEphDkvTKLgPRdK1LrtJHF4dIEmlF/kuBBjs3dqZo02f1B1n3XkgpHNY6SwJM09KFqdQR7WOIElLllPkF2Nmc3EMHi3m2Nt8C2H3NMzDy2fXy/RLqOpry2yhsRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHar06Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHar06Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E8DC2BCC9;
	Fri, 15 May 2026 15:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860397;
	bh=moAgwfALQpcH1pMZmRq6niYJo7euRGaxXPfFYW8BRaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHar06CyOivRrarNblkEs5hNvWsy+XJsFnMxSPTsVmOsBEiHnm7C51twqacdZbi4H
	 N+k44bFSSsphwjX8ycAussVERhKk4C7se/3O+DvRV916ArlwAv+Z4YPPl8vzbhfkOQ
	 yH/2M+NG6/KsFn/mmcecw7yNPb9cHj8Znfll7V5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 074/144] drm/amdgpu/vce: Prevent partial address patches
Date: Fri, 15 May 2026 17:48:20 +0200
Message-ID: <20260515154655.250351918@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit de2a02cc28d6d5d37db07d00a9a684c754a5fd74 upstream.

In the case that only one of lo/hi is valid, the patching could result
in a bad address written to in FW.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -655,6 +655,9 @@ static int amdgpu_vce_cs_reloc(struct am
 	uint64_t addr;
 	int r;
 
+	if (lo >= ib->length_dw || hi >= ib->length_dw)
+		return -EINVAL;
+
 	if (index == 0xffffffff)
 		index = 0;
 


