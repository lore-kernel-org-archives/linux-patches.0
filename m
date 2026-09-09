Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5A457981D;
	Wed,  9 Sep 2026 14:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963097; cv=none; b=QruTdRK1bhSthnGk91BMeNEfV6JwOUo0JX1DqUdpHr5f145NOtf/prfOz8L5t5mIXZfIRmtdZwV2/dGV4GAPML555T7pxPkTb7MI6mEdmHSSFBsPPmugcA3bwHHARDEAE7zVNIgKMxwP6W7MrQGzV2JWA+BDtPv03bThYgcjOPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963097; c=relaxed/simple;
	bh=c3w/3sldhL4zaOa4F8VV7UkKzKWwG+ypK94V5J3LiOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idyRrEQaYveg3TEKOOADEBLQgOnlK00d44eQWisUyB5hP1J9lJnWL0+8Et6/ngzZaYANF9P69NT5liQEBZEQ44JoHJqhmaTzlhNY7L3nO+BEp7Q1G6yhN8kz+UoOKIyqH2NQhL7OVybi5k9wggjz042ITmyYfiSnKQkZ9MfnLyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0C1HmRf0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0C1HmRf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC0F1F00A3A;
	Wed,  9 Sep 2026 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963095;
	bh=FqhbWYvdK1Jkgti9SyyFpiQhdfoPdDkKetkxapF9tL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0C1HmRf0gK9+1fNzwxysfUwAJyLv9V/RABYxdwGkd217Zo17tlcY0tF8z8zAijmdG
	 GHrZB19OtYvBXlhY/C4EAwbSWVkgtgyz7MPZ4qfSLYDbKeCAIRR6RRKrW3O3ZxD/da
	 8cCqYhD1kUShak6Oa6UH/nlP/G8TszZOYf92Bmds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Barzilai <amit.barzilai22@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 7.2 482/556] drm/ssd130x: fix column and row end address in partial updates for ssd132x
Date: Wed,  9 Sep 2026 15:42:42 +0200
Message-ID: <20260909134247.479482306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -864,12 +864,13 @@ static int ssd132x_update_rect(struct ss
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
 


