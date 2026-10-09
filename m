Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB8D81ACD;
	Fri,  9 Oct 2026 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557653; cv=none; b=DM7WFwyDV/wJld69aKz9dV4V18l96vXaoabwC7egPwwln1TVmq502LIPXkX1/1FmW/7oCWN5m0bvkIztbOvUbLtq7qO43//5ed9X5Ofxuf/e5HMLU9PTlr6FJqrHsliBlM1ixB1lpLufj1iK76+mX8+Wc2shNrLX7vM8JpDLfuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557653; c=relaxed/simple;
	bh=HfFEjjfm60nLB3Wv2gdFxc9YgMpgEBdZIY1qiGaL/oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRM2xmk2rgDXHR35f6KmWQDbH2wgynzSfnF8DEx+j79qDEqW76WW+eJ+eRBFPZVOBjDJEJkf7k3rDMlGaRM1QYA9N7WFzpkM8/+PT137kdem0zyPvqPxucOTfuKsPvJrsVIqPjf1H7y5MVY24XzrApT2evLNlIbpB5I/msHl5oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2W0WOvk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2W0WOvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661511F000FF;
	Fri,  9 Oct 2026 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557652;
	bh=hm2jpAeUeQgJPQDCD9A/VuO1+mDNwJ09yXNZsRxkWqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j2W0WOvkwZZzEoKRfDJW7pyJhGKgbcga7IgfYIgEKHnycbP5TMfUOlpajHUG0Y/Pm
	 GZtwbATjFI/A29iuJetHSz5h0bNu2aGtw8JcOkXMLVpsfE+yapmI1xYQFoZmBiAhc+
	 tswEHbaNk8mu70orWfbSqJnbpBCkxybAiVQfrZUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 398/428] iio: frequency: adf4377: Fully initialize clk_init_data and clk_parent_data
Date: Fri,  9 Oct 2026 16:12:15 +0200
Message-ID: <20261009140954.955593884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit e787fd23d5063c61582c3c27522240b6e6703fde upstream.

The clk_init_data structure contains several mutually-exclusive members
for different methods to specify the possible parents of a clock,
prompting drivers to initialize only the members they need.  However,
not initializing all members may cause subtle issues, which are only
exposed when CONFIG_INIT_STACK_ALL_PATTERN or CONFIG_INIT_STACK_NONE is
enabled.

adf4377_clk_register() fills in init.parent_data, and assumes that
init.parent_names is NULL.  However, the latter is uninitialized, and
thus may cause a crash.

Similarly, adf4377_clk_register() fills in only parent_data.fw_name,
leaving other members of the clk_parent_data structure uninitialized.

Make sure all members are fully initialized, to fix such bugs, and to
avoid future breakage when converting drivers to a different method for
specifying the parents.

Fixes: 60e5448ddbec2dc2 ("iio: frequency: adf4377: add clk provider support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/adf4377.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/frequency/adf4377.c
+++ b/drivers/iio/frequency/adf4377.c
@@ -997,10 +997,10 @@ static const struct clk_ops adf4377_clk_
 
 static int adf4377_clk_register(struct adf4377_state *st)
 {
+	struct clk_parent_data parent_data = { };
 	struct spi_device *spi = st->spi;
 	struct device *dev = &spi->dev;
-	struct clk_init_data init;
-	struct clk_parent_data parent_data;
+	struct clk_init_data init = { };
 	int ret;
 
 	if (!device_property_present(dev, "#clock-cells"))


