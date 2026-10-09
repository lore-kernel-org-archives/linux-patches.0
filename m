Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDCC4EA374;
	Fri,  9 Oct 2026 14:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557082; cv=none; b=nxKkc7i0g8yOvFadYh6BpKPv3uauQu6zG498vFAmRXOuDszr4NLbJGJMC1qSRD/Vg1Sfl4THPsjdwCwcyum7KEHjc3yjsFp0G5P0m9HBQ0o2q28ewinhZI/YG5187rw2G5V3FtA+Aj7Co/GDBnEQq3MBYdew0bifKhQtRuCXn/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557082; c=relaxed/simple;
	bh=fvnQJRptTsrmcBK0poKbJOlBjr2m+81PdoUnr/+2TL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOsP61sGV8nj5FOGWM9N8ZHE686weP4Q4RatNQy+xFoXjjZYtn3hZelQOU2GD1UADhQ6ebrkxEymd5gRzzJF2aT2MNwlYHmjZP3LeybFVEIDqSblihcbLsWNNEngvesON36uOb4yeH/pvRy5unA7IQ7aQM6ekgB1s/9BEDud+xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+XI0kx0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+XI0kx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5831F00893;
	Fri,  9 Oct 2026 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557081;
	bh=CjRbIoIF8jauxEpzxSeGeGksPDVETxjtqBa3ZUmT4Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+XI0kx0mriQHzbX/LmfKYcwjB5N1BKReKOE7qb7jPjt63euSfGGfqoYFAIm15jc8
	 vCxktgUAmJsNr//wPn3Ha6H9jXjOZhvoJoK5kg0b1oUaLNEzWMJGNsJh0PvVCccyF8
	 NFMPvY6n869IiGNhVnV4YvWc0KQkc5QyTozkTe1w=
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
Subject: [PATCH 6.18 321/403] iio: buffer: Ensure bounce buffer used for unaligned case is zeroed.
Date: Fri,  9 Oct 2026 16:11:22 +0200
Message-ID: <20261009140959.734029671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2438,7 +2438,8 @@ int iio_push_to_buffers_with_ts_unaligne
 
 		bb = devm_krealloc(&indio_dev->dev,
 				   iio_dev_opaque->bounce_buffer,
-				   indio_dev->scan_bytes, GFP_KERNEL);
+				   indio_dev->scan_bytes,
+				   GFP_KERNEL | __GFP_ZERO);
 		if (!bb)
 			return -ENOMEM;
 		iio_dev_opaque->bounce_buffer = bb;


