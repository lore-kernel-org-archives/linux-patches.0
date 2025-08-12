Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73B42ECE93;
	Tue, 12 Aug 2025 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023563; cv=none; b=KYkjjtLA0vJHIGVMMRYaW7N1JQp7yLLKqvmLX28EFM8BAhArcdJe5trEMTTTtyiqBNnO2ArTazthfofakeJb5zQdPH4L0znxsclejD7NMEVZKZUOLbm00zPkj3rbJmmsd/ARV/Gh95TW65iA4f/qaIkpLn/XK99UNQd4XE4OGM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023563; c=relaxed/simple;
	bh=b/3HdGOXCm8LsMGICslh74doxhZMtmAiLVyNXj5l4LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2lLav/03tywAi0yQHDswtkADMMTcnSoTClPtrB+acZAu2huUbLltXpKHTB+cTLHmq3QSyM8tqSBj7IZdMNpu2ObRVSrV/N6x0AK2xAwD/6r0n/8iPcaEaqcJ14Ozeekjb7fNym+VjFbTyPxXeUGg/4ywgvnB6M9+5e16K1x8p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeOtqXAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeOtqXAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58E6C4CEF1;
	Tue, 12 Aug 2025 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023563;
	bh=b/3HdGOXCm8LsMGICslh74doxhZMtmAiLVyNXj5l4LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeOtqXAiIlTjzMuORSqVMZMp0V219YVsSVhd+ZKCwps3mAYnD07X6Q+yGj6Ac4d/2
	 xuNm85zraoO9PEF6nqEzjBrMXmPhkhZVNFh8cRAnFuaa4FZzAMEHXonNBQ1F6/8ts6
	 QujSoIr+FBHsjRf0S2FCGUkiinSXH7AvsjG8mSgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 116/627] driver core: auxiliary bus: fix OF node leak
Date: Tue, 12 Aug 2025 19:26:51 +0200
Message-ID: <20250812173423.731562621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6beb4ec0f9fdff4c4c6eb8ed8654fe8396c2b6e0 ]

Make sure to drop the OF node reference taken when creating an auxiliary
device using auxiliary_device_create() when the device is later
released.

Fixes: eaa0d30216c1 ("driver core: auxiliary bus: add device creation helpers")
Cc: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20250708084654.15145-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/auxiliary.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
index dba7c8e13a53..6bdefebf3609 100644
--- a/drivers/base/auxiliary.c
+++ b/drivers/base/auxiliary.c
@@ -399,6 +399,7 @@ static void auxiliary_device_release(struct device *dev)
 {
 	struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
 
+	of_node_put(dev->of_node);
 	kfree(auxdev);
 }
 
@@ -435,6 +436,7 @@ struct auxiliary_device *auxiliary_device_create(struct device *dev,
 
 	ret = auxiliary_device_init(auxdev);
 	if (ret) {
+		of_node_put(auxdev->dev.of_node);
 		kfree(auxdev);
 		return NULL;
 	}
-- 
2.39.5



