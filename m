Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8611F58496F;
	Wed,  9 Sep 2026 14:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964305; cv=none; b=TV9RRfqJnUwcz4r4L9f+0ln4cWVVwenE35PRgqVHrxODSK7BuvfnlO+hIS+c65y0auLNP/j9nZRGOi/SKVBAq3yfHdwVB8dMTBRR30QDE5FJjMSC8zOK7FHT8eTW6M+srzpmsOMEpehjU0yUn1zAjWcnDyIYLkW9vSDlNr9brRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964305; c=relaxed/simple;
	bh=WVQvSblL/F4LvFe0+ch3g99cDp0SY67LsFBelx740TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5KbLMzYuHDPb2AgL2eBzXdUqIzi8+qCo7YNg7divVT9kuHdClbpx/vm3VXd+fFDEKz0Gjh4ul2jq9zNct+wo2HsF8rw+FFN0cXmD60iT9x2b/64sa7oUEUhacfzaDsaqKbztIZs6OljJ3rbEIbSUHsWmJr6oA51h3GqWrz0nqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzL3mNJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzL3mNJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD0A1F00A3D;
	Wed,  9 Sep 2026 14:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964304;
	bh=5Rpf6qUQjAUbOk13asIiZbKen3Xt3G6xoah9UfhUWPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzL3mNJHuDlyPTfjwrhgUWg5P3GNwMo6IkL7TgnGML55Dak9f5gCbHKD3ZwX4erl4
	 KlcRxx8B+GTcGbStSFMItv9iYaNSneP1nRCdKmxrJnCoQqrezVsZfKNjgs7ZkVeAy+
	 JCG8LtawADF7an1rycirKCZ9rWEz1RD5qqjAXZZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Barzilai <amit.barzilai22@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.18 377/583] drm/ssd130x: fix column and row end address in partial updates for ssd132x
Date: Wed,  9 Sep 2026 15:41:02 +0200
Message-ID: <20260909134251.085789404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Amit Barzilai <amit.barzilai22@gmail.com>

commit 99e9c09358195454ecd200b9c6aba6b7d209fad4 upstream.

On partial screen updates, SSD132X controllers expect to get the
rectangle addresses as arguments of the "Set Column Address" and "Set
Row Address" commands. Each command expects the start address and end
address of the row/column in absolute format, however the end
addresses were being sent in a relative format (relative to the start
address).

The relative end addresses work only when the start address is 0. In
those situations, there is no value difference between relative and
absolute addresses.

Fixes: fdd591e00a9c9 ("drm/ssd130x: Add support for the SSD132x OLED controller family")
Cc: stable@vger.kernel.org
Signed-off-by: Amit Barzilai <amit.barzilai22@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260622122604.32500-2-amit.barzilai22@gmail.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/solomon/ssd130x.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -863,12 +863,13 @@ static int ssd132x_update_rect(struct ss
 	 */
 
 	/* Set column start and end */
-	ret = ssd130x_write_cmd(ssd130x, 3, SSD132X_SET_COL_RANGE, x / segment_width, columns - 1);
+	ret = ssd130x_write_cmd(ssd130x, 3, SSD132X_SET_COL_RANGE, x / segment_width,
+				x / segment_width + columns - 1);
 	if (ret < 0)
 		return ret;
 
 	/* Set row start and end */
-	ret = ssd130x_write_cmd(ssd130x, 3, SSD132X_SET_ROW_RANGE, y, rows - 1);
+	ret = ssd130x_write_cmd(ssd130x, 3, SSD132X_SET_ROW_RANGE, y, y + rows - 1);
 	if (ret < 0)
 		return ret;
 


