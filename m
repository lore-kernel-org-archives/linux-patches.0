Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D3F40BE9;
	Sat,  3 Feb 2024 04:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933631; cv=none; b=rjbQSKvmLprw3orPqZx559w+4IQqOGAUboq+5RM5IKgDhWiJV/7gd88cL1LyWWf2AfQ4vZniBvhnY4sfXGWMCUsrLe/mo5/jzSDa7zOy5uJW79TvSak9v7IqMtra1VJazvPcLjIwXWFZM9/Yc2XErZjOdmnrls46iMfwOMhINkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933631; c=relaxed/simple;
	bh=9wuJkemhTZulx93C1QDXvUyoZC+c8OhJENqg5wTrBpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3YVuWGQ+Ff0jNeWsRXOg8ruKPtpTesBBxkj1FoK5/EkarRSuIfAMlf8uVsYA0gV86wxSO9igqvucfPW6wiiV6kov4xsLttkbBsCbgyqfh23aj/ewp3tvlH+jakQyqg0nP9HGJjQq1NAnrgCxyWT7b9wARwYrNQJVgWWz+N5qq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMPYqp1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMPYqp1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1321C43394;
	Sat,  3 Feb 2024 04:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933630;
	bh=9wuJkemhTZulx93C1QDXvUyoZC+c8OhJENqg5wTrBpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMPYqp1g+IH1mch6K4joxr65N0sF+2dVSZdg8WzAeK0w2DFp4tK2h492OhGgrQBPD
	 mqvMzvUA8ea+O5lvGdqwMKw9XeonIqrGJg9rkxFdVDt7hyWfmAkCrdO6x2U7PoVn4j
	 gohkiOQs8wiiPyEOTKOhFlrRuma8djpAWDVqbFvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Elder <paul.elder@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/322] media: rkisp1: resizer: Stop manual allocation of v4l2_subdev_state
Date: Fri,  2 Feb 2024 20:04:41 -0800
Message-ID: <20240203035405.205786359@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit efa28efd9cba015f8c3d88123527c3c3cfcd13d0 ]

Supported media bus codes on the resizer sink pad are identical to the
ISP source pad. The .enum_mbus_code() handler thus delegates the
enumeration to the ISP's operation. This is problematic for two
reasons:

- Format enumeration on the ISP source pad is dependent on the format
  configured on the ISP sink pad for the same subdev state (TRY or
  ACTIVE), while format enumeration on the resizer sink pad should
  return all formats supported by the resizer subdev, regardless of the
  ISP configuration.

- Delegating the operation involves creating a fake v4l2_subdev_state on
  the stack to pass to the ISP .enum_mbus_code() handler. This gets in
  the way of evolution of both the ISP enumeration handler and, more
  generally, the V4L2 subdev state infrastructure.

Fix those two issues by implementing format enumeration manually for the
resizer.

Link: https://lore.kernel.org/r/20231126020948.2700-1-laurent.pinchart@ideasonboard.com

Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/rockchip/rkisp1/rkisp1-resizer.c | 38 ++++++++++++-------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c
index c15ae0218118..eb0aae56d2c7 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c
@@ -363,12 +363,8 @@ static int rkisp1_rsz_enum_mbus_code(struct v4l2_subdev *sd,
 {
 	struct rkisp1_resizer *rsz =
 		container_of(sd, struct rkisp1_resizer, sd);
-	struct v4l2_subdev_pad_config dummy_cfg;
-	struct v4l2_subdev_state pad_state = {
-		.pads = &dummy_cfg
-	};
-	u32 pad = code->pad;
-	int ret;
+	unsigned int index = code->index;
+	unsigned int i;
 
 	if (code->pad == RKISP1_RSZ_PAD_SRC) {
 		/* supported mbus codes on the src are the same as in the capture */
@@ -388,15 +384,29 @@ static int rkisp1_rsz_enum_mbus_code(struct v4l2_subdev *sd,
 		return 0;
 	}
 
-	/* supported mbus codes on the sink pad are the same as isp src pad */
-	code->pad = RKISP1_ISP_PAD_SOURCE_VIDEO;
-	ret = v4l2_subdev_call(&rsz->rkisp1->isp.sd, pad, enum_mbus_code,
-			       &pad_state, code);
+	/*
+	 * Supported mbus codes on the sink pad are the same as on the ISP
+	 * source pad.
+	 */
+	for (i = 0; ; i++) {
+		const struct rkisp1_mbus_info *fmt =
+			rkisp1_mbus_info_get_by_index(i);
 
-	/* restore pad */
-	code->pad = pad;
-	code->flags = 0;
-	return ret;
+		if (!fmt)
+			break;
+
+		if (!(fmt->direction & RKISP1_ISP_SD_SRC))
+			continue;
+
+		if (!index) {
+			code->code = fmt->mbus_code;
+			return 0;
+		}
+
+		index--;
+	}
+
+	return -EINVAL;
 }
 
 static int rkisp1_rsz_init_config(struct v4l2_subdev *sd,
-- 
2.43.0



