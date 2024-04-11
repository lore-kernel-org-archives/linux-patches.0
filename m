Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F49B1422C4;
	Thu, 11 Apr 2024 10:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829864; cv=none; b=Lhz3qoFOFdom53dXuyH7qO9c5FseD1j5uZwVekruyhzcJHTlFYrCRctEiI12VghSEwtSnpxf2MaVfSLQD2lv6ybdh9Zlik9O51uyJG89MRCDPJZcw6+fiRdM0igl8fOIe/7bwV6GJB0MqsBFDtdI4N8oXafp6An/Z+yLPCdfHJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829864; c=relaxed/simple;
	bh=ThTBOamqxib1dHcjUN5POYsuWmjXvaQ7M2mi10wI2kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXdpc6PUrZDbqnGR6qqsU+k09YU7ai5ztWhR2xKguy2S1JTP2Uq+AitZ5ie9ZcteXNlKgalsrTWTwXCzDXHf26wquE1v0UdX6mLLxGk+hMjRLOhftHiRHp5o589lZKORpaA3yTjpAwF2YXZszDl+rFFR/89juzgrri2pABEy2Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3kexVVg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3kexVVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26835C433F1;
	Thu, 11 Apr 2024 10:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829864;
	bh=ThTBOamqxib1dHcjUN5POYsuWmjXvaQ7M2mi10wI2kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3kexVVgnZNPeEgmPvWeg/lQJAAqx2zIHIoTjK2jPVrgscTbbCr0H6916qHW9F53w
	 LNQ9i+KS8VVHjMLmTF8a1ZyFfvsos+ureFWXPiKBTxpOxJ94kfSfLbAsGIQMp16ZXY
	 WPqsV538Hgi/bGHZjzKqk/vGT0JbGKFjOi2qIVU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/175] staging: vc04_services: fix information leak in create_component()
Date: Thu, 11 Apr 2024 11:55:55 +0200
Message-ID: <20240411095423.538458043@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f37e76abd614b68987abc8e5c22d986013349771 ]

The m.u.component_create.pid field is for debugging and in the mainline
kernel it's not used anything.  However, it still needs to be set to
something to prevent disclosing uninitialized stack data.  Set it to
zero.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/2d972847-9ebd-481b-b6f9-af390f5aabd3@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
index 5d1fb582fde60..a6ba608fed938 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -923,6 +923,7 @@ static int create_component(struct vchiq_mmal_instance *instance,
 	m.u.component_create.client_component = component->client_component;
 	strscpy_pad(m.u.component_create.name, name,
 		    sizeof(m.u.component_create.name));
+	m.u.component_create.pid = 0;
 
 	ret = send_synchronous_mmal_msg(instance, &m,
 					sizeof(m.u.component_create),
-- 
2.43.0



