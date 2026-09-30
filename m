Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0C04DDB2B;
	Wed, 30 Sep 2026 18:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793495; cv=none; b=p/qVx88ARBMvBP6lrgIAzB4s5WqZNHZHECiFen7loImEAeUqvqBU355C4rbZXRR/mmu4xxXfBluWgzTY2IWetfRpYZwOIv+A2fPovifD7C+CfoJVE0F8dEYQVaOKe1/YFeCcpGWqy+0hMjQWq1FLA0qa6tms82IpCUusowc5rAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793495; c=relaxed/simple;
	bh=A1gRtqj+n2muNEoXWMq0hSOKZJx7FuuIjbaER639dK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUufNvQ9xRRcY4rNf1Tqk/BuMRBgbADz6i7HvTr7sxzBEjyupxee6HXrqGUGX6G8NnOyNyaRE/b2yX6tOHBDQNphGYRUEJfYBH+Rg+Cx1E/apPQfRH8u+UFwtu7xxCx6HjU+Gw45kA64ywRy0rXK2LXYiKeUqMEg6lfHJsjWInY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIVed84R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIVed84R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999D51F000FF;
	Wed, 30 Sep 2026 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793492;
	bh=R1MAzSyEcYJpUXVMWZ/cgJ3+CgcSHJ8TkWL1kV4YYyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIVed84Rb6mBr2Q8aih1nLeZ1A3SioIWEOVqVeXJGRcm+VzfeKAZ87Y0FenAKs/mN
	 pZ16jZkTXG+t6s04DGmamysRnUu6Z5OLL6TVw3IMNu7iTApKtodcAuf+MXiU3V3GGl
	 Fr0DNu8q39FQc7vnN1lN7tArY97qDbiu5d7f1/uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 267/395] HID: alps: fix use-after-free on input2 registration failure
Date: Wed, 30 Sep 2026 17:28:49 +0200
Message-ID: <20260930152346.446090008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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


