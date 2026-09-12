Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7423F788A;
	Sat, 12 Sep 2026 11:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214126; cv=none; b=Z4XMp4ON1JOQ+KMfML2B1PHcZFIzGakz0reH8zzYB8CXnxI+qChIL6F98Xzob4AVOZZV0dZoPcpD9l6h6cJj+OLPAt/UN1KdqO4cCGegZbFJUx86TTUf0O8sUe5R23WDbmOmjh0aJ+MfAsFXi5SBCBM/6NdGFCiKOJcoUZzbQJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214126; c=relaxed/simple;
	bh=6M/j3j/ryD1KNcecUUpDeopVekg2LqivgJNlImbUuU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaWGWnR2PN0IyfdtgC1MUAdGitYvjMHIscBE6O1f33f5A4w/CDeDWhWXGCawVKZU7nSu7xKPhZuB0o/zMBeG4Q8G0B8Tiylx7r4WHza8T5up4mq/LW1Y/qu1jxuL3REy7iT9Gscbv6OcH1CYtNqPidotoNnJFfKmiMX6nMzERvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaqEjofg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaqEjofg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AC61F000FF;
	Sat, 12 Sep 2026 11:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214125;
	bh=5NmZKZYuescfHh9eZUCW2YN3QP66u5NA7eqLMJi0HE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaqEjofgMc3KQosQEmtaeeaVSeKIdpEhyuE+PnNhCTZQ8jVNc2RjfWxNrNObiPQZr
	 BBfgJAmEcIC8blTpDTXZkpU9w4EAEGjBDUPXOm7snjec1uSTFKFJhlsJJWDWavC+Is
	 TXxBzxx83TPim+9yLZeyLVaDBfnhfTPlaBiY9Pq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Barzilai <amit.barzilai22@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.12 0263/1376] drm/ssd130x: fix column and row end address in partial updates for ssd132x
Date: Sat, 12 Sep 2026 08:44:49 +0200
Message-ID: <20260912065613.402339030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
 


