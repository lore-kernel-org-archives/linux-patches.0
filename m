Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5940B1CA8F;
	Mon,  1 Apr 2024 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987689; cv=none; b=F4xTCtDfFaPYN2SpsUrL7Mi4+p/Kuz1YJ+JoGCWH2giUZsS7ezLMKEkSypVH/zGXRxb9V9C096sqqKvPskY9eWyRhqxEcVqI2kKQSjlwrwwVcGdZfo7GeH5XZljY2PWRiCJosDOmrmY9IqmbuAaOuXg66EbH0iRmfXLZZkJypyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987689; c=relaxed/simple;
	bh=XKLU/BPqPPI46leQjwvec9GZQYt0CCVvcNDeWzxDXJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmFzGDj4QkmHbmzEIAVRbZWoZEboQ4p3jYqgTQYCeqt792d6i7NqLlfdgO8I2KRiz0jQozj/ivar9OwqIey/Pi3A6tZTfmJpjc8LQ4A6kNuZouZhAdnN7QLc6NaXu155J6aAmMJl+6WGNcWDpnaiCSQm6q+dkR8S3lFM96mLRTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1isFh8Zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1isFh8Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DDEC43390;
	Mon,  1 Apr 2024 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987689;
	bh=XKLU/BPqPPI46leQjwvec9GZQYt0CCVvcNDeWzxDXJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1isFh8Zv8Ieq5ZjgHAeBXMckEdXQ6CiGjix+XsDB+w98xRgQmWD4QDUXQRPzrKjVc
	 0WLKxerQpby98T04Dnq+vmtX7xhTY/4r0A/XwIQKPtYEkI4dt7IiZDuSPjnMjWHHd8
	 K7eALioQ0Vxc9G3lj0axmgDFHWlqOl3pPcEUF5OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.8 355/399] staging: vc04_services: fix information leak in create_component()
Date: Mon,  1 Apr 2024 17:45:21 +0200
Message-ID: <20240401152559.768286832@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit f37e76abd614b68987abc8e5c22d986013349771 upstream.

The m.u.component_create.pid field is for debugging and in the mainline
kernel it's not used anything.  However, it still needs to be set to
something to prevent disclosing uninitialized stack data.  Set it to
zero.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/2d972847-9ebd-481b-b6f9-af390f5aabd3@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
@@ -939,6 +939,7 @@ static int create_component(struct vchiq
 	m.u.component_create.client_component = component->client_component;
 	strscpy_pad(m.u.component_create.name, name,
 		    sizeof(m.u.component_create.name));
+	m.u.component_create.pid = 0;
 
 	ret = send_synchronous_mmal_msg(instance, &m,
 					sizeof(m.u.component_create),


