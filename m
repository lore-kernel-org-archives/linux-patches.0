Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C93281ACD;
	Fri,  9 Oct 2026 14:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557647; cv=none; b=OstnRBI+MGaI5VIX0VSWRvzSjywcHmzf3GKy40TqZ4DHiohG223UedEYIUULHOiMQxvHqOgMer193McjYfHiL66SOrrn1D7FtAnvKHVMt+url0wQfn2ZhZ9YsoUSniI7lAV6r1L9lWF9Yk/ZTo7MjFKt+JwVvOsTls9vghLhV4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557647; c=relaxed/simple;
	bh=BFXOXicl3sSDVD9ACsxRLkWEK51eihYU5fFQYZAMiss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2xweiAAqOfvcg4wTKRY3vxrRnOH9zyev/1D5+eFUp4oDBIF+kdyUhycjQts6DZ0Go2Ijb0evWIjf+8459IcckEkueYYzFloZ5XBOTwPBYl0SyZ7nawCEf/D20c9zTr1JNPCPf/H1n4AAW26Pj1ZL4Y0KpwwwSRYYLDPKO1d0EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTbupRCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTbupRCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8368E1F000FF;
	Fri,  9 Oct 2026 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557646;
	bh=lKIA+q2r19GtZCOAaT2fh7g1WC4EPSiRoYPJOoDKqdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTbupRCGV5tbNq0TjRwCeaxvWDexuqxa8zW/gDpN7fG+cHo7OQZQx0suKqSQBYivF
	 P2K1mmPj6WyJWnaELjEzQrbNcVEJcsic3YjVZWzchO9w2Zq2cFlxUAifx7wRu9R8bh
	 r2QaBrcTh3M47tA0rvdiFHPU6PlvBceLAXuZveto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 396/428] iio: buffer: Ensure bounce buffer used for unaligned case is zeroed.
Date: Fri,  9 Oct 2026 16:12:13 +0200
Message-ID: <20261009140954.909033431@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

commit 5330036bc68d23672bfcc16c60c54701ae123083 upstream.

iio_push_to_buffers_with_ts_unaligned() leaks uninitialized heap memory
to userspace if the data passed in is not a multiple of 8 bytes and the
timestamp is enabled. Specify __GFP_ZERO for the devm_krealloc()
to ensure any extra space is cleared.

Fixes: 95ec3fdf2b79 ("iio: core: Introduce iio_push_to_buffers_with_ts_unaligned()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260529121005.1470-1-kimjinseob88%40gmail.com
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -2466,7 +2466,8 @@ int iio_push_to_buffers_with_ts_unaligne
 
 		bb = devm_krealloc(&indio_dev->dev,
 				   iio_dev_opaque->bounce_buffer,
-				   indio_dev->scan_bytes, GFP_KERNEL);
+				   indio_dev->scan_bytes,
+				   GFP_KERNEL | __GFP_ZERO);
 		if (!bb)
 			return -ENOMEM;
 		iio_dev_opaque->bounce_buffer = bb;


