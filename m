Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708BC2FDC49;
	Tue, 12 Aug 2025 19:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025279; cv=none; b=Be7nVgFf7Q8jXVWZrVe5j4szgMrxEDoRCObHzNgWvkFvL4a0diVdszJsWbrT8ktSCFBypedjzp1kBgMrI4Uw1FppG2W0pM32Oif/3+FXosxvN3YYwHtISkbJhpNbJPiBwzW4pqZuCaZOuTKUjMLvA+//pN/+qnzmFTzfeBDcwQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025279; c=relaxed/simple;
	bh=b73FeTSqm8ft1DXt0aE35HkCgc/0FmonDO4zS3NDUNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4ZgKeHuA+YIdFA2IPyLeN10mkQ+V3RRfTuDf2cWUlbmN/pe+rzxNPEPSRDt5xALRlXGqevfhBDqpJW7MkiOjhswuWjpuwoar7ZKR6gm+3C94QDkEfosRk650uJsuPIzJiWvbBqVQTXGPULxYZHB6pjCop82Bu+GRu5jNAjL3jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWKzZEeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWKzZEeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6529C4CEF0;
	Tue, 12 Aug 2025 19:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025279;
	bh=b73FeTSqm8ft1DXt0aE35HkCgc/0FmonDO4zS3NDUNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWKzZEeRl9+7GBbC3jyii6jtc/SqF4A0KbeJMBKecTBQ1M/CrK+NeNRBj2lhajpd7
	 YN+HgFEwSSo1TyK1CuMq+r4iPTdMKgn1P5CLvQffTFEdfiHyqTLytbOjIxZylHeUrz
	 00DTYlYPL2lY6cc4dNhnjNN6X/9dODQRTqe43INo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.16 622/627] HID: core: Harden s32ton() against conversion to 0 bits
Date: Tue, 12 Aug 2025 19:35:17 +0200
Message-ID: <20250812173455.539516788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a6b87bfc2ab5bccb7ad953693c85d9062aef3fdd upstream.

Testing by the syzbot fuzzer showed that the HID core gets a
shift-out-of-bounds exception when it tries to convert a 32-bit
quantity to a 0-bit quantity.  Ideally this should never occur, but
there are buggy devices and some might have a report field with size
set to zero; we shouldn't reject the report or the device just because
of that.

Instead, harden the s32ton() routine so that it returns a reasonable
result instead of crashing when it is called with the number of bits
set to 0 -- the same as what snto32() does.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/68753a08.050a0220.33d347.0008.GAE@google.com/
Tested-by: syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com
Fixes: dde5845a529f ("[PATCH] Generic HID layer - code split")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/613a66cd-4309-4bce-a4f7-2905f9bce0c9@rowland.harvard.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -66,8 +66,12 @@ static s32 snto32(__u32 value, unsigned
 
 static u32 s32ton(__s32 value, unsigned int n)
 {
-	s32 a = value >> (n - 1);
+	s32 a;
 
+	if (!value || !n)
+		return 0;
+
+	a = value >> (n - 1);
 	if (a && a != -1)
 		return value < 0 ? 1 << (n - 1) : (1 << (n - 1)) - 1;
 	return value & ((1 << n) - 1);


