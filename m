Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402C93BC4D8;
	Thu, 15 Jan 2026 17:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499554; cv=none; b=hLKq1p4O6SInXmzVN3jVgl9+yYdTHxuL11gzFQ2dGLLWu4eKPFE5aKA3uRe2bJId1O7zNt+G1CDCaU/8Zw5ngEXIMT7BgXD5w1MEsKPOrbej3C/EzM5D5U4ilNQX1++LRSr05a2ZL/JFoykm7jivE+F94v1jV0CM9CQeo3z6zWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499554; c=relaxed/simple;
	bh=VsAuiMGR0cw4hngnJ6xTq/0XsIATkRdOdMpOCVDAkbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4qxOkkFrhcaSzNW/CbXpHHnfrOlvYhVakUPI42agJmgal6ghrMPmIDRj9YxkbOx+XM9GZbJ5oIyVW8YpItS9E9hSI8Z5ykfxxMz3AdckUEhYb3i0f767XAxeBNzXmpjOCQHPxbG+OKq9sYk1pG1W14MOtFjiKhHNrzFAKdEbR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwX9tHWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwX9tHWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7A5C116D0;
	Thu, 15 Jan 2026 17:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499553;
	bh=VsAuiMGR0cw4hngnJ6xTq/0XsIATkRdOdMpOCVDAkbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwX9tHWwxGaLDVwvO5f7FGPqlEyO86FKbtzJ2lM8i7uCHzoWvzf9vmGpGU5Fj5a+8
	 8qVtdn+ACT3ctq1VNQ3myXA/caBmB3bpU24VHm3tOmsjJJQsOhxELCD20uQgvRm54K
	 8dZq/CBQDS6zfTxHPfEmRt5Z/t6762nmWYWaFUnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.10 266/451] soc: amlogic: canvas: fix device leak on lookup
Date: Thu, 15 Jan 2026 17:47:47 +0100
Message-ID: <20260115164240.509032989@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 32200f4828de9d7e6db379909898e718747f4e18 upstream.

Make sure to drop the reference taken to the canvas platform device when
looking up its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Also note that commit 28f851e6afa8 ("soc: amlogic: canvas: add missing
put_device() call in meson_canvas_get()") fixed the leak in a lookup
error path, but the reference is still leaking on success.

Fixes: d4983983d987 ("soc: amlogic: add meson-canvas driver")
Cc: stable@vger.kernel.org	# 4.20: 28f851e6afa8
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20250926142454.5929-2-johan@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/amlogic/meson-canvas.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/soc/amlogic/meson-canvas.c
+++ b/drivers/soc/amlogic/meson-canvas.c
@@ -72,10 +72,9 @@ struct meson_canvas *meson_canvas_get(st
 	 * current state, this driver probe cannot return -EPROBE_DEFER
 	 */
 	canvas = dev_get_drvdata(&canvas_pdev->dev);
-	if (!canvas) {
-		put_device(&canvas_pdev->dev);
+	put_device(&canvas_pdev->dev);
+	if (!canvas)
 		return ERR_PTR(-EINVAL);
-	}
 
 	return canvas;
 }


