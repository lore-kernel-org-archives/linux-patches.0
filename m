Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05801E3DF9;
	Tue,  3 Dec 2024 15:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238427; cv=none; b=ZM7ei9VNDpxlsq++JvS1pg6HLLm2NP3B6CJopbu3GDEPMOwx20H8dNLC7Td407P9sLT8uJxBj1+PmoK3QxCchWp/ZtvvL/d61aLcgSZt/TjSu+Jmgq9Xy37QKqjWcd0mm1eXrK1YsATkuFzxnyGQSJ3f/W89sS0XDU97FdhLEDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238427; c=relaxed/simple;
	bh=8EDIDDnMEYXQuHG8OUmUXVcsCI1yy/aaN9vS3tXIJac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rm/Dy1q3h8ARneE7vBv17RnrMGb366U4BNLC4Q7ZakU68KoY/AyJfpPxJhZBziZdSHJvZwKj8qck+ptJphmzfHRGCqFhf710sO3rE1yO0+Whnw5Dirx7ELh0KJ9fb9lPE65ySbTl2Z32Thr3Qje2I+yzB0y3ykgEmkv1/UlkkDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJ9lbsg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJ9lbsg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D521C4CECF;
	Tue,  3 Dec 2024 15:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238427;
	bh=8EDIDDnMEYXQuHG8OUmUXVcsCI1yy/aaN9vS3tXIJac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ9lbsg8CsYVZq/YBQJirJ70VZsgL55V9eOp/S0I+js9HHS1F2AjGHHJAUrs6Y8Ky
	 GE3ZgNge173HZaCFHMn+6q82w9cQjz+FWh+F7Ugtd/6+VFLR9g9dJerp2ROvhpmYFz
	 LgG1Da39zMpIFjTkaOYc8iUpvp+T5EG8YBpsGCD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 242/817] drm/amdgpu: Fix JPEG v4.0.3 register write
Date: Tue,  3 Dec 2024 15:36:54 +0100
Message-ID: <20241203144005.212991437@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index b55041f38cec9..0dbc16ec25c82 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -668,11 +668,12 @@ void jpeg_v4_0_3_dec_ring_insert_start(struct amdgpu_ring *ring)
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
@@ -688,11 +689,12 @@ void jpeg_v4_0_3_dec_ring_insert_end(struct amdgpu_ring *ring)
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



