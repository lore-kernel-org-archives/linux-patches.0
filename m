Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454D3255E43;
	Sat, 17 Oct 2026 17:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256911; cv=none; b=IdjGApL+mnOpgaJzBrnpbyi4eblblwnFhI8RsJqEfWUp9H2Gn8JGbXQm/Ri4KK9JD9v8kWx5OWi9xEcvo0Epf6zxHxH4DKw1c2rLkKeKv8osdQ9r11ypTwhpJ0Xy1jdM4iMMXHXo0E8Ic9FD7c4r9KXyuO4zYMlmuGAhSKrTEBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256911; c=relaxed/simple;
	bh=uTGVs8tcdKnMGNEf6XrVLh5kq4A3PfJdx1z5ETqe/rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZYbM9mcuEWpb6vlLjB0EL68G+xDm4DEEEAhiXeRDzZPpFNPLt0W9a4zpnnMScpdHozUsHZG+BcQa64bFYYJRpewMmYqx+G3mP31GA7m0UgXvuulz17FqVcQCeI5AnWkb7SkJ3PwRc8H49vdj1MqG1E7AqWRMR7zZgKF2dAB53U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uf1YglW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uf1YglW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902A91F000C4;
	Sat, 17 Oct 2026 17:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256910;
	bh=6CXaNaSc9JSXM5NGaz9p0Ieoe0iZGio6fWOqWkpjL5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uf1YglW1ugrfLCQ6deeEoOYEsOmWBT/4F9Ad2Tdc6ZvLq/Mov1KcWkIhwdqSZF5ab
	 JC2VhSKKeNJHOvjYB8jdywI4x/3yAX6AzrKwEaWJuFDxpSPnObIu42+RAcfm/tBxWJ
	 k11KxHemmPieFdYwiYq43zThCsIXWc9yoOjwDqQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0348/1674] iio: pressure: bmp280: fix out-of-bounds access in sampling frequency lookup
Date: Sat, 17 Oct 2026 17:43:40 +0200
Message-ID: <20261017160440.059463467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -616,7 +616,7 @@ static int bmp280_write_sampling_frequen
 					   int val, int val2)
 {
 	const int (*avail)[2] = data->chip_info->sampling_freq_avail;
-	const int n = data->chip_info->num_sampling_freq_avail;
+	const int n = data->chip_info->num_sampling_freq_avail / 2;
 	int ret, prev;
 	int i;
 


