Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199C7763F6;
	Wed, 21 Feb 2024 13:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521725; cv=none; b=gQ+SeKLXqQw3MqsgmmgKiTZhHxeNbW9rIFhHmWchVLmJ7f3JAn0gXu+xbanduMtLJR4cGsPRMb6Uq1aHATmPZGCM9wltbWXALPSAmnpqIisGMIS93z9usIPVCikuFvDjyqOx8lZUv5MhF1pqaTOxqnOSyGPdiC0hJWkAjF4ATSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521725; c=relaxed/simple;
	bh=SDvzDTtArtkXy++YzCaqdmyFRiLfCLp2mMs2huSqy4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGn5RGiEvJ5YVlNHBG00o+5Ct7vazUh6NxzquYji4yd848q07SqXLId6ZsSVlypsK3ySti3nMesi03uYEwOX6zXrmE4hqJLLMSLSypr/sMV17QE7hnOFMGWnHSaelTtg1eRm1IdiUcqV0MQZP9N0GJOFGr1j9V+Vc+do1cvs+IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLeZ0631; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLeZ0631"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F98BC433F1;
	Wed, 21 Feb 2024 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521724;
	bh=SDvzDTtArtkXy++YzCaqdmyFRiLfCLp2mMs2huSqy4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLeZ0631hftkP7yGmK+yExg6J/q19MJo8a0/HXQbJ7ErnhWYOmM8HK4nZHfowNRz9
	 hsgzwOCNPF0Nwd00PIGb+0ZVb58bJxbwhQ6nktyiz6ZbL6bnzrQ1VF7K/m8sXwTJb6
	 jzKNAt/2pUVvl6dKVsHrKpSb8tN5qLUDYJM58NCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 4.19 188/202] serial: max310x: improve crystal stable clock detection
Date: Wed, 21 Feb 2024 14:08:09 +0100
Message-ID: <20240221125937.880702899@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -235,6 +235,10 @@
 #define MAX310x_REV_MASK		(0xf8)
 #define MAX310X_WRITE_BIT		0x80
 
+/* Crystal-related definitions */
+#define MAX310X_XTAL_WAIT_RETRIES	20 /* Number of retries */
+#define MAX310X_XTAL_WAIT_DELAY_MS	10 /* Delay between retries */
+
 /* MAX3107 specific */
 #define MAX3107_REV_ID			(0xa0)
 
@@ -600,12 +604,19 @@ static int max310x_set_ref_clk(struct de
 
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
 
 	return (int)bestfreq;


