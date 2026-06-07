Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001DE1E98EF;
	Sun,  7 Jun 2026 10:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829064; cv=none; b=A7jB01q59FldLZI5ZV/LoWXEDzwhDSwCBOxF3pTqIkgYb9kyDfaeW9ICZP/yZ/7GAWKzoSw3FPkwDhZXRp258+JHvCs8zeu3TLFRfOFu06IeQ0r50Hv0r35M8eIX0zp8EN91bjMgKFloA5OvHijLE45Fb4f1/gpH6NUsT544D0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829064; c=relaxed/simple;
	bh=+5Kd9I/GW7gVMYzDQsvL3KrxhLLFNjIhwP+BxC5mQNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot9K85rpnqh4VV6D4gIUfgtiMijDHmlR1TfOTV+jSmG9o8BeJOfQpL6Y1i1JSgLAgKYe0TYcaed2AiX7s+RDWGMv2M3wIYCEAKh3eDzk+1r4H2cbNi27l4ABOzc66/xlgq6RXXM4xXm0qrjpYeR3YjbqtHKKKVD+m7AMwCyUG2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJMZwEUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJMZwEUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE951F00893;
	Sun,  7 Jun 2026 10:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829063;
	bh=ly6S4eI+jc0zylrlKgxvrZJbA4i9O5SfHg6pjuqytKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJMZwEUZS9DddDsGQT72DIbgDPuCgu06WfOjG7zB8hwalhuYdIaK5Bkwox48KCyDo
	 seiX8gN1sEyRVbsanRafqC7udbKT3reN4YSFG0LjldMwjnWaoIm4Y9f8GIrVdJus5G
	 NszQTowbl+IDqynO1ID6CGCSvTfd3j8Zac/YJ2/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 214/315] Input: atmel_mxt_ts - fix boundary check in mxt_prepare_cfg_mem
Date: Sun,  7 Jun 2026 12:00:01 +0200
Message-ID: <20260607095735.419454606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit baa0210fb6a9dc3882509a9411b6d284d88fe30e upstream.

When a configuration file provides an object size that is larger than the
driver's known mxt_obj_size(object), the driver intends to discard the
extra bytes.

The loop iterates using for (i = 0; i < size; i++). Inside the loop, the
condition to skip processing extra bytes is:

    if (i > mxt_obj_size(object))
        continue;

Since i is a 0-based index, the valid indices for the object are 0 through
mxt_obj_size(object) - 1.

When i == mxt_obj_size(object), the condition evaluates to false, and the
code processes the byte instead of discarding it.

This causes the code to calculate byte_offset = reg + i - cfg->start_ofs
and writes the byte there, overwriting exactly one byte of the adjacent
instance or object.

Update the boundary check to skip extra bytes correctly by using >=.

Fixes: 50a77c658b80 ("Input: atmel_mxt_ts - download device config using firmware loader")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260504185448.4055973-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1477,7 +1477,7 @@ static int mxt_prepare_cfg_mem(struct mx
 			}
 			cfg->raw_pos += offset;
 
-			if (i > mxt_obj_size(object))
+			if (i >= mxt_obj_size(object))
 				continue;
 
 			byte_offset = reg + i - cfg->start_ofs;


