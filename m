Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208F94F3921;
	Thu, 17 Sep 2026 15:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660471; cv=none; b=d5xa5oFRoNC1JICpXLk722+qQWslscPrHUJtMi9CKIV9UOgwqJBb4tQ4be2SQBxdgqh5Ew3q6Pgq6aRfX+Ny/rC70OsrGjIfWo4sW+k6hzH/YCLdKjvl3w5JkTMbC3ynSQzD6ygVj6l51BP/89zZrqRfrkrg3Ch7K0ccvBImUwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660471; c=relaxed/simple;
	bh=k0VVkk3eTj657L4b+BFVI2R+rqjwiLPJ5xDZZVvs81M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPJV2EEhu/p9gYFBrisKHVCwAoKPBR2kDePr8owvnB+WMgptDJKi7Bffy9EGPsIzQX2jIgrOMl8BH+VZe3FiX6+wjhJHzSWVRzsufmSAQWY5E8W5GCPAb1D2hQRkRUwgyZ3igJG/YLETv0DpzQMNdPRjtYGJhCvUzJO/VXiWF4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Rp3qvpO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Rp3qvpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DB91F000FF;
	Thu, 17 Sep 2026 15:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660470;
	bh=SUE+rKKyj/Ukhv5ulRO6InYkuVGpcQj72G6xlinEGI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Rp3qvpOW4xvmhRbiT8OF88UrmkdXkAxzeino2bb/7IDIzQpRyj2Hjb/uAsszWPES
	 ax7B4uy04sD+aZjujdUVYYIG8rZHt0S/pLA1cDnA5anVzjqieUa04Lc0zOYHkeK3DG
	 Qfmi2bCWMGXtWCYEzC26LIkDZNY2ZPy9tgQ9mrIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 603/733] media: v4l2-ctrls: validate HEVC tile counts
Date: Thu, 17 Sep 2026 16:15:11 +0100
Message-ID: <20260917151407.500716709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit dc694a9929f7cb9c88ef91e45eb982b7bbe5a477 upstream.

The stateless HEVC decoders read num_tile_columns_minus1 + 1 entries from
column_width_minus1[] and num_tile_rows_minus1 + 1 from row_height_minus1[]
and use them as tile-loop bounds, but std_validate_compound() does not
bound these u8 counts. Reject a V4L2_CTRL_TYPE_HEVC_PPS with tiling
enabled whose tile counts exceed the uAPI array capacity, mirroring the
existing compound-control range checks.

Fixes: 256fa3920874 ("media: v4l: Add definitions for HEVC stateless decoding")
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -1253,6 +1253,18 @@ static int std_validate_compound(const s
 
 			p_hevc_pps->flags &=
 				~V4L2_HEVC_PPS_FLAG_LOOP_FILTER_ACROSS_TILES_ENABLED;
+		} else {
+			/*
+			 * These count the entries the stateless HEVC drivers
+			 * read from column_width_minus1[] / row_height_minus1[]
+			 * and use as tile-loop bounds.
+			 */
+			if (p_hevc_pps->num_tile_columns_minus1 >=
+			    ARRAY_SIZE(p_hevc_pps->column_width_minus1))
+				return -EINVAL;
+			if (p_hevc_pps->num_tile_rows_minus1 >=
+			    ARRAY_SIZE(p_hevc_pps->row_height_minus1))
+				return -EINVAL;
 		}
 
 		if (p_hevc_pps->flags &


