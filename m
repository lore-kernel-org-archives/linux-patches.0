Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8033573466;
	Tue, 27 Aug 2024 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771149; cv=none; b=E6z/kFfNQdNRDQ6CZ2CXuobp7wBBJ9boXd4rEhpCbUwPgyLymwmWrQEarvdTPVgVjSoZwEzJpl2jFRrh6qPGwrLrM8KemNFfzmlwAvg8pY15MupcGd45WEH/o5JPmAYoR9rRDAUvj2s95zKDtPywjkgMoPaNmiXa0+TLIhD/Qs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771149; c=relaxed/simple;
	bh=QkxtvJPzg2gZlok0EPU1QaTkk+fKA6rh5WkVAYxx01E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVn5xOnJUT8gIr+H0KLc2u2+ynaVyX9XmAfDD4n98KRE5SbltXdKh6TpnvWIfJXFn6P8hzVcGodS0zxcHmpvCu9CsQeHalpbXVbjKDUsHWNjgkiwP83W2GpR1L/vnm7VJvbDY2cCsU5rlRhwriiQNwHa/zsfy+dOW2kzVifvLqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8qKoQDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8qKoQDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24357C6106C;
	Tue, 27 Aug 2024 15:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771149;
	bh=QkxtvJPzg2gZlok0EPU1QaTkk+fKA6rh5WkVAYxx01E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8qKoQDgWKNbBATTQeKpaqjTrHoho6bV6IXCRvXhQ//tHdZNV0+d8uMhL2dfmBiOq
	 lE05OUD1gcMoAyio5nuhYM4TXvojL4vUhWcZm9h3bkgvLoU1pYu6RKCAb73r1ujPdw
	 zGAbIzFx7MEGaSqKQ2NzR/ZwU7/jFo6h8lXPoSmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 070/273] drm/amd/display: fix s2idle entry for DCN3.5+
Date: Tue, 27 Aug 2024 16:36:34 +0200
Message-ID: <20240827143836.079639947@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit f6098641d3e1e4d4052ff9378857c831f9675f6b upstream.

To be able to get to the lowest power state when suspending systems with
DCN3.5+, we must be in IPS before the display hardware is put into
D3cold. So, to ensure that the system always reaches the lowest power
state while suspending, force systems that support IPS to enter idle
optimizations before entering D3cold.

Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 237193e21b29d4aa0617ffeea3d6f49e72999708)
Cc: stable@vger.kernel.org # 6.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2724,6 +2724,9 @@ static int dm_suspend(void *handle)
 
 	hpd_rx_irq_work_suspend(dm);
 
+	if (adev->dm.dc->caps.ips_support)
+		dc_allow_idle_optimizations(adev->dm.dc, true);
+
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D3);
 	dc_dmub_srv_set_power_state(dm->dc->ctx->dmub_srv, DC_ACPI_CM_POWER_STATE_D3);
 


