Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCADD27732;
	Thu, 16 Jul 2026 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211735; cv=none; b=qfq5gfSk88/pzsJbby70kINx+UWYxpNdfhJa4sEmuedv+poTorMcAP4iUokQKpQ3i/ZqHwPcHJrOQdukzpCcdcE5fbb1JWLgTpaDr55F/MTtdAHRyFusavS2ANizRj5uVKyL2W3TfbSPYHphwrw+lCe6oRlSyCVANUH1oUCuzLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211735; c=relaxed/simple;
	bh=Xd2uH0mVxHlUxmoSBMB0kzZc+/10uf9GB3vrkcnoGts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sksnCEz3NzcAaa98uSJxJX8OeGwLoKRvoIrYv1owdQTdGr+RiDZF4m6Eoven2TW2aJMZaS2+TGWCelCeIpgjHqiamnVR12djwfGs19+sCWLUgzJ8Zw4oSWdhVfK8bnQgKDEnRfMatjTfc9G8pAgeQ275+D0B76miKcHsP2RWvvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHjx+pG+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHjx+pG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E01F1F000E9;
	Thu, 16 Jul 2026 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211734;
	bh=l9upVtSgddUchdx1HEm+xqXCA7o0uQUZ5s5dkqSRT+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHjx+pG+C8x2NUy6CZZA6RIJeQ6+cRwk+oyE8QGIzO84CgzWLWVYb+/uRsT+NbOeM
	 z5Cd7khvGTBfboQxxHOmfe7IelM1vZMRoOeoNyaWqU3U1Kk4yuBrsUZ85kC9sPmbjK
	 aXoTPM1iZ09zUFCLx7POSHCNOzJ1ZQ/l572eufmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 061/349] iio: light: al3010: fix incorrect scale for the highest gain range
Date: Thu, 16 Jul 2026 15:29:55 +0200
Message-ID: <20260716133034.693065239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Vidhu Sarwal <vidhu.linux@gmail.com>

commit aa411adc6ce40ad1a55ebc965f255a4cfc0005f8 upstream.

al3010_scales[] encodes the highest gain range as {0, 1187200}.
For IIO_VAL_INT_PLUS_MICRO, the fractional part must be less than
1000000, so the scale 1.1872 should instead be represented as
{ 1, 187200 }.

Since write_raw() compares the value from userspace against this
table, writing the advertised 1.1872 scale never matches the malformed
entry and returns -EINVAL. As a result, the highest gain range cannot
be selected. Reading the scale in that state also reports the malformed
value.

Fixes: c36b5195ab70 ("iio: light: add Dyna-Image AL3010 driver")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/al3010.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/al3010.c
+++ b/drivers/iio/light/al3010.c
@@ -43,7 +43,7 @@ enum al3xxxx_range {
 };
 
 static const int al3010_scales[][2] = {
-	{0, 1187200}, {0, 296800}, {0, 74200}, {0, 18600}
+	{ 1, 187200 }, { 0, 296800 }, { 0, 74200 }, { 0, 18600 },
 };
 
 struct al3010_data {


