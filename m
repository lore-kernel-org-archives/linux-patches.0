Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CD9550DA6;
	Wed,  9 Sep 2026 14:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962426; cv=none; b=a5LokpLBF3ThkwZxrEf5aVS/kSmDhSHMWjJSXZk5uyuYlBOaT+2vqNN4swg0mQe8YYsi2N3RD69Arfk8JGw+QV+ZieG1siaSQI26vTvrn3lf1LYWJKhFo73afzpIqC5AM6skj/ZBm13GXwm5vURR0dIZAkjIvc7/ap4WvOx3ts0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962426; c=relaxed/simple;
	bh=vdzCfHiiNTkH6yoSWV9+aZn0GEuHx/PjbOiwlPTrMgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBkhm55MpsgyjaqgsNCcPlKS1VEnU2faFsGtBoUF0zWWOPNiPr07GctZV/g3EaqOSH02vt746ciCLvDeKfJO1mQO86AlJDUMHeOIN4X+BY32C/Oy92WOuRna0CyHPW+Dy69R2SBWk4aasQkCe/i3IMYLu7wpX4s9gilaoXwlF/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHeOMf81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHeOMf81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D76B1F00A3A;
	Wed,  9 Sep 2026 14:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962424;
	bh=TpmbKz5SknveuSnW8hvuSTHFKeBte532jbBNDPICm9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHeOMf81xDLyUk7ZMIqDMdS2Xk6p3JKWTvbX30NFjHkxmkmUep6Cyf+7yUt5POWP0
	 io1wudNsKawtUQXt10bNzF6OztROl88QuRKynG/8byTMTof98ngucYGO9Tj5QkL1SL
	 idLnaQJF3cmgk+32E2olu8QG2Has6GiMz0Oxmr2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 285/556] iio: light: opt4060: Reject integration times with a non-zero seconds part
Date: Wed,  9 Sep 2026 15:39:25 +0200
Message-ID: <20260909134240.691808195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -632,6 +632,9 @@ static int opt4060_write_raw(struct iio_
 
 	switch (mask) {
 	case IIO_CHAN_INFO_INT_TIME:
+		if (val)
+			return -EINVAL;
+
 		int_time = opt4060_als_time_to_index(val2);
 		if (int_time < 0)
 			return int_time;


