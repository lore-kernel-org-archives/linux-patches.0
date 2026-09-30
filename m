Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1265187F2;
	Wed, 30 Sep 2026 18:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792600; cv=none; b=csI54K2xPIG9clDqteHeyyLpj2KT0tWajN8m5Kwf+1PR2cq8mJSqItOan4UPml7+eflXoBIApboSbpCqUcBWw0o+IV/80vrMNVcWmwDIGImxl9uU/oJIBBFYNJMMiFbVKRDE++LzSndrC2wb8GWoA+Acw8gfX8UvqFKudo+Xy5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792600; c=relaxed/simple;
	bh=Jfs2NlsbVysTwggML7uzSFUbycWT+86HAp1rou68fSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/PfsYcBxSjRvRiA78K+KxwvIA+1iQFkAgpMgo9baLo44K5tAe1AXMFZ7Hbh+Gw4WLhAShizkky69X0Xv4bsH+W21dTs7cQbIqdCW2Sn9GlWPx2Pht64ZI5/apxEy5hXz0HhZ2ncAIM4EBibgYvkfx804/8v1NIJfbMtvtO1b2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJ/EImh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJ/EImh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733631F000FF;
	Wed, 30 Sep 2026 18:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792599;
	bh=cHchR0m5otfOYCXllnAsVYgqwkbbgVhQK755hfWUflY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJ/EImh391+qYOgxvMnzghNXwp71APagKamGVFnBa6BF1LqsT16lB52RWuwJJrBky
	 ARgdBPzFfZeW3iRQS+nZ2lyd30XPMOBUlSzQY8u17cyBJAHfqeakfBK4oXOC7DgQGu
	 U4O/S2NYg5ThM7rUzszGBsNs4d2HoGLsqrhTJ3Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 713/752] HID: alps: fix use-after-free on input2 registration failure
Date: Wed, 30 Sep 2026 17:29:43 +0200
Message-ID: <20260930152413.656646532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

commit d3aba3442798ce4a4c8ce3104d7b286d61e605f9 upstream.

alps_input_configured() stores data->input2 before calling
input_register_device().  If registration fails, input_free_device()
frees the input device but data->input2 still points to the freed memory.
alps_input_configured() calls hid_hw_open() before allocating input2, so
URBs are already active and raw_event can fire during the failure window.
A U1_SP_ABSOLUTE_REPORT_ID report arriving then causes u1_raw_event()
to dereference the freed data->input2 -> use-after-free.

Fix by only storing input2 into drvdata after successful registration
and adding a NULL guard in the raw_event path.

Fixes: 2562756dde55 ("HID: add Alps I2C HID Touchpad-Stick support")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-alps.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -407,6 +407,8 @@ static int u1_raw_event(struct alps_dev
 		return 1;
 
 	case U1_SP_ABSOLUTE_REPORT_ID:
+		if (!hdata->input2)
+			return 0;
 		sp_x = get_unaligned_le16(data+2);
 		sp_y = get_unaligned_le16(data+4);
 
@@ -738,7 +740,6 @@ static int alps_input_configured(struct
 			goto exit;
 		}
 
-		data->input2 = input2;
 		input2->phys = input->phys;
 		input2->name = "DualPoint Stick";
 		input2->id.bustype = BUS_I2C;
@@ -762,11 +763,12 @@ static int alps_input_configured(struct
 		__set_bit(INPUT_PROP_POINTER, input2->propbit);
 		__set_bit(INPUT_PROP_POINTING_STICK, input2->propbit);
 
-		if (input_register_device(data->input2)) {
+		if (input_register_device(input2)) {
 			input_free_device(input2);
 			ret = -ENOENT;
 			goto exit;
 		}
+		data->input2 = input2;
 	}
 
 exit:


