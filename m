Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DF844998F;
	Thu, 30 Jul 2026 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425339; cv=none; b=Ajc4YFGSAVLnyNpNZn2vUAdpVD+q1xs3zlIcmI1YBOHdNMTwzCGZm9CnMlunFbuEr4WxTPAWmz0RyEZA7iR9B1EyWyjR7qOEBjP1zM5jTHWfb5rrYPJ9fvPDsuuYzTaS/HgwU2XkBzqh3zI2moLRJuQtSP5GDKXodAGJm8drXmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425339; c=relaxed/simple;
	bh=1lTiAEG5CjIuvLXnIawQxZN3dV93gK9ZOQvuBTgyg28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWim86s6GCuZT0lEchC+AYue/4N3/Fuev6tJnWs3CBGOOlcFbmAzHNJJWkKPW/rArSJrIXok0/Av6QfppGvtd7dCI+3a8OE5asDZXC4fy766T51LitWu2XtkT3GGK0L77aN4Gq+WsoVVlTXxjWYhhfQQBAAXI8kN14FLT+w+2IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gS7M7Gxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gS7M7Gxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B31A1F000E9;
	Thu, 30 Jul 2026 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425338;
	bh=yMOl2FTEPT7JKbjD7tWmbtB8iJCi0g/IETZl2kpiQg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gS7M7GxqNFrRrNvrDjrbh6iS4XW4FKL1tLtAXc+jdSk53XpWtqNte8rNTANPWa9RN
	 jjh4jiFZn8ggYdXmpBSXfV+xlhQwrCxyTWY0vMJ+S3/BSu88XzMXaYhGi75onhtpYV
	 DFbkcZn8IMQT2ZM8WND1RbrXHDMTYMkRqf4DjMJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/602] Input: ims-pcu - fix logic error in packet reset
Date: Thu, 30 Jul 2026 16:07:06 +0200
Message-ID: <20260730141436.725041063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 2c9b85a14abb4811e8d4773ccd13559e59792efb ]

ims_pcu_reset_packet() incorrectly sets have_stx to true, which implies
that the start-of-packet delimiter has already been received. This
causes the protocol parser to skip waiting for the next STX byte and
potentially process garbage data.

Correctly set have_stx to false when resetting the packet state.

Fixes: 875115b82c29 ("Input: ims-pcu - fix heap-buffer-overflow in ims_pcu_process_data()")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/ims-pcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index 3dc624c75bb5c5..4cfcf6e945bba5 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -450,7 +450,7 @@ static void ims_pcu_handle_response(struct ims_pcu *pcu)
 
 static void ims_pcu_reset_packet(struct ims_pcu *pcu)
 {
-	pcu->have_stx = true;
+	pcu->have_stx = false;
 	pcu->have_dle = false;
 	pcu->read_pos = 0;
 	pcu->check_sum = 0;
-- 
2.53.0



