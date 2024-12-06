Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87DF1DFE1E;
	Fri,  6 Dec 2024 15:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498596; cv=none; b=buigMP0oC2DeGW9nYDsGJPE02S9qZ/gnsDhepyemYrdas3TbX8qcId+RWpuw3pNV/9p3pItKHAd9OfUebgCuybeYJA5jLGS4ZUwxe/wpet8b0Z4nAdccGOUGcKtT8CRDAnekJ5by6d/g8fXiC0FsZPR7yihPNDfk2QcEb2YKRu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498596; c=relaxed/simple;
	bh=UnBezSBRmy2KnIvBARp2ngY+GZl3ow3Rm3iAoff2NyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3sjJvg0QMkOXMKrKR4z/6vL11mdwZAsKNu7RWU3vFeXooZv0Fh0mf99x7fjFUzibmAkTin+TJIUQ/yq8d0CEIviTvjsHnlCTYRLKFYqArsOx+zT3vYrg47shgOkXnnajVn+B1Eo6cFwMI/1wYaryueMg0u3GHL1O66b3R8ZV7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0J0ahCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0J0ahCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46DDC4CEDC;
	Fri,  6 Dec 2024 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498595;
	bh=UnBezSBRmy2KnIvBARp2ngY+GZl3ow3Rm3iAoff2NyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0J0ahCEWpE83wJhreb8MdQmtsr+cCLQt18ZdcxrCDDx23TgxjcKyqdLDhQ6GzHd9
	 YjlEK4dVYMGdGgWtov8SdMLMNS/nCFJBFUHLGzeKETI8q4NFOOTTytZYu6P83jJF34
	 FH+MZ76dqKdNfh4lu8EYWVVnV1QLxFIXHl2QTafk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 632/676] leds: lp55xx: Remove redundant test for invalid channel number
Date: Fri,  6 Dec 2024 15:37:31 +0100
Message-ID: <20241206143718.053663783@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Vokáč <michal.vokac@ysoft.com>

commit 09b1ef9813a0742674f7efe26104403ca94a1b4a upstream.

Since commit 92a81562e695 ("leds: lp55xx: Add multicolor framework
support to lp55xx") there are two subsequent tests if the chan_nr
(reg property) is in valid range. One in the lp55xx_init_led()
function and one in the lp55xx_parse_common_child() function that
was added with the mentioned commit.

There are two issues with that.

First is in the lp55xx_parse_common_child() function where the reg
property is tested right after it is read from the device tree.
Test for the upper range is not correct though. Valid reg values are
0 to (max_channel - 1) so it should be >=.

Second issue is that in case the parsed value is out of the range
the probe just fails and no error message is shown as the code never
reaches the second test that prints and error message.

Remove the test form lp55xx_parse_common_child() function completely
and keep the one in lp55xx_init_led() function to deal with it.

Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Link: https://lore.kernel.org/r/20241017150812.3563629-1-michal.vokac@ysoft.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp55xx-common.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -580,9 +580,6 @@ static int lp55xx_parse_common_child(str
 	if (ret)
 		return ret;
 
-	if (*chan_nr < 0 || *chan_nr > cfg->max_channel)
-		return -EINVAL;
-
 	return 0;
 }
 


