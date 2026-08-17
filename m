Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5202B2E8DEA;
	Mon, 17 Aug 2026 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978913; cv=none; b=jU8Qm3OkFZf33rCypU0BNYyPzvqUv9yRw3KOMYcnR/Nk92Mul6+zG7ol60JCUglsybmnGuC/gFBlP4HjWSUyuR8n+n4IsmxyE776oXgRv4MDm0iXfDncmIQGLxt2DsZ7LBowRV1JLr/CihNLIqLW2JZiIVQyVQUzJLD2pZzoLYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978913; c=relaxed/simple;
	bh=lzcXI3K1s27Tne5z7fy85vvH7lKbeeupIUVu5+Z6Vao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tI8RU5xs29i00j3vsByOiPLy6v7+tcCMXFbQkoZShmW3YZA5FOqCMTCk7m2vaCaL9JF/AfQNE7Cy3y1PBb9E6C14xWBG2qnOiAeZUNHxXTvciAUHL/PD1Q5Onc2WzTsr+QYL44f/ULq3HK0JxUmGetfB90u7l9t3+JvLBmPhdp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raLBT7p/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raLBT7p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19461F000E9;
	Mon, 17 Aug 2026 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978912;
	bh=y3X6z+Gv4F1O6Cg+dE0gUpAnop2cfNfEZykgG/xcY2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=raLBT7p/6c0lgPwlXZSOi6Uw8ex9DJ0YyUllK4aWqYbetHR8TX48kn82FIzJEaAcq
	 DbWV2l1msNGV7slDcVQ+ssw3cfI5mzV23pWUZs5YRJknNU1+JpgUPEb25rDMl3muEs
	 kogEONvBQ/AMVSUn+PtkQyf2nhzrL2i3f2DnEQFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/609] wifi: libertas: fix memory leak in helper_firmware_cb()
Date: Mon, 17 Aug 2026 15:25:39 +0200
Message-ID: <20260817132544.762440550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 63c2391deefb31e1b801b7f32bd502ca4808639b ]

helper_firmware_cb() neglects to free the single-stage firmware image
after a successful async load, leading to a memory leak in the USB
firmware-download path.

Fix this memory leak by calling release_firmware() immediately after
lbs_fw_loaded() returns.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still present in
the current wireless tree.

An x86_64 allyesconfig build showed no new warnings. As we do not have
compatible Libertas USB hardware for exercising this firmware-download
path, no runtime testing was able to be performed.

Fixes: 1dfba3060fe7 ("libertas: move firmware lifetime handling to firmware.c")
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Link: https://patch.msgid.link/20260624085343.575508-1-dawei.feng@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/firmware.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/firmware.c b/drivers/net/wireless/marvell/libertas/firmware.c
index f124110944b7e9..9bf7d4c207b9ed 100644
--- a/drivers/net/wireless/marvell/libertas/firmware.c
+++ b/drivers/net/wireless/marvell/libertas/firmware.c
@@ -78,6 +78,7 @@ static void helper_firmware_cb(const struct firmware *firmware, void *context)
 	} else {
 		/* No main firmware needed for this helper --> success! */
 		lbs_fw_loaded(priv, 0, firmware, NULL);
+		release_firmware(firmware);
 	}
 }
 
-- 
2.53.0



