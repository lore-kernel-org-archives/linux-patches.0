Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E8E47DD42;
	Thu, 20 Aug 2026 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247950; cv=none; b=SJP6hel0eqlEVBVIortB8khlWyosXA2d41aArpmmwmrzFHWX3JPlrd7bp1VRJ/kSEobmqyyqoL4f/44WKzE5UNGt2dRh232ZB25MFLuFy3CD5MnP5lJyrlqerRNmsQVGSG8DBcVVBHqQPkiBQmQeeVTaX/yK2LtVAOnl7tEsNM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247950; c=relaxed/simple;
	bh=Ij6GGijthNCh7AdHrhCgmPT6ROZmpEIA/+WJ3L15rm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cASlSDGzbYLuh7wjIgj2cD0dZn4DkTMKpTjGxb6/Y5knAnbyxXyYor4T9z/fCZdrv9683ZQsSWa9XgFY75zUYNZb74em0+1+oelup0h9sQQ7fK1TxzolVk5fn5rvXs+e2ZMGKBTftsuoeqB0VCCWLspI3L6ly2THyEi+pczZCS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4M6PB06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4M6PB06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683161F000E9;
	Thu, 20 Aug 2026 17:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247949;
	bh=E1JAjh3OIOHUth7P6/ntOEUJkzoiDOq6kVyGaCvCx1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4M6PB06VDw+pj01CVhoIQ8G+YMeLEGtTFtMZj4VSmjqF7yIWCwk/nXB9mXuL96IA
	 fICDzRMvdUhhsSq0F1Xbd20z7bTKF5xe3HGYpWqhULVtf0cXDXY+Tr/drXoH2OaHfs
	 fdA2EOtFy6ABcAoJIEFEM/FoNPoSnnAOdSDrQyh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Davies <richard@arachsys.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 021/303] Input: focaltech - fix array out-of-bounds in focaltech_process_rel_packet
Date: Thu, 20 Aug 2026 16:52:37 +0200
Message-ID: <20260820145253.817989361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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


