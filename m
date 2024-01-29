Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFEA76C7E;
	Mon, 29 Jan 2024 17:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548657; cv=none; b=tD7vBtatcGVu6aapcPL9JNgCbovPf8e/u+t2cpfv6vFxvINHMJ1eqI/x6q7av4SLWWwF3pzD/XpaZL6ct6ua8TMiSItVAoqEm3ZQ/Gabp9Ay2koXpsDsKte9MbD3qwTdPru9qW5ZR3SBYlILPcS09h+IIUsQRtg3w5ufebvTGDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548657; c=relaxed/simple;
	bh=Y5Gw7A+A7yMP3jUbujPrb+su5n14tILN0IGhF32ci0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwcpsgBZK3+yUfvdZQyGApfHuNoYNmU8Nvp6XJGWbrmePynaAc1wK18wSdNUom5ZrJZjrmAWBGQFewv55YaZ8fk8tagbPf+hY7/pVbHG47tS9rpU3hu1rq7mPwcXX23fcNK8y5BTLZKZuaPua98Rmqe57jAndx4VhSwZBKWzU+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4W/zDWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4W/zDWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70A1C433C7;
	Mon, 29 Jan 2024 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548657;
	bh=Y5Gw7A+A7yMP3jUbujPrb+su5n14tILN0IGhF32ci0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4W/zDWpx90CMuAlETCnEh0SA/KuQvN329YQODs+UJZ6e3P05QerAK+Q9JWs1Ta00
	 6f3+Vd/ypB8uk/p2aSg3v7zzEpEvqeAyIHsaUua9WI8BhNsgpFfoqkHm+nsGjBhWJy
	 aEWpVuwW1RrdJIvghY85Co5RKZhXxmoWso3U2dZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 331/331] thermal: trip: Drop lockdep assertion from thermal_zone_trip_id()
Date: Mon, 29 Jan 2024 09:06:35 -0800
Message-ID: <20240129170024.574003377@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 108ffd12be24ba1d74b3314df8db32a0a6d55ba5 upstream.

The lockdep assertion in thermal_zone_trip_id() triggers when the
trip point sysfs attribute of a thermal instance is read, because
there is no thermal zone locking in that code path.

This is not verly useful, though, because there is no mechanism by which
the location of the trips[] table in a thermal zone or its size can
change after binding cooling devices to the trips in that thermal
zone and before those cooling devices are unbound from them.  Thus
it is not in fact necessary to hold the thermal zone lock when
thermal_zone_trip_id() is called from trip_point_show() and so the
lockdep asserion in the former is invalid.

Accordingly, drop that lockdep assertion.

Fixes: 2c7b4bfadef0 ("thermal: core: Store trip pointer in struct thermal_instance")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_trip.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/thermal/thermal_trip.c
+++ b/drivers/thermal/thermal_trip.c
@@ -178,8 +178,6 @@ int thermal_zone_trip_id(struct thermal_
 {
 	int i;
 
-	lockdep_assert_held(&tz->lock);
-
 	for (i = 0; i < tz->num_trips; i++) {
 		if (&tz->trips[i] == trip)
 			return i;


