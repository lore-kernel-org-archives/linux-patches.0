Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7192D5C8F7;
	Tue,  3 Dec 2024 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240807; cv=none; b=icwJikk86c0oKHaHTClmeKoVu1i29ich2dO1JNLNuv/DsqKqGmzQtxYIZxJ78PT1qAKv7vl003KDG+EPoEjlCQYMBBZ2DXszom3ETr2ozj2O3B8vY4PdQ96cn6pVWvVadRzkF2r1B+RnCJu+TXFONZfZ+ZXJe5q8Tg+gtmCOAxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240807; c=relaxed/simple;
	bh=f5Dk7vto3FaWWsnyTF6LNdThR9VtICvRdXpAuieTfug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jT14gk++1w2pMVpMhV76oI9rzob+uneSt13f1xkSEvIF/v6vArBYm6bBVEOo1zdo0XR0hoRTWby6UqYxxj/yEsNRAOyisAP+QwSZhR2IlG9vK+vJeFsAfT7mhoXM2aa4XqItChrSYGWrkij1QsiSskGooDKh9xsNnnusSmRoI6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOt5seQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOt5seQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64F6C4CECF;
	Tue,  3 Dec 2024 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240807;
	bh=f5Dk7vto3FaWWsnyTF6LNdThR9VtICvRdXpAuieTfug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOt5seQFS4KYwh/WvTAfAew0W+fkGXyJUMptHVkEl+46GqLt2hpeEYh/7FN9ROQ4I
	 XwV//B9kBY81kWpOJUfPdwP96D+VXUnaVGFLEBXewOQgAK6MtegEY8zWAkoqS5Tjyr
	 yH16f/BH8Qkpu6foshMb3TZsX/Vhof3hrjwOq7tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/826] drm/amdgpu: Fix JPEG v4.0.3 register write
Date: Tue,  3 Dec 2024 15:38:55 +0100
Message-ID: <20241203144751.860066569@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 8c50bf9beb889fd2bdcbf95b27a5d101eede51fc ]

EXTERNAL_REG_INTERNAL_OFFSET/EXTERNAL_REG_WRITE_ADDR should be used in
pairs. If an external register shouldn't be written, both packets
shouldn't be sent.

Fixes: a78b48146972 ("drm/amdgpu: Skip PCTL0_MMHUB_DEEPSLEEP_IB write in jpegv4.0.3 under SRIOV")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
index 86958cb2c2ab2..aa5815bd633eb 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -674,11 +674,12 @@ void jpeg_v4_0_3_dec_ring_insert_start(struct amdgpu_ring *ring)
 		amdgpu_ring_write(ring, PACKETJ(regUVD_JRBC_EXTERNAL_REG_INTERNAL_OFFSET,
 			0, 0, PACKETJ_TYPE0));
 		amdgpu_ring_write(ring, 0x62a04); /* PCTL0_MMHUB_DEEPSLEEP_IB */
-	}
 
-	amdgpu_ring_write(ring, PACKETJ(JRBC_DEC_EXTERNAL_REG_WRITE_ADDR,
-		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, 0x80004000);
+		amdgpu_ring_write(ring,
+				  PACKETJ(JRBC_DEC_EXTERNAL_REG_WRITE_ADDR, 0,
+					  0, PACKETJ_TYPE0));
+		amdgpu_ring_write(ring, 0x80004000);
+	}
 }
 
 /**
@@ -694,11 +695,12 @@ void jpeg_v4_0_3_dec_ring_insert_end(struct amdgpu_ring *ring)
 		amdgpu_ring_write(ring, PACKETJ(regUVD_JRBC_EXTERNAL_REG_INTERNAL_OFFSET,
 			0, 0, PACKETJ_TYPE0));
 		amdgpu_ring_write(ring, 0x62a04);
-	}
 
-	amdgpu_ring_write(ring, PACKETJ(JRBC_DEC_EXTERNAL_REG_WRITE_ADDR,
-		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, 0x00004000);
+		amdgpu_ring_write(ring,
+				  PACKETJ(JRBC_DEC_EXTERNAL_REG_WRITE_ADDR, 0,
+					  0, PACKETJ_TYPE0));
+		amdgpu_ring_write(ring, 0x00004000);
+	}
 }
 
 /**
-- 
2.43.0



