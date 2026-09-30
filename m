Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA6F33A6F1;
	Wed, 30 Sep 2026 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794508; cv=none; b=XGTgtKwugTTOfpsaFvM1RD1sS0GBBFNFV1jjpCvxGKBpk9+gM14yLv5ALgrLmtVvvinHp3O0++VwL0rLBhsQWp4rLsPJ3xNEIryqqrTbBw9+p0SPmUjMCGRW0tptmAar2tgnmIAmGmczD5NHJxVJs+NOnj6xBlCOHO+U9NcHC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794508; c=relaxed/simple;
	bh=EQN/qO+fJ3aq12xse2P1WuBI+uQilrsa870fMXNzEO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW0qKOvvPTEbQ6ZbhXeE+Su0oPMrhbmA9p5wcXITLKAsWfNRav6nKJDD/EGPWvzXtXuhsdimECQ64/9no2yOTHC0HL5cbPNnNlSzpg/aNutxCYdv9g37ekxoghYNArRLkRBZX/r/LuCOKD7weih1S3aYsb+qbi6QnNY1Cuj8V7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tw+yAKsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tw+yAKsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94D31F000FF;
	Wed, 30 Sep 2026 18:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794506;
	bh=wJzvJeA2WSMWAKQbP5ATeR6V5Q2Jg5894IqOdMkVT5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tw+yAKsBUUvg/ZZbIOQ8R7KZC55G1tynha58jJ8ygAanLmzJEyEfsFRi2Ahe2ETPE
	 iiwh0wyoSvOdgrjs5elev3jQEEYjFTDyfbFfq0WyFpIrlB67l8hbCbgnYVo+NkGFCA
	 OyxLgOth8x+nLFuQ7EyO8F4ZlcmHWOdiBpKiqryY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0228/1193] HID: hidpp: fix potential UAF in hidpp_connect_event()
Date: Wed, 30 Sep 2026 17:15:12 +0200
Message-ID: <20260930152439.261521118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 6df6b1f2c49678211f65647c300bc51dda02893b ]

If input_register_device() fails, we call input_free_device(), but keep
stale pointer to the old device in hidpp->input, which could potentially
lead to UAF. Fix that by resetting it to NULL before returning from
hidpp_connect_event().

Reported-by: zdi-disclosures@trendmicro.com
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index eba52b95ad1bd..a2cad1b33e4eb 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4313,6 +4313,7 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
 
 	ret = input_register_device(input);
 	if (ret) {
+		hidpp->input = NULL;
 		input_free_device(input);
 		return;
 	}
-- 
2.53.0



