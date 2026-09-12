Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C2447A0CD;
	Sat, 12 Sep 2026 11:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214001; cv=none; b=lJnBAj30AhWhD2lCBHaYkvfCpZ5e/myCIultYq69om4b66nWe1cc4uC8KFG4RHKL0JoeVWrA/0Cdc81uZel3otMQJ0tz1Yc7Xr/Vu4JS+NUBKyVikjccblp71tSJraX8Ky8yYFerEspWj27+E+XYSJmdln3n3VzuWoZ4TjUCBDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214001; c=relaxed/simple;
	bh=M4soXHRxpiuBdGlfJT0hLoDgc/KGZswmEtP99nF09iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tntd9bpSL5B2GWAwgVg/cZjh14Z1GE4mgNJXgPVI7Xm3hezHCwal0lNkRuTWNEYDsWOaX2k14xecxAjB7pO1hU+t/jrgNi5nJtvu5hu2E6DCXat6TsJANiqWH41Vsxz2307I50ZDQvYEgYxUo5kcpj3J/IOjtSBQT0pQ45OFrQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0UwcdfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0UwcdfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3036A1F00893;
	Sat, 12 Sep 2026 11:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213997;
	bh=xP/D3MuAgXWFX7CjbQa8tj/CLdBxxWqvqF2lE5CxmFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0UwcdfJJumuG8x/qtwtK6vdo50CxEmsyfKN7GHDS1rGpAWUV7+P7ra9ugRCa7EyQ
	 OBKeTQkVsVSq93z68QvsHrEVZLnroNUNGH4hINW3LkRQpoyzdJsj1va86UVZT9Ip08
	 zrTvxUi0MIvaL5bF8XSthMWYO3bpSv1he7XwppLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.12 0183/1376] media: cec: extron-da-hd-4k-plus: add sanity check
Date: Sat, 12 Sep 2026 08:43:29 +0200
Message-ID: <20260912065611.630298053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

commit abac9820b26b5cfcb01eb79efe2abdd0ac7e07c3 upstream.

Add check to prevent overflowing msg.msg[] in case the incoming data
is malformed.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Reviewed-by: Sean Young <sean@mess.org>
Fixes: 056f2821b631 ("media: cec: extron-da-hd-4k-plus: add the Extron DA HD 4K Plus CEC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
+++ b/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
@@ -656,7 +656,8 @@ static void extron_process_received(stru
 	if (!port || port->disconnected)
 		return;
 
-	if (len < 5 || (len - 2) % 3 || data[len - 2] != '*')
+	if (len < 5 || ((len - 2) / 3 > sizeof(msg.msg)) ||
+	    (len - 2) % 3 || data[len - 2] != '*')
 		goto malformed;
 
 	while (*data != '*') {


