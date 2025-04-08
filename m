Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEE427935A;
	Tue,  8 Apr 2025 12:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116519; cv=none; b=mM+vPnTlcEWxnXpIeVOqXk1AdEHTecbnmFt0/4SvyC+lBJSSPqY8A9GZLnNZBuo65LcMazBrKNjHdqq2todh06dEOZhgUcuYEm9ikBOh4tC+hdmVIoULVfFJbl5S+zWqSkSkVk/hcOYAkN/tfVHzDgl0nwiRFSJvh/K8erWXWo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116519; c=relaxed/simple;
	bh=mfy6HlGQT9yyj4vUmXniX0u8J1R08iJ7cykoCytJ6ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWmHBItAllyWAAV+dJA9gxqW5BgC0W+PBMsOkBYWnnXQUcmUAHhkKmqCBCv+F/nIUfAca04LEVqwK5gvAL6ouYlAaVEB5dyra3/ToKaHmIz26RBMEyb5ItgZg6rP3lb0ry5P/9wPdDsd41z7U3jOuQJRTBbQpAjmYojyg8uX+yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=an9Sb8JK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="an9Sb8JK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A780DC4CEE7;
	Tue,  8 Apr 2025 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116519;
	bh=mfy6HlGQT9yyj4vUmXniX0u8J1R08iJ7cykoCytJ6ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=an9Sb8JKEpUrbsUCXy+GqbuV4T/ozH2OIBbuAFwDuQlHIPBdqhQf/DTsIqYh9KlZ0
	 2UTQFE2/B3T6s4Z4num62NpHlOcUTDQfTealZKwpQ+4fh7GkuYFQUjVvrw5aF6rceW
	 nJCsoyyobVCIQI31M6/b9zF2Yo0WN4madjRq3DZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/423] soundwire: slave: fix an OF node reference leak in soundwire slave device
Date: Tue,  8 Apr 2025 12:48:14 +0200
Message-ID: <20250408104849.655097226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index f1a4df6cfebd9..2bcb733de4de4 100644
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



