Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D46359703;
	Fri,  9 Jan 2026 12:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962488; cv=none; b=XzWRLIqtFBrJvguW/eXcLRAosVaYU5LDyBMSmxG5TfrralY9pzBpdpm40OEtXHGOLFFTPPl6hb+48wBLkL7NFMn00yzmAUC9VVo3XRuewFyWmEfb0dv9bOZB4agY5GFpz23ipLsC67L4bVaL33U+xL7gMyTOBuTRW/E/XJv+I6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962488; c=relaxed/simple;
	bh=Ajc3SphGF3sQPug64cg4O/+kYy3duALiguqyUT9Qp2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=map0HqSeMiiNp5assNH4Y/bxoGjxGy5IJhhkUJQbxP6rUNo9rm/L7tWmzW2txSVXFcDLeU6b3j3kUkCdHVxpJStZQSnklT0zqYpcj+7jWcwlhLWux88gHUy62/hAA43Hq6O056JUCwvz30hUZRxdtu9G9GwABWZ3yEfBYJ8jJP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g308Qpvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g308Qpvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864CBC4CEF1;
	Fri,  9 Jan 2026 12:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962487;
	bh=Ajc3SphGF3sQPug64cg4O/+kYy3duALiguqyUT9Qp2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g308Qpvxcwu46KN17CZx3E4Ps/3Lkx/MAcBmEOk6sriiPIrb0o/ueutJXy1UQcFJS
	 JoWGG+4GF9F/FzT3ormEbwBCPlsKltXZ0mVpcOPwgfIwYSp4kkjWvoMIhXobrntHK1
	 RNAbWYB9SjZISfqSI7Pep57zqHrJmAxOtdjyq55g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 381/634] soc: amlogic: canvas: fix device leak on lookup
Date: Fri,  9 Jan 2026 12:40:59 +0100
Message-ID: <20260109112131.867224830@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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


