Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF667993D;
	Wed, 21 Feb 2024 13:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521722; cv=none; b=c0Pkp5rqUOaa58itoqWzz2eq/wJ3WRt8IgAa57wlLyWucwUX3GO6ekB8MLo+tw+WnpMtnHN0Xmrh1LDtF37/fCVdlKvZPvefuZcgSvjj39vuZxcmlSMKolLp3qGPsumFoxUL/NDoCWPs4PKmw0MqQAISkKNngHmwihyGkiXf7+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521722; c=relaxed/simple;
	bh=U9Yrb5nvleG/rbIp6EYYbA9FU8tc1ueDXHOAxJczF/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDrp0IGlkzt+48ybuAYWlBliNXl0NBgD8lydlLRk4d4imvIjVO/cKNs2QisDTIPwn9HpBYS6IqFQgZtWS9lEZeM0SmV8wdTBHGFjrLxan20C3EZRPyClLFOn14pl+4hByWAj4dHjzuurm22TtnRw9yeWs5Y2r9gZKM5IVlSX5OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iw4LqTxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iw4LqTxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95A6C433F1;
	Wed, 21 Feb 2024 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521721;
	bh=U9Yrb5nvleG/rbIp6EYYbA9FU8tc1ueDXHOAxJczF/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iw4LqTxYWhEr5zoY6x8e0/XG6dq6htrOxln0uGumKJaEyapw/ODyhO9fEV4hIvuH7
	 IwaAVBuzB50U17vUYkRCehQbD/DhXkBa66FbfonTVj1sfTiFsCNG12YXwQGZYHe5Xu
	 T5YvxOkadnpCSYDcJCHduvLQRVRJbQE0jT4WIhro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 4.19 187/202] serial: max310x: set default value when reading clock ready bit
Date: Wed, 21 Feb 2024 14:08:08 +0100
Message-ID: <20240221125937.851748690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -600,7 +600,7 @@ static int max310x_set_ref_clk(struct de
 
 	/* Wait for crystal */
 	if (xtal) {
-		unsigned int val;
+		unsigned int val = 0;
 		msleep(10);
 		regmap_read(s->regmap, MAX310X_STS_IRQSTS_REG, &val);
 		if (!(val & MAX310X_STS_CLKREADY_BIT)) {


