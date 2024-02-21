Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC321E4B2;
	Wed, 21 Feb 2024 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524723; cv=none; b=M/F7jg+tgWVAzC0FahLNM/FWYxxJ5pX9bxN72mBmqEvj0eJCQiYGCe/rvYzGCaa2OF3e1gu7D8y0zjWX/Ky5JSbXaJSuYH8zXBcRxpfHCdPWIZ+Oz2qJWXGhqU1lDYG1TpX3cKu5FZRpwqKvLiVWaOBSevzDMt+UIlKCpea461k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524723; c=relaxed/simple;
	bh=0Eb1SlzJpuO4HtQ0IPtq+5nHxiZIBijepF9aqsR70PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+oWZED+4LyoUGubgnJ6aN759JN0k2XGSk4U50Y4a5tnnIa8fQ788uSLZcm9zwnCGvMwgP0w61Xl20R/B+OYq787E87Su1eWyDeXJPZDbLKibYe1QLAeCsa262cg6o6jbTUBnR24uxZI93l6uiFnZ0BXBsP+reVCjq+sW4Y4MN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7XCV8al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7XCV8al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E27C433C7;
	Wed, 21 Feb 2024 14:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524723;
	bh=0Eb1SlzJpuO4HtQ0IPtq+5nHxiZIBijepF9aqsR70PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7XCV8alnJJ+fcIKzHbxRwiinpmziho77ePwyArwQ4nefgPqnHGAMhLpuZT4OHFEm
	 bbImnVKcRZsIg6H6vYCiOimSoDhCmIT7fV4f2UCDdwqAmsD2IhnQx9K4co+vIE7Opt
	 wZIs43rb6S5g3XzoFLndbp5//qmuo3niw7Np8DaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 5.10 329/379] serial: max310x: set default value when reading clock ready bit
Date: Wed, 21 Feb 2024 14:08:28 +0100
Message-ID: <20240221130004.698326939@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -610,7 +610,7 @@ static int max310x_set_ref_clk(struct de
 
 	/* Wait for crystal */
 	if (xtal) {
-		unsigned int val;
+		unsigned int val = 0;
 		msleep(10);
 		regmap_read(s->regmap, MAX310X_STS_IRQSTS_REG, &val);
 		if (!(val & MAX310X_STS_CLKREADY_BIT)) {


