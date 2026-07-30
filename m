Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED8C37CD59;
	Thu, 30 Jul 2026 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426196; cv=none; b=DOa87Qdw0BXpUMRiOBaIVof8v8daly/GHs6E+/U9uTQLMCy0JzHod7HgL8elwMXntuSmtxQNpxPkbruhKl/WwNB2vMZrizI02B2LAmXV7SmwIlvTPqnCZwynW2yj6CqX3hmBpq+wQl++aA3NtgmqWS1WmfQWEUEJzFNpSOl7R8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426196; c=relaxed/simple;
	bh=i0j2L4CvzlALDz0od8U3/S44Y/+MDrYkKu4Jnp1sZwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0DwigawPhp+/7b03k5DPkZyrkrwm/3W5kZ/fElwM880v2qnrWPb4cPlsYn5gwq9P6UeKGaKMtohnQAFWcpBf6qihwkD+VoNGvljAJLOPr4iNBYPku6m187wE3jNds2JbX5QbYTusACvr0bDJZX7aq6H7DyKByBDyeG7op7Vvnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbjGQrVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbjGQrVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E2E1F000E9;
	Thu, 30 Jul 2026 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426195;
	bh=sn/O5ee0KEreOrjnmg8jRlWVg63vBAsDIO9BsJyaeo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbjGQrVxg0mH3a4NHzZ4J5YRnljCLcEkErp1SNKIxX6yb1cQmtH6DYC45x5JSlFNF
	 AC35M6vaMpqaAUrn5zJdjVnuNR7rMvdLh/sxETE5GRrNZqo6phJuBeCRjDPPuuZRdT
	 mleoqLIwe7xeN2Imjrx1WU1gJ0dfUdUq3c9LpbYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 6.12 335/602] media: v4l2-subdev: Fail {enable,disable}_streams and s_streaming nicely
Date: Thu, 30 Jul 2026 16:12:07 +0200
Message-ID: <20260730141443.002185790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 0bcbfd1c1142d85faef8df5cb679d37f71394c5f upstream.

If a sub-device does not set enable_streams() and disable_streams() pad
ops while it sets the s_stream() video op to
v4l2_subdev_s_stream_helper(), enabling or disabling streaming either way
on the sub-device will result calling v4l2_subdev_s_stream_helper() and
v4l2_subdev_{enable,disable}_streams() recursively, exhausting the stack.
Return -ENOIOCTLCMD in this case to handle the situation gracefully.

Fixes: b62949ddaa52 ("media: subdev: Support single-stream case in v4l2_subdev_enable/disable_streams()")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -2438,6 +2438,10 @@ int v4l2_subdev_s_stream_helper(struct v
 	u64 source_mask = 0;
 	int pad_index = -1;
 
+	if (WARN_ON(!v4l2_subdev_has_op(sd, pad, enable_streams) ||
+		    !v4l2_subdev_has_op(sd, pad, disable_streams)))
+		return -ENOIOCTLCMD;
+
 	/*
 	 * Find the source pad. This helper is meant for subdevs that have a
 	 * single source pad, so failures shouldn't happen, but catch them


