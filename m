Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8271B413F;
	Mon, 23 Dec 2024 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970851; cv=none; b=lER2vAu0Q5QbavToy/+o29431idG/P8uLY18AYbFVAANHpoNNjUs4iVrsVSZ76rs/7qHW8k+peiz31sQ0qy3RaPrk01LzO5TOn9UWXpfeh17wv5mHAiSlZvSfY7zxuJzOH4lbSLxUwpp3tyCM7vIEVOFrBjt9k22tVDBGuoslhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970851; c=relaxed/simple;
	bh=Nciu8oy9LJd2ymBV1+wzohVrvIg014ifjQQT0wNiutw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0oMf4KRGRt/HkMX+bokd5ywSqQ8BQeXSrIH8F78L/uSwhf2KXeQcLQobCVxTVONso+1EZM23Vk9qoJUa1Z3f3O2Y3XRkTCZoA1fC8oCIg5T2eMp8mFxaQiLdqeI3Xx00FBT/xr2PZTw5crFKBTIY/LjNXTgPfHiZ18z4QNM9tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+7A4VXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+7A4VXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8BCC4CED3;
	Mon, 23 Dec 2024 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970851;
	bh=Nciu8oy9LJd2ymBV1+wzohVrvIg014ifjQQT0wNiutw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+7A4VXSsDZCgcewN/lAAdlYQ/cMFuz9vvD3mfVhcJcctJvHIt1ZsDa6IJ1+4NsYP
	 TkDN73fWInwPlLYQTJ+GlswI2YsheyWawM1n/MbPK6mBsp4j6XVt7BfJ1bBUcV4qKG
	 2G0V5wzF0Dhq2QsQEzNEF9Dt4xEYoHAkgTyrMxk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 69/83] of/irq: Fix interrupt-map cell length check in of_irq_parse_imap_parent()
Date: Mon, 23 Dec 2024 16:59:48 +0100
Message-ID: <20241223155356.300122505@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit fec3edc47d5cfc2dd296a5141df887bf567944db upstream.

On a malformed interrupt-map property which is shorter than expected by
1 cell, we may read bogus data past the end of the property instead of
returning an error in of_irq_parse_imap_parent().

Decrement the remaining length when skipping over the interrupt parent
phandle cell.

Fixes: 935df1bd40d4 ("of/irq: Factor out parsing of interrupt-map parent phandle+args from of_irq_parse_raw()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241209-of_irq_fix-v1-1-782f1419c8a1@quicinc.com
[rh: reword commit msg]
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 67fc0ceaa5f5..43cf60479b9e 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -111,6 +111,7 @@ const __be32 *of_irq_parse_imap_parent(const __be32 *imap, int len, struct of_ph
 	else
 		np = of_find_node_by_phandle(be32_to_cpup(imap));
 	imap++;
+	len--;
 
 	/* Check if not found */
 	if (!np) {
-- 
2.47.1



