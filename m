Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE2B4F6480;
	Wed, 30 Sep 2026 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783922; cv=none; b=MnozlTCieibiBHrB9vKKQa1SNZyPACVIMvbbpf+RQBOGYkNqcZ8kHnWsCY29wUvEwDlUIDamsu96pGaosvWqzNyXpTZArxWU5SAM5Pu7lF9LGqJUjK/vG5GhYbSP/TKJT0OvuFOmk0BUcHUBe9ulpPYeBrrImQNJGeqPoJUafnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783922; c=relaxed/simple;
	bh=7pQscFbvd0k+INDM4VhL1wFH4h85gx8vHgfiJYn3BJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpw8iQVv3timfYW2NBI65HuXSIKHuYuebX5EZcV/+UdJCthKL8QOw0ZZ4mzjrx/knNJWN+lP9fcvdVJKXe4JUpZrQcBSYh1/Lc1la69Gcf8zBoccBo/UwtHoQgwGx59Ty1jzSr09l3OmKlTdJzfS9NHwcel9wtAUsicBDjLxZoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BX7V7X1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BX7V7X1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5897C1F000FF;
	Wed, 30 Sep 2026 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783917;
	bh=a6z8CDODLYCFnU7JR24q4etgf1K9cbJWABzkWRNRKUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BX7V7X1aBLhrg0nP7GfvSAPPdPottFx2RyZpzG4yiBHY8cfvLv8oRu0dPwn3QjnVt
	 3WtPg/Opckb0+AZ0Jf1blimutBnDrrToBmhYFvAGSiHeQtby/I4XLyxEYOJ4BAafHQ
	 TbJ1IeHAWIZWq5uZE6t6guRCi+uYXuT7I8fXqJIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 568/595] HID: alps: fix use-after-free on input2 registration failure
Date: Wed, 30 Sep 2026 17:27:41 +0200
Message-ID: <20260930152359.941576563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


