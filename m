Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F18C269899;
	Tue,  8 Apr 2025 11:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113098; cv=none; b=ANADxmbsBrdwlh62kRMvhEvacqjM39k4l531AdmouPD4UsJy8CPR8T0rU6Xt54tNwaXwRtFkT21AkHPLkEFI+PsQjy0Qcm+OyzwlP8ewNYGWF4qfcT3vD0oIXXgCc5OALYAzo+hT3SMuG/005uWXKH8TqSCimi8h3bZGzSAgaE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113098; c=relaxed/simple;
	bh=C+t+o5T+m8vIERIu/AjJUy3hD4kpnGYeY3nGbeE42IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5/M/P1s4ccTxgoMnQ2VXvxi23Sym2NYfW/nybzRdvIgebMtNFDJMCzU2cRZHCof3a7AzvzDTYru4//1C7waqmuCAkOdsTavE6RQ/D3ti34lF9ISS8xWszsvsI3icbEwLXZvlBZCE0e0uouMifExjIFL8UWtQOejmSCdDLFBr00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bnpqqtfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bnpqqtfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0344EC4CEEB;
	Tue,  8 Apr 2025 11:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113098;
	bh=C+t+o5T+m8vIERIu/AjJUy3hD4kpnGYeY3nGbeE42IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnpqqtfhByUtaKES6A7sHMt3LcQ3lL5x6ggrUsvzT1lte216BG7KXHJ9QY6wk7OKU
	 pILxP44/Xmj9oVKzT1D8U3POnpMA24L75vetzTdNgAwDfaVQzEvZONKk/zbOhcZgKr
	 +3Kf77lOH7fVBSrDaE3vCIqtIjfpbDrnMiYyIN8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermes Wu <Hermes.wu@ite.com.tw>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/268] drm/bridge: it6505: fix HDCP V match check is not performed correctly
Date: Tue,  8 Apr 2025 12:47:25 +0200
Message-ID: <20250408104829.420932034@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Hermes Wu <Hermes.wu@ite.com.tw>

[ Upstream commit a5072fc77fb9e38fa9fd883642c83c3720049159 ]

Fix a typo where V compare incorrectly compares av[] with av[] itself,
which can result in HDCP failure.

The loop of V compare is expected to iterate for 5 times
which compare V array form av[0][] to av[4][].
It should check loop counter reach the last statement "i == 5"
before return true

Fixes: 0989c02c7a5c ("drm/bridge: it6505: fix HDCP CTS compare V matching")
Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250121-fix-hdcp-v-comp-v4-1-185f45c728dc@ite.com.tw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index fe33b988d7523..e094165e584a5 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2039,12 +2039,13 @@ static bool it6505_hdcp_part2_ksvlist_check(struct it6505 *it6505)
 			continue;
 		}
 
-		for (i = 0; i < 5; i++) {
+		for (i = 0; i < 5; i++)
 			if (bv[i][3] != av[i][0] || bv[i][2] != av[i][1] ||
-			    av[i][1] != av[i][2] || bv[i][0] != av[i][3])
+			    bv[i][1] != av[i][2] || bv[i][0] != av[i][3])
 				break;
 
-			DRM_DEV_DEBUG_DRIVER(dev, "V' all match!! %d, %d", retry, i);
+		if (i == 5) {
+			DRM_DEV_DEBUG_DRIVER(dev, "V' all match!! %d", retry);
 			return true;
 		}
 	}
-- 
2.39.5



