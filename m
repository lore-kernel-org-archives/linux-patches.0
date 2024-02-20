Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1CF151CC3;
	Tue, 20 Feb 2024 21:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463015; cv=none; b=P2SO7tVfKkz6tck1aksLWRVN4X3GC/e9NFLWn0lFlzef0dJfeGtxtxrOuvmlAzieKAevGuA3pVRB5f9dxEwQJfs7Gy/mfemdPX03uO2dHkaOHE4t0ltqeeNV4KEWo9qa4qRcGZ4/NKJqI8O3IfoRfi6o+4vxPYm2XySB2tuZNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463015; c=relaxed/simple;
	bh=ot3qonQTdBqiucTYYEgHISSl4PtnJd3ql7rXAyOBxDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrJGkLX7g16jszXSk9AsCDJbQ6UgiUSQXn+gRWZHdm9S0uXNPv0OdosFR+c6xxKi1F/QvoOXXBhTjNy/nK9QLNSUxg0V5iNFVZ4kwvU2HO6XoApoLsK+WZAXdUcee4NTgLRe8pJsK7dhLrUG1WgTIJET4m+t52sMuDMYnM8qfvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcyUVc/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcyUVc/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C891C433F1;
	Tue, 20 Feb 2024 21:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463015;
	bh=ot3qonQTdBqiucTYYEgHISSl4PtnJd3ql7rXAyOBxDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcyUVc/PURzNkHVLiwP4MmD7Khraga4v+kN7WOufUf26c4AzLnoDkKN5yyiuaqJ7k
	 /2UHs9DNgF6RPGwv9kBlhjiJVfYeRcmQSKN8XCPziNDINefUY4ztWDjfOpdOdJkgKR
	 Akv0H0EySyTQ+8cdVXwKByEu93pgLxKX262e0KU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Schiller <david.schiller@jku.at>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 101/197] staging: iio: ad5933: fix type mismatch regression
Date: Tue, 20 Feb 2024 21:51:00 +0100
Message-ID: <20240220204844.106861968@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Schiller <david.schiller@jku.at>

commit 6db053cd949fcd6254cea9f2cd5d39f7bd64379c upstream.

Commit 4c3577db3e4f ("Staging: iio: impedance-analyzer: Fix sparse
warning") fixed a compiler warning, but introduced a bug that resulted
in one of the two 16 bit IIO channels always being zero (when both are
enabled).

This is because int is 32 bits wide on most architectures and in the
case of a little-endian machine the two most significant bytes would
occupy the buffer for the second channel as 'val' is being passed as a
void pointer to 'iio_push_to_buffers()'.

Fix by defining 'val' as u16. Tested working on ARM64.

Fixes: 4c3577db3e4f ("Staging: iio: impedance-analyzer: Fix sparse warning")
Signed-off-by: David Schiller <david.schiller@jku.at>
Link: https://lore.kernel.org/r/20240122134916.2137957-1-david.schiller@jku.at
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/impedance-analyzer/ad5933.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -608,7 +608,7 @@ static void ad5933_work(struct work_stru
 		struct ad5933_state, work.work);
 	struct iio_dev *indio_dev = i2c_get_clientdata(st->client);
 	__be16 buf[2];
-	int val[2];
+	u16 val[2];
 	unsigned char status;
 	int ret;
 


