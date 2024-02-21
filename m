Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047BE69951;
	Wed, 21 Feb 2024 13:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523315; cv=none; b=Uz5VvDK5n5zWMIhXPPivvh7SVYUt20xsbSJzctOl64VtxnVmvFgg6Jm/SimTNp4yS5xWCVXp9HPNVONOqLFx106RHT4Gk4QvF3t2aaTfASthRJEsIRO6NzPYBFAsGMVJ3V5OornHrJ9PIJdmrv3BJYuww7slcgzVHnMjjhljdoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523315; c=relaxed/simple;
	bh=GH5lNgmk9Jc9Q5iRx6F4rLp1Mor1qVoOQ2Lsbo13Yjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeaVGgWfMxTiW8AvJ/5etTzN2L/o7zGjcjbM35GBOVcML9xarZUClrfoQmwqgF1mvpu7DABTGXfM8Nv8oPL3+q5TRuauAJffWcLkL62KFLg+o39qxCTFO7FaJpQNPAWctjrmiLkQPo2b3xn1Z4cSUnwYtK+IIWQYai9u7MGNrPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgYUAVxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgYUAVxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66105C433C7;
	Wed, 21 Feb 2024 13:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523314;
	bh=GH5lNgmk9Jc9Q5iRx6F4rLp1Mor1qVoOQ2Lsbo13Yjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgYUAVxTJH4WMlrg9nWneq2kFmiZZ886DuP8IsmSbkFm3BasMYr3YIVzhH1Ua9wRp
	 CiJXRTPQx8PlnJNYzrqvZkjx3bApTYUsjY0yz9BkI0uWfrWhamtW3zp0p1jHembyeZ
	 lflQg8wbVFZr01vFurNhjl3D/q2CdnDn0SQ+0bcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 5.15 399/476] serial: max310x: set default value when reading clock ready bit
Date: Wed, 21 Feb 2024 14:07:30 +0100
Message-ID: <20240221130022.751991473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 0419373333c2f2024966d36261fd82a453281e80 upstream.

If regmap_read() returns a non-zero value, the 'val' variable can be left
uninitialized.

Clear it before calling regmap_read() to make sure we properly detect
the clock ready bit.

Fixes: 4cf9a888fd3c ("serial: max310x: Check the clock readiness")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240116213001.3691629-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -610,7 +610,7 @@ static u32 max310x_set_ref_clk(struct de
 
 	/* Wait for crystal */
 	if (xtal) {
-		unsigned int val;
+		unsigned int val = 0;
 		msleep(10);
 		regmap_read(s->regmap, MAX310X_STS_IRQSTS_REG, &val);
 		if (!(val & MAX310X_STS_CLKREADY_BIT)) {


