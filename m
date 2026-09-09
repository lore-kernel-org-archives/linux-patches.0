Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC2F579820;
	Wed,  9 Sep 2026 14:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964011; cv=none; b=FGgU5IuAdf5031LpYhyXmbhHSKCJrvj5bvIMoyvoTh2iEtY3w0nnUJ1WeIjvGEJHI4c9C2/NTaWkBg/9TxACrhdMmdEYZ96AC1BqmJ6C8jTa7Dn4GSwtcdtCOCX4mNfF09gt6rh1S6HWA/On3hATjP8XkyV/qnznX0mUAqavJ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964011; c=relaxed/simple;
	bh=ceRgyR4dJDQhfKBlh6VJUhMEVIEEEaRu52oAF15r6T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkcZpEnFdQti2X+JDpdzYDpkj7XVHsMJoaucGY4XNjEmwS71uCUvD8YSs69s2W6fSG8pR6/FGOXkCEOuRWGwQflwkbXYkbPCZPbHFo8Qnabl1RWNGLgjArRNzO9fmT31fp+ppp4PUjoWZ/8U9yI4WCHUBkm47I54z34egWCi+wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nf31xD7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nf31xD7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3214F1F00A3A;
	Wed,  9 Sep 2026 14:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964010;
	bh=pEXsXr/GauObnOMKAVsOarvbNBL+Q/D1Sx9HfqPUF+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nf31xD7mLYovcDLoufZ5GEaR3TO7w+7zCpaMsPp1XVUrVsvgrLor4LmaSQgt0YVkB
	 JwwOHV1BTpkGP8I7uBTVdRyTJMI8G44H0rasCEUy9Jz1qTVq82TUr9WQ6jGDnkPLpx
	 nnhT4IPbaLF0CzJ1A6SCCCUGTv+2OXZGQCJ8QcWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 223/583] iio: light: opt4060: Reject integration times with a non-zero seconds part
Date: Wed,  9 Sep 2026 15:38:28 +0200
Message-ID: <20260909134245.884111925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Vidhu Sarwal <vidhu.linux@gmail.com>

commit b7e6e9af0d723afdec92364d5e7e064eeef44c8e upstream.

When setting the integration time, opt4060_write_raw() only uses
val2 and ignores val. As a result, a write such as 1.000600 is
accepted and programmed as 600 us, silently discarding the whole
seconds part.

Since all supported integration times are less than one second, any
non-zero val represents an invalid input. Reject such values instead
of silently accepting them.

Fixes: 0c6db4506ad0 ("iio: light: Add support for TI OPT4060 color sensor")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt4060.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/light/opt4060.c
+++ b/drivers/iio/light/opt4060.c
@@ -650,6 +650,9 @@ static int opt4060_write_raw(struct iio_
 
 	switch (mask) {
 	case IIO_CHAN_INFO_INT_TIME:
+		if (val)
+			return -EINVAL;
+
 		int_time = opt4060_als_time_to_index(val2);
 		if (int_time < 0)
 			return int_time;


