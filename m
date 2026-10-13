Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B774EBAEC;
	Tue, 13 Oct 2026 12:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895357; cv=none; b=JktS6lmmVOtMsg22R+mqrtlFol1C/Io31mpLDxjjedVhpGUiLRRsliBq7gjf+QDU3IcHwmhNrCwUvXzCRK6F0nExR61uM//bvkC9BYxT/SzOny3gLDlbbEmJwA5rjY1uRQMEIkrLQ9mLP7tQWhK6FqvpfCwWqvGpQFwo+YCcSQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895357; c=relaxed/simple;
	bh=T8MexAh+sQ6S3R8zIGW55CCn9OwRDfPbGrn/yE5DUNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnWhwjjF99M57ZblyOpEPhrbRnAREuzbUQljYPwfizbm/ZcmfCd3QHU1d0eYUqWEjIwQzCuECyf14r9587G8R0cxPP5kuphe3TorrO0DZfj4dDuDkQR0xnpvMpi+YIDUpQx8sKepcTJv67n8LoXkaNhW5/LIABPDo9CHstLu/zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rATDAVLs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rATDAVLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4256C1F000FF;
	Tue, 13 Oct 2026 12:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895355;
	bh=eH4wWorEBSsw9PjcTyRkxIL9Gnaugrp9inLrqIoWvqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rATDAVLskXW3Ae6qgc3Rn1+8/0yajisVHnfJ0+UBANoNUfuC0hCLjq7jahspLboR5
	 i4gcO1h37Edi30Gvf9PCtsVpFwU8i4J4ZdEYWPG9x1F232b4ww5I3nVdpAPxv5+s46
	 i0DIcPvib8mjg6neRAByUirNRbP2b8rfyKif8zcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 247/497] iio: pressure: bmp280: fix out-of-bounds access in sampling frequency lookup
Date: Tue, 13 Oct 2026 13:36:54 +0200
Message-ID: <20261013112913.757301538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

commit 56c423b233b214182c58c99861899327b45b0d6c upstream.

The sampling frequency tables store each frequency as an integer part and
a fractional part in micro units. num_sampling_freq_avail is initialized
to the number of flattened integer elements because read_avail() returns
the table as a flat array.

bmp280_write_sampling_frequency(), however, indexes the same table as a
two-dimensional array and uses num_sampling_freq_avail as the number of
rows. Convert the flattened element count back to the number of rows
before iterating over the table.

Fixes: 10b40ffba2f9 ("iio: pressure: bmp280: Add more tunable config parameters for BMP380")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -831,7 +831,7 @@ static int bmp280_write_sampling_frequen
 					   int val, int val2)
 {
 	const int (*avail)[2] = data->chip_info->sampling_freq_avail;
-	const int n = data->chip_info->num_sampling_freq_avail;
+	const int n = data->chip_info->num_sampling_freq_avail / 2;
 	int ret, prev;
 	int i;
 


