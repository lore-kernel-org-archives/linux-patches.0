Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1FC76025;
	Mon, 15 Apr 2024 14:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191037; cv=none; b=Ni/sGCYRQmB0K/9x6af9uek6Obqkp2LJrzLkB/FoPlAI+iAQADYR0VFYpht+xwGeM5xOiru0VDFEW7PvjtSy/7ccEk440DiUwWRVI+XlIqFkXBazRBiyG403K1W2lZTpnOViTLMRROqjXKQD68oMrfJj8ETrWcO03EUbVGeW4MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191037; c=relaxed/simple;
	bh=E8hqykKvOejQiwkp8fIbGFLCn+jrcfRHIrAzVFLTrnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPwKIg/nUyWBTNOI7/wPdhvbB1NawDZx0SGOlnusYJMzjJaGBA4YXhYOIxov+ksc3VtZLmJcc7QJLgkdY48TWyxbY2blUjJASTNpTTjHORGK5j7VkeMz4w1Q8l6iX880+zjEGNKPO8S5exTqLqzUap6xdDrLmXOivPCkPX3s61g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kf+uIoMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kf+uIoMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F31C113CC;
	Mon, 15 Apr 2024 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191037;
	bh=E8hqykKvOejQiwkp8fIbGFLCn+jrcfRHIrAzVFLTrnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kf+uIoMDZKUU574lgKp0qo/xKiu4P8CPN2ekQx86s2XGRFLaQk0SW66tWYARtVJrU
	 WdYkB9SruiDwQugxiZO8C5ZWgeijpCtYFYEoGNAbVLtjQ+ABL+wmkhdP75wS1Dyi93
	 35vp8247IA3cI4XTwlWU+aBO+7IkMzLE/rhSQAHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peyton Lee <peytolee@amd.com>,
	Lang Yu <lang.yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Gong, Richard" <richard.gong@amd.com>
Subject: [PATCH 6.8 004/172] drm/amdgpu/vpe: power on vpe when hw_init
Date: Mon, 15 Apr 2024 16:18:23 +0200
Message-ID: <20240415142000.108719013@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peyton Lee <peytolee@amd.com>

commit eed14eb48ee176fe0144c6a999d00c855d0b199b upstream.

To fix mode2 reset failure.
Should power on VPE when hw_init.

Signed-off-by: Peyton Lee <peytolee@amd.com>
Reviewed-by: Lang Yu <lang.yu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Gong, Richard" <richard.gong@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c
@@ -390,6 +390,12 @@ static int vpe_hw_init(void *handle)
 	struct amdgpu_vpe *vpe = &adev->vpe;
 	int ret;
 
+	/* Power on VPE */
+	ret = amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VPE,
+						     AMD_PG_STATE_UNGATE);
+	if (ret)
+		return ret;
+
 	ret = vpe_load_microcode(vpe);
 	if (ret)
 		return ret;


