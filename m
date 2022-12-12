Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC65628ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81C7C433EF;
	Mon, 12 Dec 2022 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852501;
	bh=B02Xl/Vk+ZCvOu6JD5ou0WLDErMGsFL62UNRQOE5/bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBE9ExHgJpCpAbb2t/W7MBzUoOpKekVHALBH4zFQ2getlJ00qbdNZu4aE0Ef4bMSh
	 ELNgpxtelmEOYjbsmRZK6Rt98OCMyJKIF6SYkO+rtK97OsoONh5vu6M+20TpI8EbZt
	 YXo6HC8xs4OAUuYKnWxXolwcWP8O/evxwRlQDI0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.0 067/157] HID: uclogic: Fix frame templates for big endian architectures
Date: Mon, 12 Dec 2022 14:16:55 +0100
Message-Id: <20221212130937.283092000@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: José Expósito <jose.exposito89@gmail.com>

commit a6f4f1662711bd03308371d9649783a5be596898 upstream.

When parsing a frame template with a placeholder indicating the number
of buttons present on the frame its value was incorrectly set on big
endian architectures due to double little endian conversion.

In order to reproduce the issue and verify the fix, run the HID KUnit
tests on the PowerPC architecture:

  $ ./tools/testing/kunit/kunit.py run --kunitconfig=drivers/hid \
    --arch=powerpc --cross_compile=powerpc64-linux-gnu-

Fixes: 867c89254425 ("HID: uclogic: Allow to generate frame templates")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-uclogic-rdesc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-uclogic-rdesc.c
+++ b/drivers/hid/hid-uclogic-rdesc.c
@@ -1119,7 +1119,7 @@ __u8 *uclogic_rdesc_template_apply(const
 			   p[sizeof(btn_head)] < param_num) {
 			v = param_list[p[sizeof(btn_head)]];
 			put_unaligned((__u8)0x2A, p); /* Usage Maximum */
-			put_unaligned_le16((__force u16)cpu_to_le16(v), p + 1);
+			put_unaligned((__force u16)cpu_to_le16(v), (s16 *)(p + 1));
 			p += sizeof(btn_head) + 1;
 		} else {
 			p++;


