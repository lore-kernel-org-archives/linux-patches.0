Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133D186347;
	Tue, 27 May 2025 17:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365415; cv=none; b=Cr+3o0h2pslcgboxR/AH7ViMEMD2qTAGJS1zxsHpILLF6mIahfCnzky4KV1cKRMzLbzM5P0gKXl0/ocOAn4i/pn0NhA+i5kSXOhUXW3xVyXcxO/FoJfj7dZJ5u0MZyMoyLacw4ARDWEqXbsWqwBIsTFy8igY9VEn/IPhrCK4EIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365415; c=relaxed/simple;
	bh=QfsV8XIeeZOvTax7mHcuLIs5pK8ExMVPcCUYGz/PCX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9EGQee/F+en4AZMihjOxnavp36BSLKg0E7Pv3cWwFXsTh2vE3xhu+GLNEL4PkVaYOET+7AWFEbgWbnksHTG8P3znBN6rdJZiExIGxgiu75FAQJq3bCX651lOOFuacZxGF827P8nT47JvPptz7jVuiNTjpv6BDIu1RKdQvk224s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsvAVdfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsvAVdfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773B8C4CEE9;
	Tue, 27 May 2025 17:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365414;
	bh=QfsV8XIeeZOvTax7mHcuLIs5pK8ExMVPcCUYGz/PCX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsvAVdfacGU8VuURC4l8zV2eFq4ofs2d4FbfLJvToNI3f/Ppu64p1pSq0hyS6aW4G
	 bGHHo1lqkf6I+tzTKsJ0v2pLmfVzWFDBP/6UXz0VhWRgaYO7G01ECO3rT14LAn7tjZ
	 0InoPHMosUHEOoXcUodkv2Rf+weD14I7gwNK5BzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 368/626] media: v4l: Memset argument to 0 before calling get_mbus_config pad op
Date: Tue, 27 May 2025 18:24:21 +0200
Message-ID: <20250527162459.974447262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 91d6a99acfa5ce9f95ede775074b80f7193bd717 ]

Memset the config argument to get_mbus_config V4L2 sub-device pad
operation to zero before calling the operation. This ensures the callers
don't need to bother with it nor the implementations need to set all
fields that may not be relevant to them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 2 ++
 include/media/v4l2-subdev.h           | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 3a4ba08810d24..1193852bad599 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -439,6 +439,8 @@ static int call_enum_dv_timings(struct v4l2_subdev *sd,
 static int call_get_mbus_config(struct v4l2_subdev *sd, unsigned int pad,
 				struct v4l2_mbus_config *config)
 {
+	memset(config, 0, sizeof(*config));
+
 	return check_pad(sd, pad) ? :
 	       sd->ops->pad->get_mbus_config(sd, pad, config);
 }
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 8daa0929865cf..43343f1586d13 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -821,7 +821,9 @@ struct v4l2_subdev_state {
  *		     possible configuration from the remote end, likely calling
  *		     this operation as close as possible to stream on time. The
  *		     operation shall fail if the pad index it has been called on
- *		     is not valid or in case of unrecoverable failures.
+ *		     is not valid or in case of unrecoverable failures. The
+ *		     config argument has been memset to 0 just before calling
+ *		     the op.
  *
  * @set_routing: Enable or disable data connection routes described in the
  *		 subdevice routing table. Subdevs that implement this operation
-- 
2.39.5



