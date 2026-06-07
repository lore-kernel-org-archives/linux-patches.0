Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280E32E7373;
	Sun,  7 Jun 2026 10:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827208; cv=none; b=tI93OBv6USnWtRSzyZikjLtKdUQ3xEoP0r5OLRK6A8r3kruRbWkHg1eNp0v5y5FY/FPoHW7vfBhgStsQ+QWYnmT7itaF+XiLlVBAcPMTJ1E58UcfJ/yrsP5u6bpxXUismFFaoi3+RDtU5/yhLFoZuHfjc44VU3ghorq4i8tHHDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827208; c=relaxed/simple;
	bh=yJx8ccpbfv3nNe6Dwonx1YSDrwerby8JcNu496JO2Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ln5V0ncKQG1HZoPDCsDw43axXbs0psvYttiELh9Jg+OXUnZMUj7xQvxIEiHwx1Oj+fS+2X0JChtZplHJ8oboLozUlAyPk1gXq0Udb+XisG1hi0cpZDZ+8yTYQ0c1BBpR88W/ehY031Y+h+oyvEUkadgMnIZp+PQXCSb9EZZlC/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKzZDfVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKzZDfVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8601F00893;
	Sun,  7 Jun 2026 10:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827207;
	bh=lMN0hkQxvb+fOKGPiVkc/NCHV99cGPwW07qFNkZYOT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKzZDfVEiyOEWV4C8w3DKSP7QlQQ3uvCmwTJNoiEumotfUIzj/AJ0dTTn9/C4vPiz
	 Hhe1pY5wq00RQV9KYRV4wI+ltpTHUhvK8jMn9DH4SdG7NR4dDtoaCKy160NVVL7Dm0
	 c5zU+4QKJdFp3m2sZ5NXkeQhZqeXy0ez32RVdMKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 072/332] ethtool: tsconfig: fix missing ethnl_ops_complete()
Date: Sun,  7 Jun 2026 11:57:21 +0200
Message-ID: <20260607095730.781932379@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6386bd772de64e6760306eb91c7e86163af6c22f ]

tsconfig_prepare_data() calls ethnl_ops_begin(), we need to call
ethnl_ops_complete() before returning the error.

Fixes: 6e9e2eed4f39 ("net: ethtool: Add support for tsconfig command to get/set hwtstamp config")
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/tsconfig.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/tsconfig.c b/net/ethtool/tsconfig.c
index 966c769c72677f..990dca9a3fc564 100644
--- a/net/ethtool/tsconfig.c
+++ b/net/ethtool/tsconfig.c
@@ -69,8 +69,10 @@ static int tsconfig_prepare_data(const struct ethnl_req_info *req_base,
 		if (ret)
 			goto out;
 
-		if (ts_info.phc_index == -1)
-			return -ENODEV;
+		if (ts_info.phc_index == -1) {
+			ret = -ENODEV;
+			goto out;
+		}
 
 		data->hwprov_desc.index = ts_info.phc_index;
 		data->hwprov_desc.qualifier = ts_info.phc_qualifier;
-- 
2.53.0



