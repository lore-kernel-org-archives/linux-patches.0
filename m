Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE154FD7AD;
	Thu, 17 Sep 2026 17:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667249; cv=none; b=a9VJJspzC6/EQEoYDLmSmYHiPks41wB96Bf/vbeAx/cIxHhviz/tkW6UUATtkMYbNo+8zZiqwZ6rTtMZ107yTBiLBBFkdWhM1Iu0ZYSDkZq6084NnHufiwLVKjTzfbnCjEEYzSRdIdUB5m9z55nTI+6Scyh+xwcUzdOstoNE86U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667249; c=relaxed/simple;
	bh=7i9Kghz5yyT8aUZ+D8M+7/f2lHGIN3VEG3wL6W7ol/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXwGYiNyeyKCGlfIHOpqhOaXDM18UIRKkZvZup7Ovw7Mq5zni2SmSvzvRiyVf3/8lW4wuFJCLibJiDVmplznlD3rdI7Xk6jI0g8siBBQwoEbqUbz0wEUcLdIaTxLPyUL+3ZU4dO+Vk5SZueh1CcH76GO4hMtbAn5tpd/zkle8UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y674XQXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y674XQXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCEE1F000FF;
	Thu, 17 Sep 2026 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667247;
	bh=cLP6E1VxPX+65U2PEemUvpIpY0FjiGUnsnHhJoOC43w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y674XQXqix2S/c9X9HFiGz1uVl5x34XVueci+lpvDFlc0t/X5eACXTwoN1tVJFg6u
	 jmxzVzpeNcSEqwSv/MrhuvAfCXZBGQ8DZy4CELi03P4PB4MxQMhM6g8ASWkgubdEiM
	 mhjsLpAUsvW5C+0obRHB8hdAPhu6gFlAsAywxAhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0029/1102] soundwire: validate DT compatible before parsing it
Date: Thu, 17 Sep 2026 15:59:32 +0100
Message-ID: <20260917151540.170198901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 45c7bda7b7440183850012153988e40b300f40d0 ]

`sdw_of_find_slaves()` fetches raw `"compatible"` bytes with
`of_get_property()` and then immediately parses them with
`sscanf("sdw%01x%04hx%04hx%02hhx", ...)`.

Live-tree OF properties are stored as raw bytes plus a separate length;
they are not globally guaranteed to be NUL-terminated. Validate the
first compatible string before parsing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260403183504.4-soundwire-compatible-pengpeng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/slave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index 2bcb733de4de4..918110421c5d7 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -228,8 +228,8 @@ int sdw_of_find_slaves(struct sdw_bus *bus)
 		struct sdw_slave_id id;
 		const __be32 *addr;
 
-		compat = of_get_property(node, "compatible", NULL);
-		if (!compat)
+		ret = of_property_read_string(node, "compatible", &compat);
+		if (ret)
 			continue;
 
 		ret = sscanf(compat, "sdw%01x%04hx%04hx%02hhx", &sdw_version,
-- 
2.53.0



