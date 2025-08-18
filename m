Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6381B1F4177;
	Mon, 18 Aug 2025 14:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525994; cv=none; b=utKDdng+NQ4k28fQEZe873/633EE5OKlog5F6WqERMWqnqswaOg1mq8brmI2iIEqRwdOJuRPOJMSKuvt7Bb7WSj18uwnGo0OtvxrX8TBlcni4jIaqYIpwllQXXAuoO/I0KIllFcOCFl7c0E6nOtJiHguDYlAdOCkLawUNRYd6EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525994; c=relaxed/simple;
	bh=5ZfqADvBNMxP13oOmor6tXSbSAVdhkmKem5cWRXftMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrQGGWjc8QAgT3mOZpEzwEKN2Eu7DSpSODG6NiulEvxZDd4AknOvoLnZ7j5gAaFAmiwF/WFVhaXploPQYScgOlT8t9LcpTtQNiXe5zFuF1/QUrYZYx+LLFWACFxnl8XV1k6ppkysBWYJHpss5e9fXkEFtPB+tHtHpTzBe0pM66c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4RQEXrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4RQEXrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9EDC4CEEB;
	Mon, 18 Aug 2025 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525994;
	bh=5ZfqADvBNMxP13oOmor6tXSbSAVdhkmKem5cWRXftMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4RQEXrPNFyHWRG0x2zXGlPjaUk6bATMUXKK80cJDnUEUMy0k5byj0jRBADAc3MYM
	 bR5AOu+mCPnAAYvT8E5SRfm1DqsvD2IHYtUx7y19MfRfm9w/sFONvxGZtc16lDgIyg
	 byCDcg7oo76fGs/CP/yH8ocoLy5kaQIFUL4Zoxng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 428/570] i3c: dont fail if GETHDRCAP is unsupported
Date: Mon, 18 Aug 2025 14:46:55 +0200
Message-ID: <20250818124522.323532175@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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
index fd81871609d9..e53c69d24873 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1439,7 +1439,7 @@ static int i3c_master_retrieve_dev_info(struct i3c_dev_desc *dev)
 
 	if (dev->info.bcr & I3C_BCR_HDR_CAP) {
 		ret = i3c_master_gethdrcap_locked(master, &dev->info);
-		if (ret)
+		if (ret && ret != -ENOTSUPP)
 			return ret;
 	}
 
-- 
2.39.5



