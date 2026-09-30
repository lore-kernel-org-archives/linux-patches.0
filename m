Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC07B3B3BE1;
	Wed, 30 Sep 2026 18:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791728; cv=none; b=fFwH5JiAiiXmcJP503g0uYHtGjZZDLJ1lZP+WxnuPgcli4/dxWqW4qtw7iZul++2dX1dQiIG68aTBBveEBd/q+urCwUkYejhFDR9bYAnlFXpKVip+DZ1D6YA7tPJ+Hf2xZzAfDDkzt2vO6/TH23MQBbmX92xWww7MCkAQw7QA/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791728; c=relaxed/simple;
	bh=mRgPJUJNrALCh4je/w5MUDfsr/1ZpQwJpFgTaKiUURY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/sf3ylWkSTRs/it17nWLb2RmoUmVc7tmX87DxrGOGwWBF/OTTnX1a73/MVQfeTbgOrQUDoZunhUfalfiah/8yH1B4pECzdxXlXJYhvassevSpgUulHd7D8B9UptCGlSdA3VKj9vth7KAo+j6g/LaaL9DrBF6wM8miB2623hT9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peSMOf/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peSMOf/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B061F000FF;
	Wed, 30 Sep 2026 18:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791726;
	bh=S0YO3vvh3zzUheZ6OGeu6y987kbfMRP8sC+/gxB3/V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=peSMOf/OOgJ6m1AhCx453hczX1lKuRKcPTpvkKvQ+sj/O4wch7VqXCoMEOTq3piDt
	 s3fDtPB2yIiC+1TvdB1hQk7uxMNEYzs7rO0aAm6645/bBJfwtEkTxIH90VzxMmBNj4
	 aDeZRfoAEpwC403lrg9nxxEgCJmZVVLiRNlDjcsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 403/752] media: v4l2-ctrls: validate HEVC tile counts
Date: Wed, 30 Sep 2026 17:24:33 +0200
Message-ID: <20260930152407.002642770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -616,6 +616,18 @@ static int std_validate_compound(const s
 
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


