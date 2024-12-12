Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A54222D68;
	Thu, 12 Dec 2024 16:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021662; cv=none; b=t+sRClixw8miwPXseAih9aCdbdexgDdxv8LU2WD+9kVSUjUoIoj/PVY4slgG2RgD3avL6NWrKrcuIoc/Cx/NhswnraCBPSzmImMU/M3IN+jHGcDK6g7Tcx2yWuVtsXeQ9B92mUh6u+6bOz7fPVKgx9CGKvKtRaeg8hO0gQFDd4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021662; c=relaxed/simple;
	bh=W3hDoAZJG2Kn5vgAXqxnaMnAEyYWe8sNVwU0D44uU14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLlV5uyfGJ+MLLlmwmm3wuMYdN/XgwfVjXoSuDEXNR5dyhIYog8D8flLP68Q5yxxDggpfkMk7j/dfxqC8pwVxHvtuxasoVyPSMT/8d7oJwtg/eFczk21FJSDjoq+GBArbN9vu4vJmxNYDzbi3z3KM793RSPmfy6W2Y3Szhq162I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nP0SRrMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nP0SRrMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C5BC4CECE;
	Thu, 12 Dec 2024 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021662;
	bh=W3hDoAZJG2Kn5vgAXqxnaMnAEyYWe8sNVwU0D44uU14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nP0SRrMOkIJzNmD8PC1LNCQ7HWzapRm0DTuYCzDm7P20gxl07cXngvydtHE09kK8P
	 tLgm9W32awqlt+gq4Qw6GpPkDUwyRD3svEKK2+85RIj9TIWZRPMzPuyNFhof/gLBxj
	 Zko0HL7Q+iF6PR+PrA1Re2XA6O97o5XSo0u5E8HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.15 008/565] media: platform: allegro-dvt: Fix possible memory leak in allocate_buffers_internal()
Date: Thu, 12 Dec 2024 15:53:23 +0100
Message-ID: <20241212144311.775086872@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 0f514068fbc5d4d189c817adc7c4e32cffdc2e47 upstream.

The buffer in the loop should be released under the exception path,
otherwise there may be a memory leak here.

To mitigate this, free the buffer when allegro_alloc_buffer fails.

Fixes: f20387dfd065 ("media: allegro: add Allegro DVT video IP core driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/allegro-dvt/allegro-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/allegro-dvt/allegro-core.c
+++ b/drivers/media/platform/allegro-dvt/allegro-core.c
@@ -1431,8 +1431,10 @@ static int allocate_buffers_internal(str
 		INIT_LIST_HEAD(&buffer->head);
 
 		err = allegro_alloc_buffer(dev, buffer, size);
-		if (err)
+		if (err) {
+			kfree(buffer);
 			goto err;
+		}
 		list_add(&buffer->head, list);
 	}
 


