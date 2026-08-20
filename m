Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFE647D46A;
	Thu, 20 Aug 2026 16:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244035; cv=none; b=beo4jfu9rf/AHi0x1DPrbkL/tzdkrmG46EDa82dh/A4oG1TLetYgqV2TnaAdLa73sTsit5doOWTvLvsDnC5S9gNiMgAVRnjHm7JpBcA2dxGFIPRu7SyP8kqUOyArpbgSjNuozOYSjoUmk/GNyPBaJhxTSc5b3lCq7m56zUR9fNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244035; c=relaxed/simple;
	bh=qt56gLkyugtDjiCh77I0db14nAutSvob/NKmxqzM2NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJPSj3z34a3bX3PxdfdjnTCnOj55nLQ2fYbiWUNwXL+bmUU2NYcdTnsBGARPlLs+EwXJlambHLwY0NQiLwv3I1WkC9sJLJpsjNkl7/wXdxoi1ixjER84F24MXdjKKUra45HZVTAO+ZOOmaHb2Hz/9usHJDvMxHljSNJ8I7z8/n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EF0E7jWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EF0E7jWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338811F000E9;
	Thu, 20 Aug 2026 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244034;
	bh=JTqFuhyhm9cBvLTas4ASUiWmCjROlP9/nvfXlXIiekg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EF0E7jWXog9hBOywGi/TE16NHwoeQwbsOd1lPsn6qKMuPjD/j9gYQV5g5jUeV5pb5
	 NlKaZ0smULDT+T9rnqJzHY5uuXWl9JWELzqnzwbUxTBpwLlV/rTlT1GhPhyujb/ltR
	 3L8gs2FMbFRbugotVLSjOk2UoNB0blF3MQXVjFpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Davies <richard@arachsys.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 012/235] Input: focaltech - fix array out-of-bounds in focaltech_process_rel_packet
Date: Thu, 20 Aug 2026 16:54:08 +0200
Message-ID: <20260820145216.813207505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


