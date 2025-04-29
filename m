Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8257E110;
	Tue, 29 Apr 2025 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947916; cv=none; b=BeQpg4xyYajdiXZq5I7YUdzimrdIumzFgwl82QxbynPPhD81Y6D/3Bj2hOxzkxiq7+Oabk2T0GOxBce7m4s6sv6rjAQbZEarqp+1ZNdkBdBuqAgRbfvfZGzvmJCYz3QKQCqWLdj84b9gDesrlboHq7nBjTzA9xDL9SdRblJoUOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947916; c=relaxed/simple;
	bh=5rNWIyfvwMOk6lSNCF30gV36fw/PgjG/f+maxiMGU1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6Vk909rxOP2pfb0oKsl05K/nGyAULjP6fkGPfs0UJrzjX45vnZRSYXqZDMzAStLf7wiKryVtoyC7FveqvculRwPXEcQPNZEG8l3MW6Qu7mGWPiABJmxbU9wHu0uSiTTp+rH93+0HtlWAJijZnoBbzTj6ZA3NO0Jm5vQionGYN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eq3yI68N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eq3yI68N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC65C4CEE3;
	Tue, 29 Apr 2025 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947916;
	bh=5rNWIyfvwMOk6lSNCF30gV36fw/PgjG/f+maxiMGU1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eq3yI68NU/TX0ZOLqym68wLcRBXleLHsxbayl59wFL4MkV/DzpTa+QZKwOB8o1lED
	 h7z6XRuPUnpm1RzML4//F9NTGw7AWkKGkbOa7ivctYR6qdEqw+3GOI/bntEbalS3Gj
	 DeDRb6N736DQLFhyR0lIjWGfwc/oZcGlKbXUnjGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 144/280] usb: dwc3: xilinx: Prevent spike in reset signal
Date: Tue, 29 Apr 2025 18:41:25 +0200
Message-ID: <20250429161121.020080243@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mike Looijmans <mike.looijmans@topic.nl>

commit 38d6e60b6f3a99f8f13bee22eab616136c2c0675 upstream.

The "reset" GPIO controls the RESET signal to an external, usually
ULPI PHY, chip. The original code path acquires the signal in LOW
state, and then immediately asserts it HIGH again, if the reset
signal defaulted to asserted, there'd be a short "spike" before the
reset.

Here is what happens depending on the pre-existing state of the reset
signal:
Reset (previously asserted):   ~~~|_|~~~~|_______
Reset (previously deasserted): _____|~~~~|_______
                                  ^ ^    ^
                                  A B    C

At point A, the low going transition is because the reset line is
requested using GPIOD_OUT_LOW. If the line is successfully requested,
the first thing we do is set it high _without_ any delay. This is
point B. So, a glitch occurs between A and B.

Requesting the line using GPIOD_OUT_HIGH eliminates the A and B
transitions. Instead we get:

Reset (previously asserted)  : ~~~~~~~~~~|______
Reset (previously deasserted): ____|~~~~~|______
                                   ^     ^
                                   A     C

Where A and C are the points described above in the code. Point B
has been eliminated.

The issue was found during code inspection.

Also remove the cryptic "toggle ulpi .." comment.

Fixes: ca05b38252d7 ("usb: dwc3: xilinx: Add gpio-reset support")
Cc: stable <stable@kernel.org>
Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250318064518.9320-1-mike.looijmans@topic.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -207,15 +207,13 @@ static int dwc3_xlnx_init_zynqmp(struct
 
 skip_usb3_phy:
 	/* ulpi reset via gpio-modepin or gpio-framework driver */
-	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
+	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(reset_gpio)) {
 		return dev_err_probe(dev, PTR_ERR(reset_gpio),
 				     "Failed to request reset GPIO\n");
 	}
 
 	if (reset_gpio) {
-		/* Toggle ulpi to reset the phy. */
-		gpiod_set_value_cansleep(reset_gpio, 1);
 		usleep_range(5000, 10000);
 		gpiod_set_value_cansleep(reset_gpio, 0);
 		usleep_range(5000, 10000);


