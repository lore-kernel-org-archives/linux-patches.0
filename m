Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7120D48035C;
	Thu, 20 Aug 2026 17:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247378; cv=none; b=dRqP1WUXyZNjx9/t7ZFKF6SN/fsmEQaxtB0K/n+LtxpMJZz4LAHVZIPyzF7ypIeCH422D/cCf795574K7M4/7IurQ+R0iLlLmottDF6M4h/DMKyPagXb3z5mD0E6x8CA1+xmTlr7VtlGuX6rOr6wbI5oa3f87zntm8k2WLipnKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247378; c=relaxed/simple;
	bh=3QJtZ+8FE+7PC+ond5G+mMHFhU410CYVfd172Iv2lmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chjS6qdgXAOeDObmnBHUaCU2GcscI/TIyb1PKTPsLyBGeK6MsD6LYvB73MOCeP6cXqEeqQmL/tbXbhl151G+/41alczwgnLM1+dI2CWd9Gwo/ZjJmSbM7pc3UXwqflM07QMfMr8VipBOUSia3U2anW6A1g/DzyjKTmYx0wsc+ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7E01pic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7E01pic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E84F1F000E9;
	Thu, 20 Aug 2026 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247374;
	bh=nI1eT9h/Rn8TQCpVWDAq1d/0y2aCydpKvmY+ZlYiy6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7E01picncyIEP14HecDZSLZt2EWmioqdJnUY3N3GN6x4u8zKjPu+ZTK7sqTi1nFh
	 +uF8vILvtMKoUEn+zq562Q9med+oVPKZMfn+bMsSBEddp3wxXDOeP5cz1M2wUo78WY
	 Ux16OtcJ/aDAGAXhkSXY+SjXFjRM6hOtYSyPQjHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Davies <richard@arachsys.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 024/166] Input: focaltech - fix array out-of-bounds in focaltech_process_rel_packet
Date: Thu, 20 Aug 2026 16:54:43 +0200
Message-ID: <20260820145211.915142238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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


