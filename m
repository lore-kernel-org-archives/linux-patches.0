Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC8443ABC;
	Wed,  3 Dec 2025 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777546; cv=none; b=DU1M3BxGQqZXgGui/7y6WutyFXdd2Z1OL/6kNnEoOlbukCmkGHvs1IvJRF1eKylpqYqRyk0BMTjqlY/Zq2riQm36IHppeY4Agoh4SX0LFsvEL8m+8DYeJA/m2qB6I8xQJ3zmy3CEcFICf/QOChSZXwuVHIohH39ozoT7MWW5iRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777546; c=relaxed/simple;
	bh=6O11lu/h68tyjzLmKKrQ5/QY3K2vGYaw0MvHANbi4rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEhf2PwAea0XCsnD5DeTVOpmq/hcCdkdqwE+yGF2ZgP4a30FgKFHIbfBrY5sjZwcLcibwqAaNSCp45QsWKCF1SRcjeG7SE3Z241huN1gBQDvvnkBvtBEVk25Sc3lYmX8m+zVZelW4Dyhh262tA/DmDnVkkDs22f9kM2jMNnwTBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzHDAVhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzHDAVhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78244C4CEF5;
	Wed,  3 Dec 2025 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777545;
	bh=6O11lu/h68tyjzLmKKrQ5/QY3K2vGYaw0MvHANbi4rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzHDAVhGB4jPKUC7rfL0QtvC62Z2V5Rwm2AC6FGax4ZvF9T6O9UaqKtauo5yC5PN2
	 87au0OJrW485RS6pB/pJJEjv0V/hAE3llwQ8D9KnPYEM7yRVh8Ay4QVoYjx5j3OmDd
	 Aml9w1eDQ5tR2GDqDa2x9iUoZoxVnt6ecSkk5ExQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/392] tee: allow a driver to allocate a tee_device without a pool
Date: Wed,  3 Dec 2025 16:23:43 +0100
Message-ID: <20251203152416.792545005@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a7e89c229fc51..f10089fadaf07 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -895,7 +895,7 @@ struct tee_device *tee_device_alloc(const struct tee_desc *teedesc,
 
 	if (!teedesc || !teedesc->name || !teedesc->ops ||
 	    !teedesc->ops->get_version || !teedesc->ops->open ||
-	    !teedesc->ops->release || !pool)
+	    !teedesc->ops->release)
 		return ERR_PTR(-EINVAL);
 
 	teedev = kzalloc(sizeof(*teedev), GFP_KERNEL);
-- 
2.51.0



