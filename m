Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EA44F68A6;
	Thu, 17 Sep 2026 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666637; cv=none; b=BaYj9bY8ofs2vl+Y3fT+A6mNbNm1EOQ/D6GGJ8zlgLyoHjnGWP39IIHfaRX53RuGBjpZHaASgBZUsqlx3QDvyvse5x1QVvi/B7ZKK4BPb5HpkKjh4QY3EompnKM+ut/WL3JdZXblKvme5xDxXDWBqlOPVeZc8fapYxogmNMzJ58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666637; c=relaxed/simple;
	bh=/ePPS9f0DH7EmT4ZosZLhX757MnI2MGJVVm2/e63Vhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLKvViE/soU7WPPGkCwEbzqSOiUzQTBf8fWR9ezdX/FUvBRMEZyi3CdkhWu6qpDgr8dEmKab6/56cdwFMwU4MemILEQWmCg9ZiaDJ9ZwzOyAy5/Eo0xMRkTCFy8kFXcyWqGU/EaGXgIS0Sfk0Ws3W1r/MwCV854lCDpzuc9KLhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9xjz9cp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9xjz9cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC26D1F000FF;
	Thu, 17 Sep 2026 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666636;
	bh=mroYuxdRmH9RJX4Co7RKqoxwn/pKf1ypXey0khp8+C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9xjz9cpRRea+ygqIfcxmXlS4Ik1Y7uLA0rLthTfJVthUlEmSLSVvXXDr5vBs0/Eb
	 KGIhsZ7j82URYnugaYSLxbZ1H3/PtaYm2Je2iroqXrSw6QoEZKe8etQtTY5Cdix6ZE
	 3MCHJV+F2ogT4AoeZRKni6K1RPFtrAl/4jVIl6B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 1066/1250] media: v4l2-ctrls: validate HEVC tile counts
Date: Thu, 17 Sep 2026 16:14:21 +0100
Message-ID: <20260917151621.022009706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1154,6 +1154,18 @@ static int std_validate_compound(const s
 
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


