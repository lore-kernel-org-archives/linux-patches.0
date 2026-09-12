Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA79930DD22;
	Sat, 12 Sep 2026 08:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200156; cv=none; b=ROAc/CQENYEl59EPrcPCqM0PW0X+Indb/hLdE4mZlZixQtWobqdVqJ88clS3UJz8JF9PDgZ58IT3AtlFGyMUQ6Kda5p3IroTVZqiJP20Rh/xEQzXAcfslwmzu8W+f/emS6Ny4tRRrG6hoM3XrOULZImZyykWvTFQB4v6frDyLxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200156; c=relaxed/simple;
	bh=wptPWlxi9OxAb3GjISyjU0CdkQcvMOhoPqzn1kYJOOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqgpRI7XcPVtZoNXCSWcbd1WsMcv5y1yNm39lv6732sLG6qTeqW03xKDpso2aooGMWhhqC978r+A/cq3ObSy7b8W1T4+yXRAYDZBaA5WGqxxbQMCkE4zKXTZkoO8hNc9IfAF69ndjqvQV0Um2ZytzZy0cyqpvrHr8we6MYzMt/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zl2al1Ak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zl2al1Ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756C01F000FF;
	Sat, 12 Sep 2026 08:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200154;
	bh=7/va4h0Uxn2Z4jk6LRZvBnppaCchqWkJZfHbDqb1IZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zl2al1AkE76SzFNsXzYAqYvCYADvZBBsugXVrWNnu6PFciIZVeue7x0tor25NTC8Y
	 xpcG7VGKNFMg+wNGGS3prt+DGB2tFXhDSTumBSgYsdopyljIoYOC284S44XNTrpFVa
	 65UPEfjYZ5zYNkXvs531eQDlUY1Q0Y9q1ADvMjB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0690/1815] gpu: nova-core: fix packed registry table size
Date: Sat, 12 Sep 2026 08:40:40 +0200
Message-ID: <20260912065705.090439299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit 93b9511a3bba7f31d95502e5f912f0a476b0cf4a ]

`PACKED_REGISTRY_TABLE::size` describes the entire table, including its
fixed-size header. `SetRegistry` currently initializes it with only the
variable payload length, omitting the 8 bytes header.

Fix this by using `CommandToGsp::size` to obtain the actual command
size, including its header.

Fixes: 19b0a6e7c2be ("gpu: nova-core: gsp: Add SetRegistry command")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260722075253.B6DDB1F00A3D@smtp.kernel.org
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20260723-nova-registry-size-fix-v1-1-8f471ba00ab4@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/gsp/commands.rs | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/nova-core/gsp/commands.rs b/drivers/gpu/nova-core/gsp/commands.rs
index 514d75fb52b8f..0c2919b0980d8 100644
--- a/drivers/gpu/nova-core/gsp/commands.rs
+++ b/drivers/gpu/nova-core/gsp/commands.rs
@@ -114,10 +114,7 @@ impl CommandToGsp for SetRegistry {
     type InitError = Infallible;
 
     fn init(&self) -> impl Init<Self::Command, Self::InitError> {
-        Self::Command::init(
-            self.entries.len() as u32,
-            self.variable_payload_len() as u32,
-        )
+        Self::Command::init(self.entries.len() as u32, self.size() as u32)
     }
 
     fn variable_payload_len(&self) -> usize {
-- 
2.53.0



