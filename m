Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08A52343C0;
	Fri, 21 Nov 2025 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732342; cv=none; b=V9hZ3/0aA0XikiUGfr2Q0ZWdVkCiaOJ2bZMuZU7QzXAWtkoujqgKsnaMbvk8OO94mGSRQlHWL7lYCqFem7wgnTMcWCdkHWFZCUzcA9dPIcrKajlEdq67DrSFPEbpgBaAhUXM6Huby2pOBmHmLsUT6MqMtFHWETwxYJ3s/y1MgT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732342; c=relaxed/simple;
	bh=5+6fCzrVzLUTrYRQMtrlFNDwCZM2Ct+5YZWC4CGqe0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOlNf/aR0+sRyyiqnkPRuEb+lUZZQWWLZ22IuDv5ZRNg3oTzzlpDLJMBEGc/lIX4bX1ENSDcm4ME9e8RaPOrhAUgYL6JLjWSGCcmVJH1D2OF/Ak7YjaEKz6CnpZuS5tUuEdp4cV2F0FoDHvSQVNYOQMqXqKvART0s6UbZAiMPz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZ35MGly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZ35MGly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833A9C4CEF1;
	Fri, 21 Nov 2025 13:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732341;
	bh=5+6fCzrVzLUTrYRQMtrlFNDwCZM2Ct+5YZWC4CGqe0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZ35MGlyhpDKuyS5TDm+5qwXAyASJw6MSaPYk8kKSr4EIZJuQroHZVtHGOq0G81T+
	 tvZPFL4hUrI2pIkPmPYTscO5uFWYqNb9J0/cS+T9Q9Uk8FLzBBKHSlKl+a7YSywn+o
	 giO17zLItpxlWMFqIOlM2nJP5WUOmq+UpHxZgZ5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/529] tee: allow a driver to allocate a tee_device without a pool
Date: Fri, 21 Nov 2025 14:06:26 +0100
Message-ID: <20251121130234.125188680@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>

[ Upstream commit 6dbcd5a9ab6cb6644e7d728521da1c9035ec7235 ]

A TEE driver doesn't always need to provide a pool if it doesn't
support memory sharing ioctls and can allocate memory for TEE
messages in another way. Although this is mentioned in the
documentation for tee_device_alloc(), it is not handled correctly.

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index d7ad16f262b2e..976912f3bb5b4 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -889,7 +889,7 @@ struct tee_device *tee_device_alloc(const struct tee_desc *teedesc,
 
 	if (!teedesc || !teedesc->name || !teedesc->ops ||
 	    !teedesc->ops->get_version || !teedesc->ops->open ||
-	    !teedesc->ops->release || !pool)
+	    !teedesc->ops->release)
 		return ERR_PTR(-EINVAL);
 
 	teedev = kzalloc(sizeof(*teedev), GFP_KERNEL);
-- 
2.51.0



