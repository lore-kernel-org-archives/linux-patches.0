Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3162EB02;
	Wed,  3 Jul 2024 11:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005725; cv=none; b=THItn1V2s7R/LE9sQZKMhdYAW0CIGuCmp0G1s5rFspNtO/vlb/HpQBa6B8NxTkIQMH5RqgF/4+Hl3y44iUyjanngzX4e6y39YEnXNKcp0Wgs3jxzezJsMuS3rCOGYB+2D+DR4sgudh/4gk71eRGN1IY/M3SRa1J/tn9YL8l/bnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005725; c=relaxed/simple;
	bh=lPaJnp47JVSuF4ZXMYoEu63u9Iwi013AyXtN0ltcrts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6PiRN9nTdzb2dCmzLdLF8fvi9Vkm2RVmKK3K0jVSTpDX/p9Imfe4VUOM9BWSZF+TgqhprUesbPbrqvNMuEyW1Mjx+EVtL3ozHLL5LFT2q5UakgnJFRFvZE9GsNwBFhWPkq6hHSSyj44CvIKJmqA6kXTaQSTmHmKb9VhrAM5KRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZON7GehS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZON7GehS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13601C2BD10;
	Wed,  3 Jul 2024 11:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005724;
	bh=lPaJnp47JVSuF4ZXMYoEu63u9Iwi013AyXtN0ltcrts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZON7GehSSFMXgxYqn1cWPXhbU7Q56fR2P81HYHtEq8rBtiYUNBuxaTIdPPjhTqlig
	 KQlQHN7w8BswTxT+Z7zZ6hZHIwOeOS5/QGCg0uQ6/PDr/eoQabuPG7VucUOGDLqAwK
	 YqpUMos7yUYrfsnZWKf4GKS9MrqebaXNRJiNIwsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/356] iommu/arm-smmu-v3: Free MSIs in case of ENOMEM
Date: Wed,  3 Jul 2024 12:38:30 +0200
Message-ID: <20240703102919.688332154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Aleksandr Aprelkov <aaprelkov@usergate.com>

[ Upstream commit 80fea979dd9d48d67c5b48d2f690c5da3e543ebd ]

If devm_add_action() returns -ENOMEM, then MSIs are allocated but not
not freed on teardown. Use devm_add_action_or_reset() instead to keep
the static analyser happy.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Aleksandr Aprelkov <aaprelkov@usergate.com>
Link: https://lore.kernel.org/r/20240403053759.643164-1-aaprelkov@usergate.com
[will: Tweak commit message, remove warning message]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 761cb657f2561..ec4c87095c6cd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3239,7 +3239,7 @@ static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 	}
 
 	/* Add callback to free MSIs on teardown */
-	devm_add_action(dev, arm_smmu_free_msis, dev);
+	devm_add_action_or_reset(dev, arm_smmu_free_msis, dev);
 }
 
 static void arm_smmu_setup_unique_irqs(struct arm_smmu_device *smmu)
-- 
2.43.0



