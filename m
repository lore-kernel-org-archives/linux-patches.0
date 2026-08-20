Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B933644C1;
	Thu, 20 Aug 2026 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238137; cv=none; b=O8CH05jjzyUa1qFrZeQlTEMPwpi1cxAXa37/ZobLGthByUFYsERK77Xkm9X5GOLOAtQ6eCpJXAdoCurIGd5rZwfeoefaI501YMrkrabdMmiN0JrN3Bh0JX/jM1l01sN0rCNJolXQSKjofPhLWN1B6r2lquOZHbfKaLDQ7Sch7hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238137; c=relaxed/simple;
	bh=/IZtdeCUoCcMHzuHfDGrK/DPgKaA8ZU4FO+UvLKtt5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGRVsJ2ihPrBu7x/OTW+nvljS+hdT7h2MPp6VRtErbHWfB/tONI7O/rIkSmp8mXP7F2V/C5+pCvSDHbL5d7JG0Pvhc/oUN5hDHTxyAeJ4ptTEdx1imMzrE6mQiBwhjmKiScUZx+Z0g5MkLVZbyNfegvInngPiM2sf+w5LQlwO5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nzwnfhtd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nzwnfhtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F6E1F000E9;
	Thu, 20 Aug 2026 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238136;
	bh=4bokesH9KyuXL8b/fDXas3EHFia0/hpSilglb7pFflg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nzwnfhtdk+7UgThd77hW2QQujk9bbFe1BT8CJKpOpnElADk+Ynhw93jLLufQoZlCN
	 PtbkSkQxoN8y0ulyjdWcgZTenCaH5msnP+rGhb/XpvZ2mOgLC96s0Uao2lY5VF/5+c
	 Ik0EBykom8FE14VeNpZlb7GLUDUYcubyIipCNjW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Davies <richard@arachsys.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 044/228] Input: focaltech - fix array out-of-bounds in focaltech_process_rel_packet
Date: Thu, 20 Aug 2026 16:53:06 +0200
Message-ID: <20260820145245.810625924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


