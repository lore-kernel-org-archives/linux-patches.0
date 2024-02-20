Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE6114F9C8;
	Tue, 20 Feb 2024 21:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465057; cv=none; b=dr5aO8+pvc/vrgmpbF/dEysoGK8SkipTwEsfXwnKITf6YmmOiZlVKLf0chZeJQPKZZ7sRKByFEeIUNGxYcq1UOu6A1CtsKb5wwEkdXoBg75UD2GAfKla5lcdCR03Uls9qoiSjIsd1eGSDmR1LeuNWSb/DeA5KDytuhBpFPsVIbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465057; c=relaxed/simple;
	bh=cuy74OWAHtOnyEeLllKXFl+fhlr45HHWI6bNYkU4MNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diCsRSA+YxMUPgxMGonJiOijV42fdcARyLO3MiGn+8K5l1XEkd5TMdGQ4MPEC3xGp9ta7c3hxmkhyLI13+Yw7o2vrpW87hVLxKjDyf55Q5SW8pxz4DtEavPctzij9wnqcg2q49JWiyLVFobnYy0Y0TSvTMAunpHMdIutn8euCZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUMRo/2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUMRo/2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2FDC433C7;
	Tue, 20 Feb 2024 21:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465056;
	bh=cuy74OWAHtOnyEeLllKXFl+fhlr45HHWI6bNYkU4MNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUMRo/2NsTdiY6J2eH93XfTfB4425aWutohNE/7rYYN9PS/SOZcRrg9TNP8cu3ryX
	 JAO3YdqdYLosVAYFKe98X2zyvLJxyWrblgIAXb6X9SER8pNe+uBLtiOcIglLqCkIEP
	 vLDZMdF6JluhCe1LaNpI54CSIBISB5TIlAP50V4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.7 221/309] serial: max310x: set default value when reading clock ready bit
Date: Tue, 20 Feb 2024 21:56:20 +0100
Message-ID: <20240220205640.072098092@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -641,7 +641,7 @@ static u32 max310x_set_ref_clk(struct de
 
 	/* Wait for crystal */
 	if (xtal) {
-		unsigned int val;
+		unsigned int val = 0;
 		msleep(10);
 		regmap_read(s->regmap, MAX310X_STS_IRQSTS_REG, &val);
 		if (!(val & MAX310X_STS_CLKREADY_BIT)) {


