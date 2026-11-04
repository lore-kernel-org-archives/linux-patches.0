Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831633;
	b=u7xEUOJnBR8DKN40aetTOW+ny8LUXfkBY1KQ/fIk6VBHBCGgpubjCXRFCgdnWpl8W6OG
	 OqnAxgd0Z3V51ap/V4ejTRftCwnKbUCBdw11PtIo1ns+Ecs9xgEQjpPX/6kCJelDEjMTL
	 GgYMfY8wqmWOPy90Gud4TNhxV2GFtGoUTMZLNI0+mVD2KGkPMvjeSmLXGUprPFqfbMIi5
	 W/QckKdN+D1RLqyusbssiYZigkYfI4ykPwuDjY3fJdL7Wh5k4TuHQSJRL5tcRQQAf3yi6
	 mcIeA6mCLBfXEWrK/iYhfFrkk1LySDBtxkSAeVs3wS5Ot9op44MiHenPC9koS2fMFyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ABsfTA5+Sw3n6Mjr4sXpJ3pi2bMKNyMvaTemasb10kA=;
	b=kWGY2vuUaXhQPEldGecac7iqUX0laEvH0oEETjfYKTeARwkAGqsjbN37YX2Gta27j/2U
	 ku8eeaM7F0bqjcNRtXE+TJNa3poy+J0g9b+PVRtxohBBpzMC0McivD8evf6Cqm2G4/WK1
	 k+p78QJwnC46ROie1MgFHDnwbhdow80KYL4Dc/biKFhFMRoJqXkbrNWhfM+dNtOWRJsRL
	 8BZU7jqzooDnTFGKvBIptBCvHnPv6Sxk9TovqicncxQVr2Esarn0uf9KCC4Gub1NjG9nB
	 Z2uLCqY7PzGMlipVQjXVZbHPA1Pt7wKeRTnDuiRdW9YgKCexIZkKR7VMXQriCbNYVfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9qvrDm2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE60606AC2A;
	Wed,  4 Nov 2026 22:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9qvrDm2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FCA1F000C1;
	Wed,  4 Nov 2026 22:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831633;
	bh=ABsfTA5+Sw3n6Mjr4sXpJ3pi2bMKNyMvaTemasb10kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9qvrDm2Qba6BzVmS8jnxFLK3xGrqo+CiBdXjcbTjJjAOESBOsAC+9f8JuaJpkRpe
	 Mgjax+z+llA8iURfV6Q/6Ijbv4VhlCDqXE8qQ29HXUf2r4wY42+4RjGmz6y8T3Kt55
	 mt32gmd7UWQnV9weE/88FJX7hWp5qauCG4rh6p0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 0823/1005] EDAC/mc: Really fix error path ordering in edac_mc_alloc()
Date: Wed,  4 Nov 2026 16:09:16 -0500
Message-ID: <20261104211106.391649809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

The backport of 51520e03e70d ("EDAC/mc: Fix error path ordering in
edac_mc_alloc()") to stable kernel branches is incomplete due to a
different memory allocation scheme. In v6.19 and earlier, the device
initialization must be moved further up so that all jumps to the
error label are covered.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@kernel.org # v6.19-
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index b510919e49c0e..ebac0690f9a41 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -366,13 +366,13 @@ struct mem_ctl_info *edac_mc_alloc(unsigned int mc_num,
 	if (!mci)
 		return NULL;
 
+	mci->dev.release = mci_release;
+	device_initialize(&mci->dev);
+
 	mci->layers = kcalloc(n_layers, sizeof(struct edac_mc_layer), GFP_KERNEL);
 	if (!mci->layers)
 		goto error;
 
-	mci->dev.release = mci_release;
-	device_initialize(&mci->dev);
-
 	mci->pvt_info = kzalloc(sz_pvt, GFP_KERNEL);
 	if (!mci->pvt_info)
 		goto error;
-- 
2.53.0



