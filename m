Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEB9309EE2;
	Sat, 12 Sep 2026 19:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242027; cv=none; b=dP5LNQBVcw+o0XD9mVEhuHs/rYMQfnTYQgu0yYbDBQSnzMMcsXE7pZ0CaobK8WZw9JbpZfos6SGmj8f+SFM4x3nj4cC+bjcNk8/mWva6zezzN3r0rXTmTLCt3Kw7hQJQ/a16C7QxlLmvsQZ1wVrZNBAhIjF40Lct3gPolKSzk6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242027; c=relaxed/simple;
	bh=EpUdxUREyd4oVhNHTji7CEAoH2BBR4pIZ/vuTBgA3xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPddFWpvJ8N8gzC+IjdnARR8W7ipXF2mFGEBW/w1guxTcp92ycbn7B2S16mKjglgnRnjMd9RkcVRCjJrjpyf+hFPKGNKp9ynd8zfsOIWVWA/dODkZCaBPipU+BFwEThteW+tTWBmSxLlPj8VmNYhkmCH2Wj6ODLE4rM1kP6mJ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrb2tHvD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrb2tHvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB6D1F00893;
	Sat, 12 Sep 2026 19:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242024;
	bh=Rkrf+h5998qKB1/jvofjibIhLe+II2SYFDvsRJmG2ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrb2tHvDu0HNnWgOJN9+XVSaoG2I9gnuXXV2bahWP104TcfZtIMqNNBfgxZZ9UqTh
	 XGoSTDEHPdPbNtDfanzybm3Bt3p0icmV5goism8yxFK8ok0VIZHwFsXDoXmI+6JGph
	 26d45vMTF23AnoR0n5Qe/1Wu2QcnAxQLzsQI/BgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Tchankvetadze <giorgi@tchankvetadze.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 259/798] iio: light: cm32181: return zero after writing calibscale
Date: Sat, 12 Sep 2026 08:58:07 +0200
Message-ID: <20260912065523.096883662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>

commit 8756acd30919a3e9f547ea4a1d4b7f7895f4d340 upstream.

The write_raw callback is documented to return 0 on success or a
negative error code.  However, the IIO_CHAN_INFO_CALIBSCALE case
returns 'val' (the user-supplied value) instead of 0.

Fix it by returning 0 on success, matching the behavior of other
calibscale implementations in the subsystem.

Fixes: 971672c0b3cc ("iio: add Capella CM32181 ambient light sensor driver.")
Signed-off-by: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/cm32181.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -370,7 +370,7 @@ static int cm32181_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBSCALE:
 		cm32181->calibscale = val;
-		return val;
+		return 0;
 	case IIO_CHAN_INFO_INT_TIME:
 		ret = cm32181_write_als_it(cm32181, val2);
 		return ret;


