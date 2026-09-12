Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A59D38AC87;
	Sat, 12 Sep 2026 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221560; cv=none; b=QiLwTtyli7w3zP5mZ76cFJ1+kJf+gJvpnkTrgJ//2Yc80PzQDg+OdloVUMVfEU5YQ5MQlLtWk+TbKK3sa4cWy9QYsSwpgCiRhlnEdusbHw6ZkeEF6a5XmjLOPszADRYVxmOyHvpkjv9sIMG15r4ps++JGF8S47X3Mzg3ku58eHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221560; c=relaxed/simple;
	bh=D1Esb971IDgmf3POHYQ9VblAFdVaQGTjmMvKvkLtQhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHElckimobXymVWSuncM6Hz7rChZM8Dhv3zipQ/z8ssWxFi5Mp2FbhXff5TJeVkzkfB5G0d0UDgTp1okLfNhAkYyLPV58wIlfUWcp3HuHwEF6G3dggzCwALM13/sPEjaPSrcqYYqjU4rFp/bSrv+BshKDaeoD/1SE8LwPjw1L3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBlhR9ni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBlhR9ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA7D1F000FF;
	Sat, 12 Sep 2026 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221554;
	bh=h6qF4r0oaqJjoG6wDe/twD61YySsfjUPCq6kEIMf3mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBlhR9niXrkFhcIvJo0qNqZibapaOXXvZQjfgfzfG6tEx6n+x3pvL55aAeqWp9anA
	 /2qzTSCNPI4Faly8rwZQrbUOsy27kMvCYpO3mHIsQd+ac2mRFoYtA4UKaZyXSCQOJa
	 cyAXGr7TpSA7lJ1fbgG1kru6T7Qd+vuulo78ZUP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 0407/1424] i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure
Date: Sat, 12 Sep 2026 08:47:19 +0200
Message-ID: <20260912065616.398559083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -245,6 +245,7 @@ static int i2c_demux_pinctrl_probe(struc
 		props[i].value = devm_kstrdup(&pdev->dev, "ok", GFP_KERNEL);
 		if (!props[i].name || !props[i].value) {
 			err = -ENOMEM;
+			of_node_put(adap_np);
 			goto err_rollback;
 		}
 		props[i].length = 3;


