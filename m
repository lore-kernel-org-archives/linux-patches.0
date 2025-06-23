Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3E2136988;
	Mon, 23 Jun 2025 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684407; cv=none; b=DqNvgTMAit4m5Gthkba9c2QXr7jnlP+JVhevtA5wlglM968shoDFzixPxjY5cOILY3dpnBzvOAoMBo9EC7iwCyP2sMOGqteWQnaVZIM2K9YclYwo0v9s2gHogL+UX0Ul6eKswiG8h+O0k9S7OU2NsJVuUVKAKpkM07AArxYiXVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684407; c=relaxed/simple;
	bh=mhCZZ3eJJQ0K+cpfKchdFeOh02ObUQt281UNdDU70NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDR6Z8B9B55TemWvOZkKz3PpRdG8oWHX9dMqBU3djzPVwGKNWQg2r6nRpFB0kupVPxrGP6r+D5Dmmgp9cefzrQ66iAXSrTAF2yM0HdzSf25wetLwVUArBcFEwr+13WoSrEeeDsYVdIQDD5OwgqhGjqLyHCQhX1LD5xz+JRPx/lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+eqtiXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+eqtiXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD3CC4CEEA;
	Mon, 23 Jun 2025 13:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684407;
	bh=mhCZZ3eJJQ0K+cpfKchdFeOh02ObUQt281UNdDU70NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+eqtiXAl+6TU+YKu/2Vgdc7scxuBz0hT4765akpF7KJZRbrL5wbNhV9CEHyXCk78
	 vrWvOcR51wyRmntnmTN0IfR9pclNZcXDpmsLbQ9rI5sajXPvYbPRM545Fm7YgZcmjA
	 UrrPYE18Qnvsd9pqwoNs6HpMuACVX779G7PFZ/Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 056/592] media: ov5675: suppress probe deferral errors
Date: Mon, 23 Jun 2025 15:00:14 +0200
Message-ID: <20250623130701.590413401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 8268da3c474a43a79a6540fb06c5d3b730a0d5a5 upstream.

Probe deferral should not be logged as an error:

	ov5675 24-0010: failed to get HW configuration: -517

Drop the (mostly) redundant dev_err() from sensor probe() to suppress
it.

Note that errors during clock and regulator lookup are already correctly
logged using dev_err_probe().

Fixes: 49d9ad719e89 ("media: ov5675: add device-tree support and support runtime PM")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov5675.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/media/i2c/ov5675.c
+++ b/drivers/media/i2c/ov5675.c
@@ -1295,11 +1295,8 @@ static int ov5675_probe(struct i2c_clien
 		return -ENOMEM;
 
 	ret = ov5675_get_hwcfg(ov5675, &client->dev);
-	if (ret) {
-		dev_err(&client->dev, "failed to get HW configuration: %d",
-			ret);
+	if (ret)
 		return ret;
-	}
 
 	v4l2_i2c_subdev_init(&ov5675->sd, client, &ov5675_subdev_ops);
 


