Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64020566C53;
	Wed,  9 Sep 2026 14:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962437; cv=none; b=IoliFbvYe+im5zQFGYXCSDkLRSdvNhwjgoXZCqI6kmxEiTGR9wc5qt4LVWpNExWO5bMb+1ImYdQ5esAuXkGUH5cWhpx81nPgf1gmkcmy3Q5Zz1sypPQhs/a4vxs2LKcQ9lXJubME3+JChGgKWHp/5+Ax68LCVuYydco3eWHLIFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962437; c=relaxed/simple;
	bh=mxVjYhUWz0GdbdzzVC4Zfcc6veo7aJC5vOrB0iGmqZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xgiz+Y0xpowAl8VYxTOV+c9jUqFmmbbadS2T7eSWvQxIDXb6LVwmERGQjhsInjFodbvPtDnBymzh1uFEA3WQdLoamBB5KwzsNa1tLcUHnShhr4YFW9/gFhFnN0uaTszhSt/OJ+XKt7B/WyhpGfxuvpH0vkyMRQtWFYJijW2tHGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BAjTHwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BAjTHwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8A81F00A3A;
	Wed,  9 Sep 2026 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962436;
	bh=3ZAU7/KMXnyahrypNkwd5Zg/wJCOBPCglasf8ujCOvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BAjTHwpoHFHKj5iCxLnMOw+eaCfxW/v+MzvqOqTogDqeZhBakQ2hgR9KPyVVBzgF
	 K2GER+U7SnV3BcfPqZh3orpY9fFZd5Ad3eDYCSCn7PhHIysjZd4FmmHPdtmjq4aZ5s
	 iki3mHYO/aFdYjZ3bCSh0Udrz5i3OZ5RpV31hZzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 289/556] iio: light: opt4001: Reject integration times with a non-zero seconds part
Date: Wed,  9 Sep 2026 15:39:29 +0200
Message-ID: <20260909134240.852008460@linuxfoundation.org>
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

From: Nikhil Gautam <nikhilgtr@gmail.com>

commit d0f21621f8b2b46661ea066d20705dbf7253db87 upstream.

opt4001_write_raw() only looks at val2 when setting the integration
time, so a write such as 1.000600 is silently accepted as 600 us.
Return -EINVAL if val is non-zero.

Fixes: 9a9608418292 ("iio: light: Add support for TI OPT4001 light sensor")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt4001.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/light/opt4001.c
+++ b/drivers/iio/light/opt4001.c
@@ -269,6 +269,9 @@ static int opt4001_write_raw(struct iio_
 
 	switch (mask) {
 	case IIO_CHAN_INFO_INT_TIME:
+		if (val)
+			return -EINVAL;
+
 		int_time = opt4001_als_time_to_index(val2);
 		if (int_time < 0)
 			return int_time;


