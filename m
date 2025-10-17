Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9311D2F12CF;
	Fri, 17 Oct 2025 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713650; cv=none; b=ELZl5h/dF3uQ6qiRV59lVYlT/Qyj6wEMT1uzW3kLIcnpGeabADg4ZqVDHohnIAfObvKEPQtqlwtIHz6o4QWqXsL3Xycm3XPba7wfijswpJURhu3v9j0NjeBUrOAG4jKE1zZmC23VD7+e+lAHXXcD/4vUrsxIkrcq9IAt0ckyuUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713650; c=relaxed/simple;
	bh=aoUIbxMLVO8vYgv9TlhT5UAy9HkDh3oC4NLL6er0hxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlB80caU1dJlvaCB5KW6dH0v+r3uF7cgORDkeOij0BfhP+vXwlh1PcvwHbnHhr3mLmpNbu1oxmMB/1qu1UJFc7eyO5H77Bn+sSyzLNgsTnT2GYd3xNZpDRKxXXOGklDYx3TsTgKjLQeu6/s14VW1rV4V/oNrQx3u82FjDcn0caU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHP9N9d7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHP9N9d7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17827C4CEE7;
	Fri, 17 Oct 2025 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713650;
	bh=aoUIbxMLVO8vYgv9TlhT5UAy9HkDh3oC4NLL6er0hxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHP9N9d7LEzaYRDYHrRJ1vPjx6z0QTuMFjUYvll0Fsx9w+BF9jY/94HP50DXVavfQ
	 OWkPwz24qgt0t74Uni/TAYF0G1AN555etrZxQH5vyyPu3VvGVWac2BihrbBRwBq8io
	 UhXySXZZ+GWjUR2g1NoAK/5CYeJCDrztgCbY1pC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlo Caione <ccaione@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 071/201] firmware: meson_sm: fix device leak at probe
Date: Fri, 17 Oct 2025 16:52:12 +0200
Message-ID: <20251017145137.363160886@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 8ece3173f87df03935906d0c612c2aeda9db92ca upstream.

Make sure to drop the reference to the secure monitor device taken by
of_find_device_by_node() when looking up its driver data on behalf of
other drivers (e.g. during probe).

Note that holding a reference to the platform device does not prevent
its driver data from going away so there is no point in keeping the
reference after the helper returns.

Fixes: 8cde3c2153e8 ("firmware: meson_sm: Rework driver as a proper platform driver")
Cc: stable@vger.kernel.org	# 5.5
Cc: Carlo Caione <ccaione@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250725074019.8765-1-johan@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/meson/meson_sm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/firmware/meson/meson_sm.c
+++ b/drivers/firmware/meson/meson_sm.c
@@ -225,11 +225,16 @@ EXPORT_SYMBOL(meson_sm_call_write);
 struct meson_sm_firmware *meson_sm_get(struct device_node *sm_node)
 {
 	struct platform_device *pdev = of_find_device_by_node(sm_node);
+	struct meson_sm_firmware *fw;
 
 	if (!pdev)
 		return NULL;
 
-	return platform_get_drvdata(pdev);
+	fw = platform_get_drvdata(pdev);
+
+	put_device(&pdev->dev);
+
+	return fw;
 }
 EXPORT_SYMBOL_GPL(meson_sm_get);
 


