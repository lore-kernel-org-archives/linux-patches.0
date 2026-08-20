Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308EB47CC89;
	Thu, 20 Aug 2026 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243207; cv=none; b=u2OpuDLRo2suos7G9XNIqLlM/IYIV1CL11VeWUBfnA+gf812jom85qSKOv4abbDu/Z4GI9foB6PooV0HlbGQrAiDwpWZFPmdgg/txQKgOLdBJywi5ytkisxmjQiEf4lIGB1V+mlg3Z6LAoyKQ11ymUD2+xwqd11CIXRKwZjPctQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243207; c=relaxed/simple;
	bh=V92FYV3nplxcyxeEQJVWZgyA+yjbrzaZbYISPRFO9GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hpg3sjtxSwYNFWfLUMccrG3kKxx8G+G5qFbn2r6hm9hqcW4acVEIg/cLR9OP/m5XEJb4YjTKL0vqPLkM+Ja/HRmS8MQoFTXq0HnvQq9mQuKqg6y9VY2ZZQ22dgdd7cS9G7qqwBAkqaT2CzP81uu1WyVQ8sUeG2DiZ8IRl1DIoa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tapwR8sB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tapwR8sB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B51A1F000E9;
	Thu, 20 Aug 2026 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243206;
	bh=sD0bMycgkWvpe41e2NvG/JYH5LBk/YyFA4Fd0F2+mIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tapwR8sBR2xzdhJEbvby0VkKHHx9pfG+bgHGaDaeILS/CYvhG71VQonweBVQ5BNyk
	 IQeNKsbvCTW2sHwIGbAQ67owQ0yJmV5GcB7XEngjVmB+UhHLssMYIF64eaONCixCfq
	 I+yA37+z5OD4R4jNhPTLFuXzLuG3drGnsoUf0B70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Davies <richard@arachsys.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 015/272] Input: focaltech - fix array out-of-bounds in focaltech_process_rel_packet
Date: Thu, 20 Aug 2026 16:53:19 +0200
Message-ID: <20260820145231.694550471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Davies <richard@arachsys.com>

commit 296736076b3fd078742651c719555a488624023a upstream.

Make finger2 (and also finger1) unsigned, so that if the finger index in
the packet is 0 then subtracting 1 creates an array index which overflows
above the existing check for FOC_MAX_FINGERS, as the existing comment says
it should, instead of writing to state->fingers[-1].

Fixes: 05be1d079ec0 ("Input: psmouse - support for the FocalTech PS/2 protocol extensions")
Signed-off-by: Richard Davies <richard@arachsys.com>
Link: https://patch.msgid.link/20260701190932.14960-1-richard@arachsys.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/focaltech.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/focaltech.c
+++ b/drivers/input/mouse/focaltech.c
@@ -197,7 +197,7 @@ static void focaltech_process_rel_packet
 {
 	struct focaltech_data *priv = psmouse->private;
 	struct focaltech_hw_state *state = &priv->state;
-	int finger1, finger2;
+	unsigned int finger1, finger2;
 
 	state->pressed = packet[0] >> 7;
 	finger1 = ((packet[0] >> 4) & 0x7) - 1;


