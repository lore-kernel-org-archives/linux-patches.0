Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCD1136988;
	Mon, 23 Jun 2025 13:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684418; cv=none; b=U5pOabrrFrEuK3a7SBAucPjDJ1g0WNnL2H929PCAZtmBp/WOs40LqZpMd4aSMlYu109N7S8axPQx3rCdXzLQcjP+AJ7RW0EZKdj2umObo+o90yAeWL2iYJ0ekqaQbFy8M3kbSZ1e/ak5Qt2ZoInixzvXSA+NBrtLs9x8tlxdsMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684418; c=relaxed/simple;
	bh=CqvxmGDRHJ16zJW/Fk22Nyj6i+AMa/0uSIXRbpd1ixw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKFmjhs2pEptu1dWvWEUIB2ZIi89OrV3zjwmsUkMBv8621YqJWxGCIXFLcQy5KjYIoDitCsmgDiNxM2HDEbp5cxJQDIIELnYOJe5Dm93k8DoxFnkjpWzsFEmjLZ7VpY1pO9Po4Gp7OcJSN67+4/zuOnwHliTDXWSiDPc0KfKPds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGXeD10i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGXeD10i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358BEC4CEEA;
	Mon, 23 Jun 2025 13:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684417;
	bh=CqvxmGDRHJ16zJW/Fk22Nyj6i+AMa/0uSIXRbpd1ixw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGXeD10izMy0JFVf8wo4PvCIbTb3yiwEoksj5bhtyBBgAs3UPcDRKqvul5GYysWz+
	 SN6LcviB9NgZS5ehcxVuvfWyMU17BnJCa5y9dJqlCzoXGHVJ9P08jJmKbmYaixP6Jl
	 ERdavVXcWHF4lsHM4+VvN11deQIYdew4fCcXgERg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 060/592] media: i2c: ds90ub913: Fix returned fmt from .set_fmt()
Date: Mon, 23 Jun 2025 15:00:18 +0200
Message-ID: <20250623130701.683753698@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit ef205273132bdc9bcfa1540eef8105475a453300 upstream.

When setting the sink pad's stream format, set_fmt accidentally changes
the returned format's code to 'outcode', while the purpose is to only
use the 'outcode' for the propagated source stream format.

Fixes: c158d0d4ff15 ("media: i2c: add DS90UB913 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub913.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ds90ub913.c
+++ b/drivers/media/i2c/ds90ub913.c
@@ -450,10 +450,10 @@ static int ub913_set_fmt(struct v4l2_sub
 	if (!fmt)
 		return -EINVAL;
 
-	format->format.code = finfo->outcode;
-
 	*fmt = format->format;
 
+	fmt->code = finfo->outcode;
+
 	return 0;
 }
 


