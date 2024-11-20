Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8E41A704B;
	Wed, 20 Nov 2024 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107714; cv=none; b=qM8d9NPwko+Y5vxz6HFfOpNpth/K3HnSPZwRGJkxShaVCsMdfopOBLDt6YBQ4cCMXZ83NvBj0X0kiC5QjKe69NWkPVrwzhk5VKvuP1QwbZWcEaVTwNF/KX9rRxn9swIqMsplwZsAYVK/TcvXGJ/QB8O5TmiwBhzPB/cHZeFHWMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107714; c=relaxed/simple;
	bh=5bxp5dxPM9s/tZEOCMfX5k6+Oi5wtpM5bZ9I2J7RPxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLhh0GLgc02H0nc5Mk11x3jFBgKhHWnc1uN+YBAq7ih9ccOfV0zRLzEWazSJPGeCWagGACqD48W6DnzWWNXyhpHqq6xPFhRgAaPbm1bN27HVkRKVPtrJNL9PWgeZKorYeCNibw4KYlcVYmpAvIc89ULIbwAntCoaqmkO7z6lH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVYgS1RA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVYgS1RA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448F8C4CECD;
	Wed, 20 Nov 2024 13:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107714;
	bh=5bxp5dxPM9s/tZEOCMfX5k6+Oi5wtpM5bZ9I2J7RPxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVYgS1RAv+VL5mGoX0jm0vAt8IaP1PMhy2E/bYoVI1quiG2T37MF5mc+volYk3k7L
	 oc1K8x/n11JK4MyDS0bYXzGDecObVoHBUh4YAddPakgGAkKEPzJm3JVKjoslJhCZaP
	 TLtjwshYh2jRRcCdQWhPDVDd94VyMmWJyJiePCT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Jingwen Chen <Jingwen.Chen2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.1 66/73] drm/amd: check num of link levels when update pcie param
Date: Wed, 20 Nov 2024 13:58:52 +0100
Message-ID: <20241120125811.194122106@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin.Cao <lincao12@amd.com>

commit 406e8845356d18bdf3d3a23b347faf67706472ec upstream.

In SR-IOV environment, the value of pcie_table->num_of_link_levels will
be 0, and num_of_levels - 1 will cause array index out of bounds

Signed-off-by: Lin.Cao <lincao12@amd.com>
Acked-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ Resolve minor conflicts to fix CVE-2023-52812 ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2498,6 +2498,9 @@ int smu_v13_0_update_pcie_parameters(str
 	uint32_t smu_pcie_arg;
 	int ret, i;
 
+	if (!num_of_levels)
+		return 0;
+
 	if (!amdgpu_device_pcie_dynamic_switching_supported()) {
 		if (pcie_table->pcie_gen[num_of_levels - 1] < pcie_gen_cap)
 			pcie_gen_cap = pcie_table->pcie_gen[num_of_levels - 1];


