Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757F7194A67;
	Tue, 27 May 2025 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365112; cv=none; b=Q0fwLtSYRdAA5AqaDKuzAzoksbVwLzbYVCvvG/9KwpVtOnRkfc4rZGcIWJtlONpv/DeoAafmz2f0Ze7NZ1i8MkBCjGUWVmjd3WDwhnAKwET5f1z198SiozDFnCqLiErjtWtY7yvBwIwQZEU8Tu2Lf5nZK0PAT1lR6At6W32OmNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365112; c=relaxed/simple;
	bh=Yqet11QIXK3u1KVGGmR/i9iHyHHdQe5imCAPfrbL6WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCORvAC5fO/25YlWp9+ENR3Jpa8FtpJpzt+lh9yuMXO+mbhH41y94X2/nN61SN3o6L14aQJrLnbowbBvD1e1UDyyZavSzKRt7T3gUdDesDKXd1XpEEo/pKmLoyCT0LlyRQKfwFoddhzXisHFuJaB/XK7Z6fIa0f/NU7SugLwkZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmTTrWod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmTTrWod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E12C4CEF1;
	Tue, 27 May 2025 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365112;
	bh=Yqet11QIXK3u1KVGGmR/i9iHyHHdQe5imCAPfrbL6WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmTTrWod6ZQ/ozspt8zL54GSja8i/U02EZ3lGUVy1Eieyml6A7Sd31nZfBxetM7MX
	 n3JQVAQKQZXU5JzSO99Qcq0XWZzjOAR0l4T2IlvVk8IGLANqqvTe3yWjmasNt96h5l
	 ja90zD7ApNhYLYlxg4BTBcCBuVCwU+rXvPMCZOJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/626] firmware: arm_ffa: Set dma_mask for ffa devices
Date: Tue, 27 May 2025 18:22:43 +0200
Message-ID: <20250527162455.992918850@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit cc0aac7ca17e0ea3ca84b552fc79f3e86fd07f53 ]

Set dma_mask for FFA devices, otherwise DMA allocation using the device pointer
lead to following warning:

WARNING: CPU: 1 PID: 1 at kernel/dma/mapping.c:597 dma_alloc_attrs+0xe0/0x124

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <e3dd8042ac680bd74b6580c25df855d092079c18.1737107520.git.viresh.kumar@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_ffa/bus.c b/drivers/firmware/arm_ffa/bus.c
index dfda5ffc14db7..dea3eb741d95d 100644
--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -212,6 +212,7 @@ ffa_device_register(const struct ffa_partition_info *part_info,
 	dev = &ffa_dev->dev;
 	dev->bus = &ffa_bus_type;
 	dev->release = ffa_release_device;
+	dev->dma_mask = &dev->coherent_dma_mask;
 	dev_set_name(&ffa_dev->dev, "arm-ffa-%d", id);
 
 	ffa_dev->id = id;
-- 
2.39.5



