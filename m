Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5AD182DF
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjGxg31b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA381C433C7;
	Mon,  9 Oct 2023 13:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856972;
	bh=FNk55jDiMxkxetK6BAQtw71JnC9GF5QkmSRsWwQEPe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjGxg31bKp+cedWpmHOAjJxok9yl38GjkgW6tsztpj4a4qErfIE//wM82gqcxIrFB
	 jhVMQuo4bD5aFkIDgISsu0wytaj/Qz3EsHYGjRgDII+Q+A+fiKdOP2mtuIfzpWlG18
	 OwWs7vdQ8HFYJwzT+JmzzP8GFgcc5OdqkGTx+Nvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Ma <Jun.Ma2@amd.com>,
	David Perry <David.Perry@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 052/163] drm/amd: Fix detection of _PR3 on the PCIe root port
Date: Mon,  9 Oct 2023 15:00:16 +0200
Message-ID: <20231009130125.473204757@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 134b8c5d8674e7cde380f82e9aedfd46dcdd16f7 upstream.

On some systems with Navi3x dGPU will attempt to use BACO for runtime
PM but fails to resume properly.  This is because on these systems
the root port goes into D3cold which is incompatible with BACO.

This happens because in this case dGPU is connected to a bridge between
root port which causes BOCO detection logic to fail.  Fix the intent of
the logic by looking at root port, not the immediate upstream bridge for
_PR3.

Cc: stable@vger.kernel.org
Suggested-by: Jun Ma <Jun.Ma2@amd.com>
Tested-by: David Perry <David.Perry@amd.com>
Fixes: b10c1c5b3a4e ("drm/amdgpu: add check for ACPI power resources")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2308,7 +2308,7 @@ static int amdgpu_device_ip_early_init(s
 		adev->flags |= AMD_IS_PX;
 
 	if (!(adev->flags & AMD_IS_APU)) {
-		parent = pci_upstream_bridge(adev->pdev);
+		parent = pcie_find_root_port(adev->pdev);
 		adev->has_pr3 = parent ? pci_pr3_present(parent) : false;
 	}
 


