Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4048118F2D6;
	Tue, 10 Sep 2024 09:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961626; cv=none; b=Ner9hgNKGs55oibpNBcVtTSjrG/FvGXIw+o9Y80+nptMMAdIUvPn26BADgBHJ7CIYRoeSc5LicHiEx/7635RC9B6XFGIKjTNrbJdRZP+Fvxciz8fmGQt02nW9j7kctzCm9dchxlobDZQg5at2k6hyaw4XJjceybsaEpRqOFKJZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961626; c=relaxed/simple;
	bh=2GsOpvStnZ/+EJYi355do8D89gh1TGddlGsFK8swonA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeOUDUZxSba7aQXJhpxchgEGU1QUyAL5N5BeIyoKFqpel7NxEwEGSZzkBkDfTQtM/j7yig6RKw4akEitdqKSvmhpEfo8YYJjQ2/GeHdNhbQIiyXx/kJ4FVpUE6PjhLaXMr31p1grGvQxNU7YOq1+ns5w8ejihkhZWdxlVlaUQnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBG9bddS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBG9bddS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA645C4CEC3;
	Tue, 10 Sep 2024 09:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961626;
	bh=2GsOpvStnZ/+EJYi355do8D89gh1TGddlGsFK8swonA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBG9bddSQUcDBwJO3d2VgjD/JDP6xsdYlxVt4NR31K2gf2TUiy2voaLUPSgprnZHs
	 5CEDp+ckWXfVC9i9kPA6ASRWufhPr1HknT8poG1bW3/2S/9lIFq54ehITFOW0UV/oI
	 XU2rQzu86gAS5xVDiae6CW5isGa67IUJggUYnWsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 106/375] media: b2c2: flexcop-usb: fix flexcop_usb_memory_req
Date: Tue, 10 Sep 2024 11:28:23 +0200
Message-ID: <20240910092625.954199045@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit b178aa6f333b07bda0548d7e45085660a112414d ]

smatch generated this warning:

drivers/media/usb/b2c2/flexcop-usb.c:199 flexcop_usb_memory_req() warn: iterator 'i' not incremented

and indeed the function is not using i or updating buf.

The reason this always worked is that this function is called to write just
6 bytes (a MAC address) to the USB device, and so in practice there is only
a single chunk written. If we ever would need to write more than one chunk,
this function would fail since each chunk would read from or write to the
same buf address.

Rewrite the function to properly handle this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 90f1aea99dac..8033622543f2 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -179,7 +179,7 @@ static int flexcop_usb_memory_req(struct flexcop_usb *fc_usb,
 		flexcop_usb_request_t req, flexcop_usb_mem_page_t page_start,
 		u32 addr, int extended, u8 *buf, u32 len)
 {
-	int i, ret = 0;
+	int ret = 0;
 	u16 wMax;
 	u32 pagechunk = 0;
 
@@ -196,7 +196,7 @@ static int flexcop_usb_memory_req(struct flexcop_usb *fc_usb,
 	default:
 		return -EINVAL;
 	}
-	for (i = 0; i < len;) {
+	while (len) {
 		pagechunk = min(wMax, bytes_left_to_read_on_page(addr, len));
 		deb_info("%x\n",
 			(addr & V8_MEMORY_PAGE_MASK) |
@@ -206,11 +206,12 @@ static int flexcop_usb_memory_req(struct flexcop_usb *fc_usb,
 			page_start + (addr / V8_MEMORY_PAGE_SIZE),
 			(addr & V8_MEMORY_PAGE_MASK) |
 				(V8_MEMORY_EXTENDED*extended),
-			&buf[i], pagechunk);
+			buf, pagechunk);
 
 		if (ret < 0)
 			return ret;
 		addr += pagechunk;
+		buf += pagechunk;
 		len -= pagechunk;
 	}
 	return 0;
-- 
2.43.0



