Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C11982871;
	Wed, 19 Jun 2024 13:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802252; cv=none; b=csUUC8SfROakc2qZ+mKN8+N7LzwDeRPibB6FgrK68hO0N/6pkIwR5gGHmiu6CEd8FfnxjaANnfGK9v7Owp9B1XLwovnLlVnbnK2olxraYVzkNB0PuCXKrNGvi12pkSOuf7FvgljI4B/jmTlyfsOqS/EocFTsUBnCCUx4vmW7GaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802252; c=relaxed/simple;
	bh=hT99GLNEp4L+0D9aYJLSvC7eqBedVB31EQQNOG6NkAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1pa+42/gph4v/8MTeKeoOMjStVo4fBg1TT4QazK+XMli/RcIdp6L0I3h7xdZXsfb2KAd0CMkyiFhizZhcyFNbYXLxIUzaEyIKPiRsNp/BQPsY6C3+lSDMo4+aARBUWegsotEpXM5EyDwVSSR1GB39pjPJ/6y0rVjP3mi6ymzaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap5LLgzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap5LLgzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DA1C4AF1D;
	Wed, 19 Jun 2024 13:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802252;
	bh=hT99GLNEp4L+0D9aYJLSvC7eqBedVB31EQQNOG6NkAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap5LLgzFyOIBCMYsQHWsvI5lsiOdeVzwk4DyQO2ZquriPdrQqfddW6IwLmuaqj0PN
	 JtnPj/a9jUNrVsZy+rW3RNOCxpUJReY1A142OWrGo1Nvi+iapSGRadGtvKeGcMdwdz
	 WE2fiGSYnEB+irPQx03B9c8Mi9uWkRFn0NVr8x+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/267] HID: logitech-dj: Fix memory leak in logi_dj_recv_switch_to_dj_mode()
Date: Wed, 19 Jun 2024 14:54:45 +0200
Message-ID: <20240619125611.493665613@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit ce3af2ee95170b7d9e15fff6e500d67deab1e7b3 ]

Fix a memory leak on logi_dj_recv_send_report() error path.

Fixes: 6f20d3261265 ("HID: logitech-dj: Fix error handling in logi_dj_recv_switch_to_dj_mode()")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 3c3c497b6b911..37958edec55f5 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1284,8 +1284,10 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 		 */
 		msleep(50);
 
-		if (retval)
+		if (retval) {
+			kfree(dj_report);
 			return retval;
+		}
 	}
 
 	/*
-- 
2.43.0



