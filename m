Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4D63290B9;
	Fri,  9 Oct 2026 14:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557568; cv=none; b=GeAaomOE9NmaCZGGO25ZAXeg5tfW6y0LoUF/XM4abDITIu16tK3N8zeU3phOaK/WS6nMk59NFL7xS/Y37V1NJvZQAHvbxlAPfOikBAtzMPZM8HvhSL02H/wjGb9JzrHcj7gKsyM3PgslGjowLEKeo78sK0OUQ5JZOmAa8/ul67g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557568; c=relaxed/simple;
	bh=NnnPUN5vFZYA+z9mbo2Mn1KlV49nwOps/3JGlyz46uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MG5B47GTjFoSILAMnLqh5MDtMoB6w8r5lO/j8jJUEkreYb4uK2obzMxoIt9cJAhF/JIdMPklf25vliHb/81jvcITyryLcOQlUtMwiklNGW+7EsOsez2W8bW/zH0SEcTLzElWjMywx9gr2URzbbpuDFtUaZRaBkuze2cdGZ7YnjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKq6Sx3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKq6Sx3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E11D1F000FF;
	Fri,  9 Oct 2026 14:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557566;
	bh=Z5TFyCiWCa9GUI5V3NahkZC3lg+l366LGcilNRSEu+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yKq6Sx3nmXB1XkTL8diUy24AlCxxiH/vCJTZYjH/jDgfyWDd0xke+uKMPFQi5Ne4x
	 LfE/ktrh82GSzvNBs2OSVul9LYm0jinBeensPinsQEW9BsVrPIxP/KPKAdbjSyzPKE
	 68jacqVCovg4+ysnoh9HQlE8bLU8M40GOs2FcPz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 406/428] iio: pressure: bmp280: fix out-of-bounds access in sampling frequency lookup
Date: Fri,  9 Oct 2026 16:12:23 +0200
Message-ID: <20261009140955.139633229@linuxfoundation.org>
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
 


