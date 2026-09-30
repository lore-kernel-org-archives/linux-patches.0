Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20FA46C4CC;
	Wed, 30 Sep 2026 17:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789634; cv=none; b=HCmmvA8boWTFwrMb0BCrYSPIp3+F5P0MQ8MhsheI6RA4B2X23UdEjS3u6FE8nA61b2X2eO+r8cAH5uje2PHZdYLL9YYfy2F7kPzuIB9J09fwNnvL2IGYcGXzshmkhKWzraeZ7ulUkqtQlykZXUOyY5jYchGVPD+nzfl9unvnoNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789634; c=relaxed/simple;
	bh=Lln5LrrwP4bMYhLycWTbAWS/ik51w/RFn19zhBoB8ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIQtSpFXXK0e4a79ZprY706m/qYqRGbTKRiVXbQPaHXAfAPI2l27mUPWgMiIcT8hFUIvjmZeoX4gOG81LkmpebxDYAt7MXmFbcBHC+hSN28y2E4CB8dljSUMb6QPuz40ObGlu+iWzxOo+p3e6Ka3RnjQHtHeiiYTu/iY55NU5X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQ6m38FN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQ6m38FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D481F000FF;
	Wed, 30 Sep 2026 17:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789632;
	bh=nUxu9+mVhjGaTAkksS5p+IjRiHnytMljlsQRF7qLMNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQ6m38FNuK9NngSayhAt0DPLAwdOQq4mwhjeI8TShy5WXIbxpfadYxAzOnUYTw5bp
	 p0qyyvRFUekBmi6Nl99rJDT5M2rE+mG3fh4Cc5Cb/CoXutH2K60C20zuCGNVXfKIPs
	 XUOD+FVQRSluAgjsb6rUFT8wne+8VgvDPUs/6H64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 501/877] HID: alps: fix use-after-free on input2 registration failure
Date: Wed, 30 Sep 2026 17:23:32 +0200
Message-ID: <20260930152425.474453262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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


