Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6F571B32;
	Mon, 15 Apr 2024 14:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191939; cv=none; b=fBylo14VW1MhBYmzTcic5CBSq0MPLJHvObvmyMJcXDpzapteRMf92Zkz3y+l21/NYlPl3jn0xEI6oflTu2PPATcdKj4ox4PhAQRjVptD1qDy9PrhhtrR/2nTj9/kKz9hN/QO5uU/yA1c/1xSigrD/Jn+krGbuGqHyedq98SZ4y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191939; c=relaxed/simple;
	bh=wdh0cUHmnEqf9cJ48obaZsb42/XVGYidA1wA1T0W/Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QT9PiEczRwCw4rhdIyqQfKN6nGFkSihltgHb0U+8NDHpCDrXc8Lrwzfs/qlCl4rigxgANr+34gHkybn2Kz1TpOxGwQqG3f2kXjX69Zf//DmYZXRFLl1dpNhfNrViVPSXQRGKRBGNZwEl/SABEZt1vnEERyZowTj4EQF2cq5FsOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HD5ctrGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HD5ctrGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970DEC113CC;
	Mon, 15 Apr 2024 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191939;
	bh=wdh0cUHmnEqf9cJ48obaZsb42/XVGYidA1wA1T0W/Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HD5ctrGjZ5592Ri0pfswW2mJWo8hZ/XpgUILM+01kP9lakHCraZhSz5Tz3yGoRP6Z
	 xnypw0+vtc494GsuOqYe4W2k7hPefloB8w5AYo3Qbt9bhtmL9GT03FgLtf/3VfOXj9
	 cKKf611AG8xQzM6OHLdN0AMHZndHZPFG7lBXwWzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <superm1@gmail.com>
Subject: [PATCH 6.1 06/69] drm/amd/pm: fixes a random hang in S4 for SMU v13.0.4/11
Date: Mon, 15 Apr 2024 16:20:37 +0200
Message-ID: <20240415141946.362521809@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

From: Tim Huang <Tim.Huang@amd.com>

commit 31729e8c21ecfd671458e02b6511eb68c2225113 upstream.

While doing multiple S4 stress tests, GC/RLC/PMFW get into
an invalid state resulting into hard hangs.

Adding a GFX reset as workaround just before sending the
MP1_UNLOAD message avoids this failure.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <superm1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
@@ -222,8 +222,18 @@ static int smu_v13_0_4_system_features_c
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
-	if (!en && !adev->in_s0ix)
+	if (!en && !adev->in_s0ix) {
+		/* Adds a GFX reset as workaround just before sending the
+		 * MP1_UNLOAD message to prevent GC/RLC/PMFW from entering
+		 * an invalid state.
+		 */
+		ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_GfxDeviceDriverReset,
+						      SMU_RESET_MODE_2, NULL);
+		if (ret)
+			return ret;
+
 		ret = smu_cmn_send_smc_msg(smu, SMU_MSG_PrepareMp1ForUnload, NULL);
+	}
 
 	return ret;
 }


