Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7189A3C4555;
	Thu, 16 Jul 2026 14:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211838; cv=none; b=FUU56aLUXpRwJDLJqx+8h9+9hBWiwgd/mPrd3sUTZ1dXOEsA+VmvzdEUxfsdjIkwHEwN0Yff8+GETxXOIH9pXCJmpglv3Y/U0PANRI8iJACfja5KgJOvntSzBZqiKdItTudoaT0n6WKFNDiXtQcYMI8v/Wz0WM9vFuoiwT/8A04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211838; c=relaxed/simple;
	bh=E25ss6zrByyD4ukiw7+ughzaqZ/JH72ZMr04ktHxTlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtFxDd7BNo7kXASwqaaekUpvgKHfM3EMAPAA+U24sDhiAOJFHAVzdhyGypTMr+qE70H9sMYvnejdA1bB1SVzqwPgVUfb8+LAbSxPt3sg2boJWM8eVwTt83cd6ETIVew5kOgCIRDXqqpOobCbO0oK9y7O5CyG/wqj8pHVd+PwXWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwU7sAF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwU7sAF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B1E1F000E9;
	Thu, 16 Jul 2026 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211837;
	bh=mygubz7GrO9MqZcqiuuZ/EJw6CVo7JVT6oy8xM8Sblg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwU7sAF9ACgrtB4NWC3tIbqS22xE0JanEu8BDWCziugC6bt3XfE4usO12AO/X0DDf
	 CYZYjIojms4oem4slk0P7R1jrdnJjRkhnhqFfyxS5e1o8lOumdKiwwOk39RlVDjvyB
	 6DGm1+0aORq0tMtNlSD6xzaEGkdHcWsJJtvhw2hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 055/349] iio: gyro: bmg160: wait full startup time after mode change at probe
Date: Thu, 16 Jul 2026 15:29:49 +0200
Message-ID: <20260716133034.556129199@linuxfoundation.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

commit 088fcb9b567f8723074ad9eb1bf5cb46f8a0096b upstream.

bmg160_chip_init() calls bmg160_set_mode(BMG160_MODE_NORMAL) and
then waits only 500-1000 us. Per the BMG160 datasheet
(BST-BMG160-DS000-07 Rev. 1.0, May 2013), the start-up and wake-up
times (tsu, twusm) are 30 ms.

The same file already waits BMG160_MAX_STARTUP_TIME_MS (80 ms)
in bmg160_runtime_resume() after the same set_mode(NORMAL)
operation. The 500 us value at probe was likely a unit mix-up;
the old comment said "500 ms" while the code used microseconds.

Reuse the same constant via msleep() and add a code comment
explaining the datasheet basis for the wait. Without this,
register writes that follow the mode change can hit the chip
before it is ready.

Fixes: 22b46c45fb9b ("iio:gyro:bmg160 Gyro Sensor driver")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/bmg160_core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -267,8 +267,14 @@ static int bmg160_chip_init(struct bmg16
 	if (ret < 0)
 		return ret;
 
-	/* Wait upto 500 ms to be ready after changing mode */
-	usleep_range(500, 1000);
+	/*
+	 * Wait for the chip to be ready after switching to normal mode.
+	 * The BMG160 datasheet (BST-BMG160-DS000-07 Rev. 1.0, May 2013)
+	 * specifies a start-up / wake-up time (tsu, twusm) of 30 ms; use
+	 * BMG160_MAX_STARTUP_TIME_MS (80 ms) as a safety margin, matching
+	 * what bmg160_runtime_resume() already does.
+	 */
+	msleep(BMG160_MAX_STARTUP_TIME_MS);
 
 	/* Set Bandwidth */
 	ret = bmg160_set_bw(data, BMG160_DEF_BW);


