Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB1151CF0;
	Tue, 20 Feb 2024 21:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465180; cv=none; b=Va9IOXEk6DO6jl+MLK0BVYIGzg3fld7qXT5XciIfsUy7E4tnqTrkCLteAndH7FfEm0AXLBqOqtx0tnHGUduBiMqaLrh9v8cjApVsvSagsPK6SUaZ3hfWcsgRcNIfHHMI4GN3Cdi+zzLN/iDmNz1z3Ge8RbtCSRpTlOM7CdRFnvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465180; c=relaxed/simple;
	bh=9XHe/JqiYehAhhprC7ZuqEH+9Ye+PGdgugmJA7ucGVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j6+r07j1z3eX17t8VDNwvoAL8Eks6gT9w9NS9gb0xTAGi7U5j6isOhf/zCG4Sj1j7kp9RIvExXdw40TAAC0KD9HOi9i4IOuKnr8prVRmMIZmnI4OfALR6jJGREnz5FHhQETZ/UEPJ4Thru2LAKUow4Qb83H3+sHTUb5U40tZ1qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXZ39E62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXZ39E62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FFBC433C7;
	Tue, 20 Feb 2024 21:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465180;
	bh=9XHe/JqiYehAhhprC7ZuqEH+9Ye+PGdgugmJA7ucGVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXZ39E62nYFJ51VS5MYN3IIoQEtnUbaDKl6caVAHD1xCATo2ZJeyhTWHSatOO0drq
	 oO8lmTrxs/7Lz/tDyfVyhYe7P8vLgsvN8uau8UfwB/Qq5oPtprGfXWpGHrNY3F+WwG
	 FbtKZBLneV01V6R8GH9Dd1d0yldCPmhQKCFEGssk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.7 222/309] serial: max310x: improve crystal stable clock detection
Date: Tue, 20 Feb 2024 21:56:21 +0100
Message-ID: <20240220205640.104118050@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 93cd256ab224c2519e7c4e5f58bb4f1ac2bf0965 upstream.

Some people are seeing a warning similar to this when using a crystal:

    max310x 11-006c: clock is not stable yet

The datasheet doesn't mention the maximum time to wait for the clock to be
stable when using a crystal, and it seems that the 10ms delay in the driver
is not always sufficient.

Jan Kundrát reported that it took three tries (each separated by 10ms) to
get a stable clock.

Modify behavior to check stable clock ready bit multiple times (20), and
waiting 10ms between each try.

Note: the first draft of the driver originally used a 50ms delay, without
checking the clock stable bit.
Then a loop with 1000 retries was implemented, each time reading the clock
stable bit.

Fixes: 4cf9a888fd3c ("serial: max310x: Check the clock readiness")
Cc: stable@vger.kernel.org
Suggested-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Link: https://www.spinics.net/lists/linux-serial/msg35773.html
Link: https://lore.kernel.org/all/20240110174015.6f20195fde08e5c9e64e5675@hugovil.com/raw
Link: https://github.com/boundarydevices/linux/commit/e5dfe3e4a751392515d78051973190301a37ca9a
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240116213001.3691629-3-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -237,6 +237,10 @@
 #define MAX310x_REV_MASK		(0xf8)
 #define MAX310X_WRITE_BIT		0x80
 
+/* Crystal-related definitions */
+#define MAX310X_XTAL_WAIT_RETRIES	20 /* Number of retries */
+#define MAX310X_XTAL_WAIT_DELAY_MS	10 /* Delay between retries */
+
 /* MAX3107 specific */
 #define MAX3107_REV_ID			(0xa0)
 
@@ -641,12 +645,19 @@ static u32 max310x_set_ref_clk(struct de
 
 	/* Wait for crystal */
 	if (xtal) {
-		unsigned int val = 0;
-		msleep(10);
-		regmap_read(s->regmap, MAX310X_STS_IRQSTS_REG, &val);
-		if (!(val & MAX310X_STS_CLKREADY_BIT)) {
+		bool stable = false;
+		unsigned int try = 0, val = 0;
+
+		do {
+			msleep(MAX310X_XTAL_WAIT_DELAY_MS);
+			regmap_read(s->regmap, MAX310X_STS_IRQSTS_REG, &val);
+
+			if (val & MAX310X_STS_CLKREADY_BIT)
+				stable = true;
+		} while (!stable && (++try < MAX310X_XTAL_WAIT_RETRIES));
+
+		if (!stable)
 			dev_warn(dev, "clock is not stable yet\n");
-		}
 	}
 
 	return bestfreq;


