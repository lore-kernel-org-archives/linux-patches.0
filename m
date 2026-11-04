Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829191;
	b=gyFPFObTpynyTDTsZdmd9Ev7kqWE6WWatgYtJ77qYC1uhVZWb4BJRsSwTumups5e1DHx
	 BXa/Y2H70vVej1SKXxWtvHVyILhJ+PV5PZgtGglffzQR7L3r4QBpPfLfJPzjpxLwYZysi
	 UWzS2fFTErZFrMtXZwkJBf5xulbX48EAbhy3eIP7dQIe0xTurhqBLnHvl6DOqoX6uV3yh
	 VEvaPjssxJNPwZ/JTj8UGLcZhDzXEobUC6PhxPP9THsiGVn5rTruv9UTtsEf235Ii0DoD
	 dShvtV86/6he/o8FuYsGzgKw2fGVLx76hbcPwiISUMq34U6NLdZv6U6AhtXiFadpjAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mM+ahmKJJbDe4ejLuwra8FZu/ayluxYdspjUfOcjiwA=;
	b=UGi/37qQSrbf7SYr719srzBvcSIcvfIZZfdNMvuAZ35ybd+Pt6UNLaMaCjsUxI0MrBc9
	 8c7PYrCq3Nl19IIKvrmq27A5RqcCJjcS+SwJ+mUiv0MDLfWxZB+8yU7Eq2ZftEjXooXk6
	 iJz39q6vdf6WrRoDAIBf3+V2goVY3fSaMUmd6Bp11SbxWK3RJ/QNFBvuzecvTBONZvzqc
	 aueNjI6GOM5sLduSZL6QxrkbjwhvZipgw/xOnLCsVHaT/UlRnrxmfRtRqHmBW0tB07/jV
	 QgGFdA7YVFs6XF7UP4lvDPVY96QYwCx0V+THdWPsgYYttZqrHjGYA5gktNRCAmlZ76Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAankkdR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AAD608F127;
	Wed,  4 Nov 2026 21:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAankkdR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DB31F00A02;
	Wed,  4 Nov 2026 21:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829191;
	bh=mM+ahmKJJbDe4ejLuwra8FZu/ayluxYdspjUfOcjiwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAankkdRSIlmvbJzBOyeageF9+AmonLjTyCKwxIWVdyDj6sz9qZ9C3E8J+ygIGlTe
	 ZWiuLGT/Xr8+CKcBceoo2WjgarKpey7cC5n5C9QyNY3YSdZdSVvVJR39QSLcXRUmzz
	 OsbR36VHmn3qTXX9jGHfJSvRlMFpBlDlYnUPhdrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.3 503/547] HID: roccat: kovaplus: reject short button reports
Date: Wed,  4 Nov 2026 16:11:27 -0500
Message-ID: <20261104211052.681638750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit e95917a606f486e46f5136fc1b72190742a091d6 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct kovaplus_mouse_report_button for button reports.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 0e70f97f257e ("HID: roccat: Add support for Kova[+] mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-kovaplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -614,6 +614,9 @@ static int kovaplus_raw_event(struct hid
 	if (kovaplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct kovaplus_mouse_report_button))
+		return 0;
+
 	kovaplus_keep_values_up_to_date(kovaplus, data);
 
 	if (kovaplus->roccat_claimed)


