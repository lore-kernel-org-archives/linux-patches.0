Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BB52BAF7;
	Tue, 26 Aug 2025 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213288; cv=none; b=MsTj68K1kbVvAMQNBX/PgRo0L/oUalL7TvviO4Aj++hSfKVO1uGUhRPrRWsP4ewkVMJT4z8Bb/iPLpSyl3PRH+WLIQaQjmVxOnuwnLfHLpJMYV7tl8tcJIRkOjQMqd+aK18PQH+wdDkKo9gtVEQq5KhFylozisbj11F2ue6yhpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213288; c=relaxed/simple;
	bh=l5nf+ucW5/RLkV0O+aXyQT7Ken14cqEwekeDvGDF7nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljZvB9Cj5a+I3j+L2grLRSr0iYsXYz5LstmERlQVK7Lnasb7pQxxaHLUqQRGsKe1yjFSfIFQwhlDCiPxPw8ZO/UBuGsVr0oixpDwync5qGYpUCCHpCLx8CdmL1PTF0YMxXq98dpKxGS5fkeTtor6cEkg1v7ORXVPGCZjRl7kTjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvOWbTbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvOWbTbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA00C4CEF1;
	Tue, 26 Aug 2025 13:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213288;
	bh=l5nf+ucW5/RLkV0O+aXyQT7Ken14cqEwekeDvGDF7nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvOWbTbfkdBaRYrZCAJxy0ksB8QPSYJM9FIeSokQifaVqtmtYq8DqZ3d43OidF7U+
	 d2TBd2Rl+bA2lt8bGsPshTMJDnJ72CHaePDXk7fsqAnsHZeyt1GOiYaSznNNB9cSrI
	 oTphG26AZshqoY2lQ6s9HCzgmBZyQWr46qf9yQRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/587] soundwire: amd: serialize amd manager resume sequence during pm_prepare
Date: Tue, 26 Aug 2025 13:06:48 +0200
Message-ID: <20250826110959.520110726@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 03837341790039d6f1cbf7a1ae7dfa2cb77ef0a4 ]

During pm_prepare callback, pm_request_resume() delays SoundWire manager D0
entry sequence. Synchronize runtime resume sequence for amd_manager
instance prior to invoking child devices resume sequence for both the amd
power modes(ClockStop Mode and Power off mode).
Change the power_mode_mask check and use pm_runtime_resume() in
amd_pm_prepare() callback.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250530054447.1645807-3-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index b89f8067e6cd..3d8937245c18 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1104,10 +1104,10 @@ static int __maybe_unused amd_pm_prepare(struct device *dev)
 	 * device is not in runtime suspend state, observed that device alerts are missing
 	 * without pm_prepare on AMD platforms in clockstop mode0.
 	 */
-	if (amd_manager->power_mode_mask & AMD_SDW_CLK_STOP_MODE) {
-		ret = pm_request_resume(dev);
+	if (amd_manager->power_mode_mask) {
+		ret = pm_runtime_resume(dev);
 		if (ret < 0) {
-			dev_err(bus->dev, "pm_request_resume failed: %d\n", ret);
+			dev_err(bus->dev, "pm_runtime_resume failed: %d\n", ret);
 			return 0;
 		}
 	}
-- 
2.39.5



