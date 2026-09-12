Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC38343893;
	Sat, 12 Sep 2026 11:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214136; cv=none; b=b71/HEnIVLZrOSSIpM7ipjNHLpugN2/tXm7rDU3XPBTrUbGNOO/ugkkVg5kz7j/iUkMZtXa+bm0+WVOld9ANZf18MrMoXPRyPxv4+IVHyYdiFIDeahWc9W4hBqFqATi+EFLsRgiw3VghyN1VarfwxGxgZkFqSGwZrNAM8he1ZNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214136; c=relaxed/simple;
	bh=6dKPV0io/D7PZ+EEAC8PHaxCXE05+y7Wu345QOwelUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0YJPerqAHdlyCw6KqEIHWfM4TyaQo8aes2X94/H5PbUj//LeaCDUKvGY/klE8IxDmbPwxnQ1o5XSGUgB6bFuPPtnrSKnLUS7ohR//EMc84B+07idJOKTin/TSyt75tufKib0nxRexUlFIYtZ/zvuXkZ2gA6snUJlf7Majpztl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7c775qs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7c775qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C8C1F000FF;
	Sat, 12 Sep 2026 11:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214134;
	bh=OT8mPtXIlYdaEE2QaKd3pAwel9Krwplgyo9+uXEn2R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7c775qs13nCn15DuoAZ/c42jWmFUIWLnfn+zOHOkI/q7MAF05Jj1TdlU6GBZLF5F
	 49PtTfPht761EbG6x/SCK6tKbiELvutAzaiSsilzIbHw/u1zauRv119j3TnaTlSdQ0
	 f4I3/IyqywF+obF0ZXI0qtKj5hm3bTNnV8F4ZGOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Barzilai <amit.barzilai22@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.12 0265/1376] drm/ssd130x: fix column and row end address in partial updates in ssd133x
Date: Sat, 12 Sep 2026 08:44:51 +0200
Message-ID: <20260912065613.447176671@linuxfoundation.org>
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

commit b7fcb70162acd7f15ed20bc64a14c150db34256f upstream.

On partial screen updates, SSD133X controllers expect to get the
rectangle addresses as arguments of the "Set Column Address" and "Set
Row Address" commands. Each command expects the start address and end
address of the row/column in absolute format, however the end
addresses were being sent in a relative format (relative to the start
address).

The relative end addresses work only when the start address is 0. In
those situations, there is no value difference between relative and
absolute addresses.

Fixes: b4299c936d8fd ("drm/ssd130x: Add support for the SSD133x OLED controller family")
Cc: stable@vger.kernel.org
Signed-off-by: Amit Barzilai <amit.barzilai22@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260622122604.32500-4-amit.barzilai22@gmail.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/solomon/ssd130x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -915,12 +915,12 @@ static int ssd133x_update_rect(struct ss
 	 */
 
 	/* Set column start and end */
-	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_COL_RANGE, x, columns - 1);
+	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_COL_RANGE, x, x + columns - 1);
 	if (ret < 0)
 		return ret;
 
 	/* Set row start and end */
-	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_ROW_RANGE, y, rows - 1);
+	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_ROW_RANGE, y, y + rows - 1);
 	if (ret < 0)
 		return ret;
 


