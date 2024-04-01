Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C5E47A5D;
	Mon,  1 Apr 2024 17:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991357; cv=none; b=DmqQutC+I6cdDCJYRwMsKDUn2pLWVcuJPt9hXR9hFKlS/DEIBK3zovzftc+rd9qxCmmbrflylxLOLn/nkEqDEowdTJ2rjIxUuA+QIeSLqF6yWgJwB9uKw/Ry+Vt95K5reUwj0gECV/17XRMiSQ0HIfIUNOfDP62EfGpjqNW0zJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991357; c=relaxed/simple;
	bh=i5MmY1RFVlJGzkQKws3lsGWCU4zyRU91WaS3iJiW+fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMgebeSA8FmMFXAqiDgd/Ba2J4iGAouDoW/E5i2koz5gRmGpK/N8kvxUqGk6UqZ+G6g/PiJdOz2qNvdpctb7Hnivn7w3YGGixlE28V5SLiXvTY1rDHkyThFGazwjGgE/CXb+xpHaRqOCd3Tl31/hS5secaP0VYsBvCvi5xXheQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqUhMWFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqUhMWFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E466C433F1;
	Mon,  1 Apr 2024 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991357;
	bh=i5MmY1RFVlJGzkQKws3lsGWCU4zyRU91WaS3iJiW+fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqUhMWFYqkZk7fHaxodpRg+3dO3JvjvviX7frYnDOQR8QeJzxz5FrYll9enTf99F9
	 gehITAe6RYJq0350DWktSqlOJw1lNLp1Up2AfVFQ3dMT9g4XIpAGBD5uXhtNkgPuqp
	 +VLrCTbHZ5tW2lvrcweW9dNyxIM7k5oG6eThPuF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.1 239/272] staging: vc04_services: fix information leak in create_component()
Date: Mon,  1 Apr 2024 17:47:09 +0200
Message-ID: <20240401152538.433162991@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -940,6 +940,7 @@ static int create_component(struct vchiq
 	m.u.component_create.client_component = component->client_component;
 	strscpy_pad(m.u.component_create.name, name,
 		    sizeof(m.u.component_create.name));
+	m.u.component_create.pid = 0;
 
 	ret = send_synchronous_mmal_msg(instance, &m,
 					sizeof(m.u.component_create),


