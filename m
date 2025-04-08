Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1754E2676E1;
	Tue,  8 Apr 2025 11:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112783; cv=none; b=ZzVA9eMpbJtI1xPQjSNP3QphBGfrmUBj52koAiK+3CjtgBhOwp7u5jJfvRve0TTvoEofrwSgsy7gNO6g2sHhWItHUQgV1DbgbZDhe3QgyOdEMvunTUKMDwQnrZt3/2nGaSjZk5Pi8P1+03TDet9Xa1UFOc4M2ay7OULCRwVoSxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112783; c=relaxed/simple;
	bh=A6oB4zM9GrwxOYd8LaKpfkNEiKiRc56JmMnJ+g/JYQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H44PwY6NIK6ga+ktwQLBs1435q3hVvvjPzZkJKj2qqMoZe5y+3SS0WWJxiisb36Pb9QPB+tqEGOSXE91Cey8OF6yZn3hiq+waPbK4K+7W7eBKOdKb3COO0oS+4gI0urndrG1KF8Igb9robEYutWV4XPDLj6QNtCJqTBKJnS8DdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfrMzm7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfrMzm7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB40C4CEE5;
	Tue,  8 Apr 2025 11:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112782;
	bh=A6oB4zM9GrwxOYd8LaKpfkNEiKiRc56JmMnJ+g/JYQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfrMzm7pf3qaGYWX11/QWqEWtmk5qLTZa3xUShuZ6bUgFezl0V8MoAkybdwaxfMKZ
	 ccEgX3erk4FKLtNchxVEbCRDxrMuis4NcWH9OLLC1iz+hrtxmNMBcF/wiTz9VV7GPW
	 zU3shX8kUyYFBiKJ1MJvcXwxiI78iDb/2Kxn4dQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/279] soundwire: slave: fix an OF node reference leak in soundwire slave device
Date: Tue,  8 Apr 2025 12:49:38 +0200
Message-ID: <20250408104831.601234148@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit aac2f8363f773ae1f65aab140e06e2084ac6b787 ]

When initializing a soundwire slave device, an OF node is stored to the
device with refcount incremented. However, the refcount is not
decremented in .release(), thus call of_node_put() in
sdw_slave_release().

Fixes: a2e484585ad3 ("soundwire: core: add device tree support for slave devices")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241205034844.2784964-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/slave.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index 25e76b5d4a1a3..a5a9118612de2 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -12,6 +12,7 @@ static void sdw_slave_release(struct device *dev)
 {
 	struct sdw_slave *slave = dev_to_sdw_dev(dev);
 
+	of_node_put(slave->dev.of_node);
 	mutex_destroy(&slave->sdw_dev_lock);
 	kfree(slave);
 }
-- 
2.39.5



