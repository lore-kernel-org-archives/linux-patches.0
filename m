Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2B034EEFD;
	Fri,  9 Oct 2026 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557576; cv=none; b=TRZSJxX+y26goJuIU+7wFoZU6Q9T8RSY0jY+NSFvyFUGNPskjnnQ7qJd93dSi4n1KL3+DNyjeUPCWzBEoB22vENX84KSUJxHuaJSNY+kI6j6JIKpW8yAWSkmlGL3j2jq261eO0E+46I/Bt1WGQVQx8Yt6+r6msawP+TVDJ6w2yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557576; c=relaxed/simple;
	bh=DugDs2P4087ulp9LauxKY/wFP/pKRSRNqaOagY8ROEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlQNrXjdFJxIV3yehXjBapE+2GB7IGRvIzmstUkkdCKkk1weLKEe1hJ6EuG08nP2wyYPT4bXbeQMNxvqEjFk423thi1en2QBwi0F7f/aMcAOObML5JAlMIkUkW2PGEuzzf/anz2VS98TKTMRlREqjS+EXFzDTAQvOBw6xZKFArM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtXB+4kn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtXB+4kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EAD1F000FF;
	Fri,  9 Oct 2026 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557575;
	bh=6H8WZokkadBwMVCseWh520TPVEFQlGsargVpurahd6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtXB+4knvlGas5+NwRY1+UinGqNy2LoImg+awV6m9cpRQnVxwYAnwhr4gWDnhhLxq
	 RkZuN8m/XhFuz4D8fH8rs5CnCRj1+DtCrYnKUEN0sbeh+qE9AE3rnY1wth4CKhMeJz
	 jWQQem/Hgo+TkNX5f+V/6Bf+oLpsmK2MVW52wWp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 409/428] iio: proximity: isl29501: Fix return type of isl29501_register_write
Date: Fri,  9 Oct 2026 16:12:26 +0200
Message-ID: <20261009140955.210623819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit e8dd273d199f5bbe295a8e3d8b777c5505b6b2e1 upstream.

isl29501_register_write() was returning a u32 instead of an int.
Since the function returns negative error codes (such as -ERANGE or
return values from i2c_smbus_write_byte_data()), returning an unsigned
integer type prevents callers from correctly checking for negative error
conditions.

Fix this by changing the function return type from u32 to int.

This was found through manual code review.

Fixes: 1c28799257bc ("iio: light: isl29501: Add support for the ISL29501 ToF sensor.")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/isl29501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/isl29501.c
+++ b/drivers/iio/proximity/isl29501.c
@@ -226,7 +226,7 @@ err:
 	return ret;
 }
 
-static u32 isl29501_register_write(struct isl29501_private *isl29501,
+static int isl29501_register_write(struct isl29501_private *isl29501,
 				   enum isl29501_register_name name,
 				   u32 value)
 {


