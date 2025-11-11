Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3217E41C62;
	Tue, 11 Nov 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822824; cv=none; b=tVsohLWkCU/hkOGXM3DSsD2ahf6KgFZlJeRhZ42nnE2NW8ZmenJsyA/8P3/Go8Mrx1kmiD+gcMSJni6OMgZ1++uB6y39Bf45wkQTilBz8lEUZh6EfHvfI/BIgGfJH8KoB17PO/bAqvAugY1RHEJMaJzTTagEgFaomVHWu4XrUg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822824; c=relaxed/simple;
	bh=u264rkupV2Aa+COWdJK+IZRXdWJfWVzZ7nRgpDbMC3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2QOl6eSow9HNPZVMKmH70n9ZVYSyxS6d5GjGi92QYpLRhiufIqkmK5DkeSgJj/sNSkVktBPzm9jVk3kFF0DsRKiIYWvjYR6Czll52ZCsHlIzILpbL/CtFK41OV50TIIZQGtynAwyjeoqeainlBX4PyPlIl4vIdYk30YJ2rOMsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhfhTYm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhfhTYm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44046C4CEF5;
	Tue, 11 Nov 2025 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822823;
	bh=u264rkupV2Aa+COWdJK+IZRXdWJfWVzZ7nRgpDbMC3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhfhTYm9SUcGJnwrPQa9l2C7bS/L3eG9xiXnu9W1VzjNjRo5i5WsioVRWASgOdErF
	 JQrf+AxxJ5W3E5Bw3fIMjJFtuoD7qoMeGJUQufWIWseRftyu/erW3+mAdWZARRKghQ
	 BHoZRKYn1j5G/YlJy75s800YW5ric87IIBLwmIr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 178/849] tee: allow a driver to allocate a tee_device without a pool
Date: Tue, 11 Nov 2025 09:35:48 +0900
Message-ID: <20251111004540.736551315@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index acc7998758ad8..133447f250657 100644
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



