Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2251BA3F;
	Mon,  1 Apr 2024 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990465; cv=none; b=Ol6i4nQ3YpW97xzuMPxscMUAjgqNX3dfWSVsNn7umYPY1t4nrYTGFRcgUpRc09D6i+We2PNZD5tiUcHQiw8uawjBHQe3jFmJb3USl/zz3/az2FnAb0/c5g95zWc9s5vLJ3StbtLowdBS/AMWv4VCvRAx8NazUQvHeMs9tE1vOKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990465; c=relaxed/simple;
	bh=JQi+rqvx7lEvulKQQfu4T6cD3MkPVnnB4qkNc7XQSlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEI7UI69Yonj/bzeDU+KM94xc/F6neL5F9Y6kesNwX45YQbLF6Ob/StW/E1VqthqqDXkBPPnzA4PjCF/0PW4qsrw2jQn3uk4BGBShMMer/3Jbc9ar38YjkCL950QfapFdh/ZTO3BnaN2oo0iGmHJM1QLpH8vwtckk7oRxe6jaF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLnn8jhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLnn8jhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653E2C433C7;
	Mon,  1 Apr 2024 16:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990464;
	bh=JQi+rqvx7lEvulKQQfu4T6cD3MkPVnnB4qkNc7XQSlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLnn8jhQz3SlEgS/8h3WZbI46cHP46b+nK7ZhJ3dZHhiItWUB1FFQ0Jr1uPbORtcH
	 5AKAS3Vazmg1VtY3XE5Bo5ozueu0ocea4+241yuukkGW3wLvx+Io6WC+4aiUckF5mW
	 LM0Wzt38yZa3STt1JtoOOnmN3t1oh8mJ25ZQdl9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.6 361/396] staging: vc04_services: fix information leak in create_component()
Date: Mon,  1 Apr 2024 17:46:50 +0200
Message-ID: <20240401152558.683879416@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


