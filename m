Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A22502554;
	Wed, 30 Sep 2026 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782344; cv=none; b=LD6EXDwlmVmDfl7ANrL7xd5MhaUhxvFmBUF9KFZokrGOM9UgFRuqOiRLlzA0R/7/djq8QHdjddNP87PqNyEabwcG0xJtNKCs4AUa4TQ9npUCY8zJmKcZVuIEFZBZytwoIN5RhRphmAStm2/iNtsjxW+EQqliag9XOUv1yA34Gq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782344; c=relaxed/simple;
	bh=iRvxgToI0ru96Gdlv7fvM+KvZRcjmKWQcLeE7HWlnzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ParI3+l3DUjO1dZjIzG3KJ8iMt/UtD+wEAGqmBUTNTfwUgWpmKIf8uyEuWh/iEcxbLi4qaXBLG13aU+UzRMY3xzm6u3IqdU6sFG1S3rdzIpnHqnzVgbfY64zKwTfM4bBpKPkF4XJ8mGyB/HcFhveLPNxsBE/KNxrzryCGv13+xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJUS64uR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJUS64uR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CD21F00893;
	Wed, 30 Sep 2026 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782331;
	bh=zi+JI1JJ0BkSTZDooQYYk126f9rlqIl/gPzXFu7/FGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJUS64uRe9tuSMsjaHaDzmSw/VEl5klNC7rf+auQQ8ZmeVUzg08fh8zlI+kkSqIG0
	 QcTMAKbWHOHL5Hkhxc6HIMTXeyerOBNg/IWYha5c1u1GwTzqXKR66DkEwpk+cW5tvD
	 oi0Pu7VIxO5Zxh7T7RkT1rGQEX+MgHNt/kv17v4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/595] soundwire: validate DT compatible before parsing it
Date: Wed, 30 Sep 2026 17:18:23 +0200
Message-ID: <20260930152347.940438145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a08f4081c1c48..30cca4730fc2b 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -209,8 +209,8 @@ int sdw_of_find_slaves(struct sdw_bus *bus)
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



