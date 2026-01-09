Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9D7359F98;
	Fri,  9 Jan 2026 12:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960092; cv=none; b=qLiSFpIzWN7FX2yn+exT+j0ww3nQ+54LlQm4qmTvCd9ZVa5vBUjz1/MIaThlUvDIkF/FHkcxT8wDQNfQo04wSaAWaJld8HZviWkysg5nZuaIHISfQQzv11qzKoLJJZ3edox12nmRz4kL9rlZQ0GNeR+JgC1o4LnF4A8uU9NTjEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960092; c=relaxed/simple;
	bh=DeWfbSu6gY2FUA3B+YePQruStgJ9LAH3x/9//mt+nTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uni/lvIMqCFe+y8oU3TKC1eMnXlkH31gSyzdyXCK7jWWwa96NtF+gQhSpg3RzJNkVZYuzDOwSNVrD+g1/oXLlxFKIj3Eokj9i+Cxhpg2inOgtMyxinSV4BziifVLNMVb3ANnSboPSX9exUCGmR2wQ3XPzxwOOPsow3StsFqXMvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLcwsI+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLcwsI+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9BAC4CEF1;
	Fri,  9 Jan 2026 12:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960092;
	bh=DeWfbSu6gY2FUA3B+YePQruStgJ9LAH3x/9//mt+nTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLcwsI+pBORI5h5DYS2VuDxKZAIUzR1RB1J74JQZ+R7w7WEaqLsMpkly6V1qODhim
	 yZu/pRDC+yWX2c1gOUz5e4wM9HxXyCEVlGqlKJ23oi0NHWaJMDENoKe9FMQ6IibV1t
	 yBrnga2d1sq6E9kq8ukLnO3STR1zvRyPu9nM9raA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Link Mauve <kernel@linkmauve.fr>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/737] rtc: gamecube: Check the return value of ioremap()
Date: Fri,  9 Jan 2026 12:37:00 +0100
Message-ID: <20260109112144.583753979@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit d1220e47e4bd2be8b84bc158f4dea44f2f88b226 ]

The function ioremap() in gamecube_rtc_read_offset_from_sram() can fail
and return NULL, which is dereferenced without checking, leading to a
NULL pointer dereference.

Add a check for the return value of ioremap() and return -ENOMEM on
failure.

Fixes: 86559400b3ef ("rtc: gamecube: Add a RTC driver for the GameCube, Wii and Wii U")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Link Mauve <kernel@linkmauve.fr>
Link: https://patch.msgid.link/20251126080625.1752-1-vulab@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-gamecube.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/rtc/rtc-gamecube.c b/drivers/rtc/rtc-gamecube.c
index c828bc8e05b9c..045d5d45ab4b0 100644
--- a/drivers/rtc/rtc-gamecube.c
+++ b/drivers/rtc/rtc-gamecube.c
@@ -242,6 +242,10 @@ static int gamecube_rtc_read_offset_from_sram(struct priv *d)
 	}
 
 	hw_srnprot = ioremap(res.start, resource_size(&res));
+	if (!hw_srnprot) {
+		pr_err("failed to ioremap hw_srnprot\n");
+		return -ENOMEM;
+	}
 	old = ioread32be(hw_srnprot);
 
 	/* TODO: figure out why we use this magic constant.  I obtained it by
-- 
2.51.0



