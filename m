Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA63C145B33;
	Tue, 23 Apr 2024 21:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908642; cv=none; b=Sw5WbAv709FJCg22L43o++90zeWm+aTU3ReVnE3z92Ia7A4MJ8tG3dtEif5i/TV8p7DFer1kS75f8sU392SUPuIVykkYt6IeF14h1X2jLTj+Ct/jEdYPx6o1X4yRy2qHV/zU2RPG83pNwhrzI11AQEZH4/MjZOXxFRaV6nFTc6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908642; c=relaxed/simple;
	bh=1+/PhaVopLjuHpB9YZtYbHjjxdn928VLJxryxmJCcVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i48y1kQkmp556xYMHIZqQm86sw1wsgQ8D1nExOj9SwLfv6VZMKQdzknXFBHuznds+JKMm+cQAgiK7lehekaX6Ur3eJuVL24nwk/Y77DiI5YOEEoE3036objwOHgpFr9KeNUKId4UU+XyfZ/vmJ8Pc28C9MIk5klzKhDhxEruUIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7E9ho1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7E9ho1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5D7C116B1;
	Tue, 23 Apr 2024 21:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908642;
	bh=1+/PhaVopLjuHpB9YZtYbHjjxdn928VLJxryxmJCcVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7E9ho1Fp4CwRiPyYf/xME6Kj0qhmb3hmFNW14Hzc1Yq0z8M6WqHfDJ6sSO2oMNpe
	 byvA27wmn1zBYD/ubzpv7W4RafePug+JKy2+jyQomTr9zapmvKz/xzg7CX/Qa9AjHq
	 Gxro2o4bvImWXJE2MCOlgS9utBrg368rsf5tYQGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.6 126/158] speakup: Avoid crash on very long word
Date: Tue, 23 Apr 2024 14:39:23 -0700
Message-ID: <20240423213859.815492907@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit c8d2f34ea96ea3bce6ba2535f867f0d4ee3b22e1 upstream.

In case a console is set up really large and contains a really long word
(> 256 characters), we have to stop before the length of the word buffer.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: c6e3fd22cd538 ("Staging: add speakup to the staging directory")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240323164843.1426997-1-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -574,7 +574,7 @@ static u_long get_word(struct vc_data *v
 	}
 	attr_ch = get_char(vc, (u_short *)tmp_pos, &spk_attr);
 	buf[cnt++] = attr_ch;
-	while (tmpx < vc->vc_cols - 1) {
+	while (tmpx < vc->vc_cols - 1 && cnt < sizeof(buf) - 1) {
 		tmp_pos += 2;
 		tmpx++;
 		ch = get_char(vc, (u_short *)tmp_pos, &temp);


