Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0FF1E1C1A;
	Sun,  7 Sep 2025 20:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276901; cv=none; b=cGjzy6+7oSPdTgyOF/imfpl7qVjituToEeg6zv9MWVLAyrQXeKdmoVNISv2ae4w7zJ9k6fVTCd3nqbgdxRAAlTqY2oRILetjinVE47tIZJzf8ebMoQ44OAksj1l3to8NUEX6mUMkXgndo9VCst7xa/nTKPrFsCweSZEIvlUdLbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276901; c=relaxed/simple;
	bh=7yhslsSMi0QUEQJYze0W5OQZdY6qECRS02FdWPFnCKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzZKE6a2emtpbXjELDXj49e3synzOLCpcRJMiJ9VlaHmfewISh6SdtPIokSOxY5pAfBijKBV1s6vuZ8HxkBIXa0DNGbt8w157SiXNwBK0oXmd0WjxvVp8JDAUka0roK2TPDHV+MUWG+Lm2YzIq0buOCzQd3LY1ubBb4NM87nbYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZ1MW4DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZ1MW4DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDA6C4CEF0;
	Sun,  7 Sep 2025 20:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276899;
	bh=7yhslsSMi0QUEQJYze0W5OQZdY6qECRS02FdWPFnCKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZ1MW4DYnry9nfB6F6jAeQ8GxdEffyKpK6QIhw8dDYrPsUFVM73lKFaL92BFLN+bL
	 rwKSHlwN9QR0wG8/yYG1Yktw9j5ckRKQc6NiN4tQUuXW234R3PDhbxxhCexgukvkf/
	 6/PMp2Pi4ans0WKlGMc3G0u6LiiNLyw7ibRQFz/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/175] HID: simplify snto32()
Date: Sun,  7 Sep 2025 21:56:58 +0200
Message-ID: <20250907195615.427742804@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit ae9b956cb26c0fd5a365629f2d723ab2fb14df79 ]

snto32() does exactly what sign_extend32() does, but handles
potentially malformed data coming from the device. Keep the checks,
but then call sign_extend32() to perform the actual conversion.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/20241003144656.3786064-1-dmitry.torokhov@gmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Stable-dep-of: a6b87bfc2ab5 ("HID: core: Harden s32ton() against conversion to 0 bits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c2783d04c6e05..1a8e88624acfb 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1318,9 +1318,7 @@ int hid_open_report(struct hid_device *device)
 EXPORT_SYMBOL_GPL(hid_open_report);
 
 /*
- * Convert a signed n-bit integer to signed 32-bit integer. Common
- * cases are done through the compiler, the screwed things has to be
- * done by hand.
+ * Convert a signed n-bit integer to signed 32-bit integer.
  */
 
 static s32 snto32(__u32 value, unsigned n)
@@ -1331,12 +1329,7 @@ static s32 snto32(__u32 value, unsigned n)
 	if (n > 32)
 		n = 32;
 
-	switch (n) {
-	case 8:  return ((__s8)value);
-	case 16: return ((__s16)value);
-	case 32: return ((__s32)value);
-	}
-	return value & (1 << (n - 1)) ? value | (~0U << n) : value;
+	return sign_extend32(value, n - 1);
 }
 
 s32 hid_snto32(__u32 value, unsigned n)
-- 
2.50.1



