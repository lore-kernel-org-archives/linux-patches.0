Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829160;
	b=qTZ65eaxxy9JsLMI+fP7e8aEQ2ISkIzxuq65pwrzEflwerILkyqO8A+okhp9wRe9Tdso
	 WuDBO4gi9EVXGV95okvvZHFBHMtnURBGLwDwdc2mp4ZKxXNlCPX/bpVNIB0dy72ODFzvm
	 Geh+ES39AbvTltK6MlGxdUi+JbBt9hk5exIPNv9iRD1MGYe6A4FBam76qVd/iuzQOuDrQ
	 6QBw/6UULbQDObTF2u/gak0VxUZb0juEtp3Bnww7vJmlFCtz5nbO7M5NmH89MOJXYSd4P
	 7/Ok2yMU15HEPEDsapWMPfJ502g09ssiDgCdU5nyGi0w92CPAbUzFPnIo+yEisUz6JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ulq+jjFLxxBIlPyuVOc0Ql2O+DMssuc0bswrieQorqU=;
	b=pBtXrZvrQHZcFJxsAHY7H7OGn1zO/Uy0iATs7PrKyPMlsX6crkvgjwxq8gayk0jZ+1M6
	 oZBiYQfssq96DTXdUYXynlr0BFM2IRXVBuxmPD/hmBxDL7tFyYxuJR2uVFWUTz+MmOI4s
	 xwHls85j/I4Em6NIXeyro/OiRY1twY8QEUokOZ+8yqmhJsIxGfBhynHwmyO1m2K6XEYgJ
	 JoYsZ1NYcug1+1d79tNoliLCPX8pazmTaql9PuicFPTSm8kfK7MLnB6kDZRvmuFebkNHO
	 Re+GkCaF0jhhaBpnqwn7/kswO5sruSzeCieXIs0lE1fzhXIUf0bznqxdYMBLeDqmNLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vu7ywn7D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8BD607031A;
	Wed,  4 Nov 2026 21:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vu7ywn7D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D143C1F000C1;
	Wed,  4 Nov 2026 21:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829160;
	bh=Ulq+jjFLxxBIlPyuVOc0Ql2O+DMssuc0bswrieQorqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vu7ywn7DRZPNJG15V1v5cgqKFy2HyG/Yvix7sala/AI+TKLTMAM2pmVmFG7OAfH6g
	 NG7wFUbuozeVZlA2+TbKGxVTbiu5r8Ymqa+cmBQiNyE8dOnQ4WuLAZgMQIPRec7XDX
	 RNbF6/8oOzTN48dP9tjK0FegqwvOMutR1vvoLkRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 484/547] HID: zydacron: validate key report length
Date: Wed,  4 Nov 2026 16:11:08 -0500
Message-ID: <20261104211052.131540099@linuxfoundation.org>
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

commit 9932c9af185f8586e883d44ca562c12f4487c762 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  zc_raw_event() verifies the report ID in byte zero and then reads
the key code from byte one for report IDs 0x02 and 0x03 without checking
that the second byte is present.

A one-byte report reproduced the issue under KASAN:

  BUG: KASAN: slab-out-of-bounds in zc_raw_event+0x54c/0x580
  Read of size 1 by task hidtrigger/93
  Call Trace:
   zc_raw_event+0x54c/0x580
   __hid_input_report+0x2ef/0x3a0
   inject_store+0x479/0x490 [faketrans]

Require both the report ID and key code before processing the report.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: d0742abaa1c3 ("HID: add omitted hid-zydacron.c file")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-zydacron.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -114,6 +114,9 @@ static int zc_raw_event(struct hid_devic
 	unsigned key;
 	unsigned short index;
 
+	if (size < 2)
+		return 0;
+
 	if (report->id == data[0] && (hdev->claimed & HID_CLAIMED_INPUT)) {
 
 		/* break keys */


