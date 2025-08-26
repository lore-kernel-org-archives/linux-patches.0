Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A855D34DCD2;
	Tue, 26 Aug 2025 13:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216447; cv=none; b=TDKUYxNWRXIWBCfOEXMrCwxwpWr6dOVzmslCPzZatlB5TSIf62nY3lpu9I5gGhsIq383LzJv13HjXAeofcqk1kqR9J3/xsR+XmnJEDAWhE1yfV5bqM95WrIggvmgtpve7GGf4J/ohktnUoGHhYbDuswTix+hPRLZ3739ibaIhPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216447; c=relaxed/simple;
	bh=J2RBogaE6ouD23FPWlBQ/fPuvqLJ7l+/nCjPWaCyIDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBii2mX5kOhPz8nQUzw0wZrCwe2ZDRHQ3ebeIV9JKgBIIekU/y5lgYu54HGqWdr2RE6eOCpL2I4EPvaj/oIGgMhK9UueWsKNyIbblvMRtZP9D6FcFAKuUIpSfx7Njny6XygpqAxZnU0Cc6aYm+pXRGZ0phHmAEy0+jDkEGah7HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xegq18AG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xegq18AG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADEEC4CEF1;
	Tue, 26 Aug 2025 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216447;
	bh=J2RBogaE6ouD23FPWlBQ/fPuvqLJ7l+/nCjPWaCyIDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xegq18AGNpoQsCS54p+k/F6tKdq6dOMUNSgE7wpuyCqo9I+00ca157qOiVw5b6ON4
	 KVgxrg6N3ZW5iXPjGgGEUe8LWTrG1Y1Kk4nOrle8AMDh9mAwCctejxkPBC8anWlQMr
	 SE+LReQ7lHa9DSgS+9k9mIDzr5YdXZnzdEjq84+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 415/644] i3c: dont fail if GETHDRCAP is unsupported
Date: Tue, 26 Aug 2025 13:08:26 +0200
Message-ID: <20250826110956.741242618@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 447270cdb41b1c8c3621bb14b93a6749f942556e ]

'I3C_BCR_HDR_CAP' is still spec v1.0 and has been renamed to 'advanced
capabilities' in v1.1 onwards. The ST pressure sensor LPS22DF does not
have HDR, but has the 'advanced cap' bit set. The core still wants to
get additional information using the CCC 'GETHDRCAP' (or GETCAPS in v1.1
onwards). Not all controllers support this CCC and will notify the upper
layers about it. For instantiating the device, we can ignore this
unsupported CCC as standard communication will work. Without this patch,
the device will not be instantiated at all.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250704204524.6124-1-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index ea6556f91302..717b337f9e22 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1262,7 +1262,7 @@ static int i3c_master_retrieve_dev_info(struct i3c_dev_desc *dev)
 
 	if (dev->info.bcr & I3C_BCR_HDR_CAP) {
 		ret = i3c_master_gethdrcap_locked(master, &dev->info);
-		if (ret)
+		if (ret && ret != -ENOTSUPP)
 			return ret;
 	}
 
-- 
2.39.5



