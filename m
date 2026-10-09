Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C8B4E66DA;
	Fri,  9 Oct 2026 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557002; cv=none; b=SCvgN42CK5sChKWFYenYnk5GueSj5wvx2khOtBznH6aPsstvaXLCcGnqCuAl1w3onwF6WfIOQO648yycyfC+QwnbfTVNE8w2PYdxvW1E6JmGOd4kz+qe2BPdJ/iPeVnLu6Zye3u9j8jPtf7GOw08EkMt2PmpTNoJ+fdfLTEpksA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557002; c=relaxed/simple;
	bh=wiX3quGhwcRlhYoKVo+yuI1ZKRUZuCbWOKYVXyarmhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBoDwMJllDSXXUoGu560OmvOZejDRSJdeNzqwGiltnkeqjXM7KuQNDGpZgMsRCgcYSB/u692uf6Cw5l5eq4o/+QAL/GkjIPN86V6cEY+6L3tFpR9Q7w+f53l6o1xS05EkqcwJ69wOQR3lKGzvzgh0qoNz4gvKuj4D9pVtUnn0Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gynq/36Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gynq/36Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ABE1F00893;
	Fri,  9 Oct 2026 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556998;
	bh=V3ApyO7vsrakIy6m+QT1e4xBKbE8HRNKMhWH9jBEzNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gynq/36Zz5Gn7CV8AnZTKj3zsIWajZhCtmfD7k7Hbub4yI+pSuDM0o3b8BrDi2KqX
	 cEakiI67D1pQm7fAM6ugYjvX1lepjkWwpaHuxNFu4aH618MZiW12LgGomtcSTRsB9d
	 81qIOPs3O+mm8mtKehgAR7R6NG8BulMxePY8aruE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 330/403] iio: pressure: bmp280: fix out-of-bounds access in sampling frequency lookup
Date: Fri,  9 Oct 2026 16:11:31 +0200
Message-ID: <20261009140959.954173999@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -836,7 +836,7 @@ static int bmp280_write_sampling_frequen
 					   int val, int val2)
 {
 	const int (*avail)[2] = data->chip_info->sampling_freq_avail;
-	const int n = data->chip_info->num_sampling_freq_avail;
+	const int n = data->chip_info->num_sampling_freq_avail / 2;
 	int ret, prev;
 	int i;
 


