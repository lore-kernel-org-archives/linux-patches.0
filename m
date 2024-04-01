Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657E91C0DE7;
	Mon,  1 Apr 2024 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989142; cv=none; b=ClcDjuSs4dKEOPj6lICta/w3oCkQ5twkIFMy+9Kr37dnasxHNlhhb9Tb39r7e6stUPb2gRxjaHJToP4MJSkgMlGIvKOojNSHB6WNHc9eZZoFVn9otxR/kZyDUmVae9MwGr5XOhueQSU5SR9gwC9TN89jzC5t1oJ0+9W8pk+PwTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989142; c=relaxed/simple;
	bh=1xIuWTROmIsl13SV6LZQD/t9LoeRhO0BsfRmfbUlA2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8obNGm8Eg5UyYcQ0j7rwv1iEfZVP4c6bdFLtMnvO/28eMR1f9+wkfHGy3YSltFgmBXVk5JE1LjctR+/m8p/IudYf7GEF2POGBcnINgusXBzfjSbFN+tE62Ot9Vk2Q3LLGyrs0oAhR1MO3gZUM0tVRy8472pP7maxWcnKEt0Vwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQHJqUFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQHJqUFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC54FC433C7;
	Mon,  1 Apr 2024 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989142;
	bh=1xIuWTROmIsl13SV6LZQD/t9LoeRhO0BsfRmfbUlA2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQHJqUFhjDIns5negrGbl5NzBNwedUe/wRNGwiXoWhRBZIc4ddxUNRWHg6JraP/AR
	 b8HKpXcXTw9MR20xbFMn/37ZZXtMB2AvQRw9YwHgl1HK6jjJf4TvBMYjSsIg0A2+Pr
	 hgt/wR9oFXs6pIulNi+u0JmqaDZTHIhb3fCmzTZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.7 394/432] staging: vc04_services: fix information leak in create_component()
Date: Mon,  1 Apr 2024 17:46:21 +0200
Message-ID: <20240401152605.098633638@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


