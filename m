Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474B34EDCA2;
	Wed, 30 Sep 2026 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784043; cv=none; b=uQIUyOE46bzHzl3iWIHbqfEqA95Hsyjcr943FyJv1guRGUfuNSw1B6G8NA0FAaPWCJUOyTlqJ1HLTAhhZcC9WBzhjS8xc5ZC6vaR1d6ocnwqQm/XnloIbugAgf1MWh0mb4z+YNrsq3hGSmOji2cyX5cat1iP3OMjB8z4VHKmfbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784043; c=relaxed/simple;
	bh=qwSsqFyZTl6QV0pZXQA0i7x9K0qRxukEkpeLsTeiplc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOe0118a4wSg4wwiy9B/jrK34pszShx0s0hDnMeG3wu4/3AHLYptsIMdQrrXDw0w7y78W/JTky97p9X02zee9DgL7ppVzXCVkXK6xC63lfUGDJC6YSReuDJp63kuOipFTWHvxCf7djharK6RnmjdVrVAhzkOl5/HXJMFZTZt2LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kq8lcP4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kq8lcP4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDBF1F00899;
	Wed, 30 Sep 2026 16:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784037;
	bh=dDlgLRq/wDvGU2NO7cpVhj0IIYDpeoeUQVn8wR1fRCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kq8lcP4j8UMDKi0ZLOreBZg+N57hAEMq58c529JQLRWsNW6jbh6Yn5zYwqtlMf5yz
	 mLSivay7wtKqh1g+lE4lCYJCMeP5uEBWMcnLS35i4+6d5PP5HA3yXUlfRQB+N6+RlI
	 FzEbvoaRSrANB4Dy81EzfgHwzAkizB5IuGFpw/00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/982] soundwire: validate DT compatible before parsing it
Date: Wed, 30 Sep 2026 17:12:31 +0200
Message-ID: <20260930152417.115452977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 28b0d7b6d780c..60a80904e75bb 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -233,8 +233,8 @@ int sdw_of_find_slaves(struct sdw_bus *bus)
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



