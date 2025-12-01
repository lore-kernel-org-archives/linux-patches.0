Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47742561AB;
	Mon,  1 Dec 2025 11:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588407; cv=none; b=tD5nJ/ixgulubMvjJ+61xOC+YqBIsXFy0ConJZ6Qgjw2WDJUraXPfZZe3bTLmUifUxxluFIRzqLW8TJe/meHjcg/NULpjLkRnPTwtzFkUibRShiY/OtIxgaEb+BSOBumD5mGfclKpCi3fX98W6QIcFOfd3veOqeler7loeYbIkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588407; c=relaxed/simple;
	bh=KFnfFKLBrZSYx7/7ljREaKUbJV9xjtYab2LYskN7Sfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPrFroi6GdpKYphpk2Kgn37TIrjmKVYyMY1ynJuNcWDJr8AfGIOgHFFaffaSGay+jHDNQFhyoURAldrfzzF0Dt0fSJ3RUqBKk0rBBHACkVzK1Pjp+X8JRtiOZijDpnnoA1EccWWLE1GDbb9g+LYD31uVTootob64GW/NTMX9leg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WywysG6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WywysG6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FF0C113D0;
	Mon,  1 Dec 2025 11:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588406;
	bh=KFnfFKLBrZSYx7/7ljREaKUbJV9xjtYab2LYskN7Sfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WywysG6IXSecAGrTbCqO0wNnUPjkPO4IY4wJ6B5fHup+4lzxjCelh/tCxhIaq1qwo
	 p5mnw8+VTDQ2d9pxRZjq/HCmDf4kZMIAMiL5nE7kyOx9o77iZd4JHXG84aG6jcFDFm
	 sqpohdvbGaTHZOSnZuTAHKg2a2gb0RqdXZHIPhlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/187] tee: allow a driver to allocate a tee_device without a pool
Date: Mon,  1 Dec 2025 12:22:25 +0100
Message-ID: <20251201112242.590386993@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 357944bc73b19..28cbe4613ed91 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -722,7 +722,7 @@ struct tee_device *tee_device_alloc(const struct tee_desc *teedesc,
 
 	if (!teedesc || !teedesc->name || !teedesc->ops ||
 	    !teedesc->ops->get_version || !teedesc->ops->open ||
-	    !teedesc->ops->release || !pool)
+	    !teedesc->ops->release)
 		return ERR_PTR(-EINVAL);
 
 	teedev = kzalloc(sizeof(*teedev), GFP_KERNEL);
-- 
2.51.0



