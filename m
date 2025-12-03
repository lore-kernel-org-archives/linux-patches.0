Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BBE346E71;
	Wed,  3 Dec 2025 16:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780036; cv=none; b=OgMtATp1BcVhR1R1f5ngJYyvwTz1uQCqsYlm2mS5i4lfPGBjRmdDe30fgWynWbNxZfM3KTKZwgDv/ziheuwEyMQVIi9Bt6OvoFw4fckaJ1u4ctg8USy8/YTgm989hIs5/jvVxuBFbh1noie2PHL2gj1Bbqpo/DPVqqcw1p/zoKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780036; c=relaxed/simple;
	bh=5DZbBv6PqaoeiSRm9+xtKo+JLHTe2mRUs1O9Yd8T3U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lC3CoDFlnezUZRAYWZCNIB6ewiRz9m30EqYt6uO4tVjvvb1Zy4u7k7pWUD0h+pkYnVB+bDvuXNlqKKS/XK99T63kqZ79iJEhF6nsRHiXBFh/074IOME/wPj96Aj7WyBYZhaOljKAjcOPrur/YO9vLPaSgrhnwP3EWUUZTqrfjic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiZOUe6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiZOUe6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E278C4CEF5;
	Wed,  3 Dec 2025 16:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780036;
	bh=5DZbBv6PqaoeiSRm9+xtKo+JLHTe2mRUs1O9Yd8T3U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiZOUe6b1Y5YuXUwAeivzc8/e8togaLoVUnXLE1CajciHSVKqyPXwQmyi9r9TOHcS
	 wn5z0n2jqX8PAljogA1G0BU817VElTrQZV2HNph4AQKbkIhz8eGIq/GsJDaEMPe/2d
	 Ab4nmfeyGXFPUjdRE0/wASTII2waE8P0jYyT4DkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 437/568] Input: imx_sc_key - fix memory corruption on unload
Date: Wed,  3 Dec 2025 16:27:19 +0100
Message-ID: <20251203152456.701000349@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit d83f1512758f4ef6fc5e83219fe7eeeb6b428ea4 upstream.

This is supposed to be "priv" but we accidentally pass "&priv" which is
an address in the stack and so it will lead to memory corruption when
the imx_sc_key_action() function is called.  Remove the &.

Fixes: 768062fd1284 ("Input: imx_sc_key - use devm_add_action_or_reset() to handle all cleanups")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/aQYKR75r2VMFJutT@stanley.mountain
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/imx_sc_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/keyboard/imx_sc_key.c
+++ b/drivers/input/keyboard/imx_sc_key.c
@@ -158,7 +158,7 @@ static int imx_sc_key_probe(struct platf
 		return error;
 	}
 
-	error = devm_add_action_or_reset(&pdev->dev, imx_sc_key_action, &priv);
+	error = devm_add_action_or_reset(&pdev->dev, imx_sc_key_action, priv);
 	if (error)
 		return error;
 


