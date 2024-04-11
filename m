Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C56914601D;
	Thu, 11 Apr 2024 10:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830900; cv=none; b=QWkNxV7G1HMjBjXrsfI/IE+Bxt6PgATZUhtYeNS3mHI/9/W//xbxp/knpPnuEm4ix9FMvgw9xLV0GlH1LwZqFtWhJgkGm5uLoOhqJgRTE6TftVEd6iQAo/CRqbIn0ZZQi+Bqhn8T67Ao2M5q3uVkk3bcewc2GeJkQg3WbmISLgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830900; c=relaxed/simple;
	bh=nXNyPQmnYnQnaWXVGDT176/RqqmXnhWIZaVFDtSLx00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQ+z7S3m+MYScjghgVT+6h/6h2d3W/WqI21kAIbTnIiExceRl/kXHKrJULwv0qzoGNaj9KPV3/562Xo1EoGEyV2MELkHLwW4Vv/hOs21G12pjRpIlfGPHojuf0ikTkbtbTN8R5P5Y/7JIDcQT9emCKY36ccZsCMO1Bv37WV+Z9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDoKa4yG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDoKa4yG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F128FC433C7;
	Thu, 11 Apr 2024 10:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830900;
	bh=nXNyPQmnYnQnaWXVGDT176/RqqmXnhWIZaVFDtSLx00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDoKa4yG2z/VrOY0h03lw6h+8w2A4zZYHjWW5O7ow0EdunJdvpO5BalIT26UqjV3d
	 aYHWVzluT56GMevG2R5jpmhDOjA9Y72i3ZPrFzVyV8Pwxu5FUTuvT9VBWfDFjMHQGe
	 1X+heUVinGH+fgqY8U+0mvxwIzQHFCLYsK4UmIMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 157/215] staging: vc04_services: fix information leak in create_component()
Date: Thu, 11 Apr 2024 11:56:06 +0200
Message-ID: <20240411095429.599075398@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fab119c60cb12..ad143f6019746 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -931,6 +931,7 @@ static int create_component(struct vchiq_mmal_instance *instance,
 	m.u.component_create.client_component = component->client_component;
 	strscpy_pad(m.u.component_create.name, name,
 		    sizeof(m.u.component_create.name));
+	m.u.component_create.pid = 0;
 
 	ret = send_synchronous_mmal_msg(instance, &m,
 					sizeof(m.u.component_create),
-- 
2.43.0



