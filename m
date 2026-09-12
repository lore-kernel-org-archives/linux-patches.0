Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58496479895;
	Sat, 12 Sep 2026 11:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213468; cv=none; b=krPOI1PK4FiCH4HE5gqDK+MTDk8q/Dc8udPAESIpYfD6D0EUkM28JwpFKdy+lABFJNzpTiSYKfdjQKuAAbSxezJtFy5ahfuEDBPn0kmoGkqUPeDV+ZTLe6V+yo17Wbptnn55qk4RSkAwiAbJaQOdSuzlqbZDzrK0SkKPfG6pWSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213468; c=relaxed/simple;
	bh=fIHOJ4r1i39Uxr8Sftfl59HfcKXVc+aGOpL7DN43Eek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyxVWDz2BT/bgIb/KT3gNAUZwb8GQW3LJsOi5dAZzagupdew3pPNN0OoRs3b+aVN3iS3Nf/XL9ATju6qTRsbkBlTtMZZFqiOEMqrwQP7SOOnwz0mJ/IwkWlt52iJCqOGNp8Vgyq7yoOPVilUF92ESQctA5VKeqnyAG/YMF3AWr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgBHuwU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgBHuwU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0106E1F00893;
	Sat, 12 Sep 2026 11:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213464;
	bh=W14/N8ObY1AbIxGoJI+PxZh7l6q3BxPL1pI5K7FIKNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgBHuwU6EINUHtLglY09KlypAD8ZrYWxKfYUmvKm9KYegP0bfkB8Oq4YWrEZmxOLo
	 lL+aA7oSld42whShmtyfHVJlNB2GV+fe9Xss9tegw37yDHTOJMGxZ+icTLFA+EuH5G
	 Oimbkbs3X3Sx9VkZmcbwtNhB2LG/ZBoh/f8zm6wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 0126/1376] i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure
Date: Sat, 12 Sep 2026 08:42:32 +0200
Message-ID: <20260912065610.364003040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 62edb8ca0aa44517cc23cfa26cd8a51f15ea92fe upstream.

of_parse_phandle() takes a reference on the parent node. If a later
devm_kstrdup() fails, err_rollback only releases nodes for indices
0..i-1, so the current node is leaked.

of_node_put() the current parent before rolling back.

Fixes: 7c0195fa9a9e ("i2c: mux: demux-pinctrl: check the return value of devm_kstrdup()")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Cc: <stable@vger.kernel.org> # v6.6+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260813095617.2246320-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -247,6 +247,7 @@ static int i2c_demux_pinctrl_probe(struc
 		props[i].value = devm_kstrdup(&pdev->dev, "ok", GFP_KERNEL);
 		if (!props[i].name || !props[i].value) {
 			err = -ENOMEM;
+			of_node_put(adap_np);
 			goto err_rollback;
 		}
 		props[i].length = 3;


