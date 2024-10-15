Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5020C1D5AC6;
	Tue, 15 Oct 2024 13:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998238; cv=none; b=T83/4i977gC8Mk2qvLCMqdxBadS1puERTTv6olu912zXsC8BSO7w2epfrDyRMFXkJjLU2ZX7OfK3veKDD2Y3UupEzLzwVvRFhpQmOa+PxKSM/B73QgGrFKMTorwR/Bh7DrftB6CwlQkTpym6k62fsvG6VHDCgWITpEzoLimX9hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998238; c=relaxed/simple;
	bh=INFF3Bp9D1qaohKidNH8qPcF+61jgUuPkYeBq9qo2AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFWOWWF4PWG70E9ifoR4TMxbjTvpnbXZdKRyI1zNfR06c3KL9CFCG7UxHiZUssaPj9/nz6F8HJTTYXWW4uO2ZT5KmDYDW3dNQp2kYYaSpxQY/OXECsCQLkcQgPjaEeZu/9w2jJV5WVQTyPUv4URdFbSSea/rYp5RvzGyFhHXRp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtWsjFgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtWsjFgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65A8C4CECF;
	Tue, 15 Oct 2024 13:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998238;
	bh=INFF3Bp9D1qaohKidNH8qPcF+61jgUuPkYeBq9qo2AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtWsjFgOqdky5YMlYoS8KYxQTdtFt1B67AKNGI2Htvw/yjE6rdKaExEBSE2DGEAv9
	 rTtPprykaJubUJLilB4bMj406ABO+2tsm4S5O/rMVhOsMWeuDYno2cl2IohS1wtSCy
	 RQpiMKUtFyRfCKlhh8kPtC4kfH2XQ56geFKyHza8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 419/518] i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue, 15 Oct 2024 14:45:23 +0200
Message-ID: <20241015123933.167771632@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 0c8d604dea437b69a861479b413d629bc9b3da70 ]

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: 36ecbcab84d0 ("i2c: xiic: Implement power management")
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -893,8 +893,8 @@ static int xiic_i2c_probe(struct platfor
 	return 0;
 
 err_pm_disable:
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	return ret;
 }


