Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1008155A2A;
	Mon, 29 Jan 2024 17:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548094; cv=none; b=WE2KwTeYzNdxK/1oEYxQVSHSYYesQbmK5T7Ppa8iV1xODrKxByJpv3TlTNDrFxGqTOVzQ/AoIZyzMxROgZXUJ70MNvEVlfDK20x2PexU5BW+tgnkNhzQJmSzWlrLKWYd4ceeu+aNjr3Jm9XjSphA8tyBu2dOoNWv4s3kPfinWOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548094; c=relaxed/simple;
	bh=9tcaFuliCZk2PZdj0n+d7K+FAr1nB52ql/AGhdESwN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HVGGFwaXFthotZ/tfm/cthMFMicJZ22vW0zD6TiZ04DI6YOrPyXrDdpHWLM6AdIBqW4tQ1UWiUxvep7LH8Ny2ClRmJ5GHM4a8I78z72IJNx7RvXUnoWu1PkfwTx/s5nlnwkqsxpRfxfbjSe3CAGi2eDH5jyZQnsVy+CwLWVSByI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ue1yAV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ue1yAV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D56C433C7;
	Mon, 29 Jan 2024 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548094;
	bh=9tcaFuliCZk2PZdj0n+d7K+FAr1nB52ql/AGhdESwN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ue1yAV587XbDyFtrEh9yjbfwTITCTOOyhr4sSJDG6QnhrMndlTNOfNN8AvORhAvB
	 o4hSfYffk4rZOoKFGoeLBWuSX39DwSgsGCAK8Ueo+Y/OIhL5AkLJb2f/1/tAUjQiuj
	 OOzmNl5KAVkIu/DL/jkpFv4IIPtd7fyCPbutG8Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.7 111/346] rtc: mc146818-lib: Adjust failure return code for mc146818_get_time()
Date: Mon, 29 Jan 2024 09:02:22 -0800
Message-ID: <20240129170019.656756309@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit af838635a3eb9b1bc0d98599c101ebca98f31311 upstream.

mc146818_get_time() calls mc146818_avoid_UIP() to avoid fetching the
time while RTC update is in progress (UIP). When this fails, the return
code is -EIO, but actually there was no IO failure.

The reason for the return from mc146818_avoid_UIP() is that the UIP
wasn't cleared in the time period. Adjust the return code to -ETIMEDOUT
to match the behavior.

Tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Acked-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc:  <stable@vger.kernel.org>
Fixes: 2a61b0ac5493 ("rtc: mc146818-lib: refactor mc146818_get_time")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231128053653.101798-2-mario.limonciello@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-mc146818-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -138,7 +138,7 @@ int mc146818_get_time(struct rtc_time *t
 
 	if (!mc146818_avoid_UIP(mc146818_get_time_callback, &p)) {
 		memset(time, 0, sizeof(*time));
-		return -EIO;
+		return -ETIMEDOUT;
 	}
 
 	if (!(p.ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)


