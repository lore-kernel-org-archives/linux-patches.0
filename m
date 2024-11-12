Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBA821FDA6;
	Tue, 12 Nov 2024 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407831; cv=none; b=ce1kHN9yPLCMH5m8kMxE+jdFjsF6Wr8DjWn+pWmXiuCGsmGQqGJ8iYhPah7SVYYCLAsuwdiOQ89+xx6duu3zuBgP8aDSEf/NAOk5CkHmrWLgBRUZdZUqnGpjxU8473fPtjpCnulYw6h5uPejbsah2aNCn+rfeD5Y6gX65gMO7GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407831; c=relaxed/simple;
	bh=U9b+eLc1tjJsqUG05GH1DrP39BYXsnMfYA8c50U/PfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqhPq23zRDFg53DZ5Io58iMJSR/sw7ei4SXKJzbyW7SoVstaobcsUeCJieyusLVakFd20W/YgWT0c24bOqmUwgdF+p6SGQyxIlZlP01Ve/f2o9trpCuWL2Qke4VR7oujYKFEocrdGmyd3dNdQNzqGkMqbXcd132eUhMzYW9CGFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6hl/HjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6hl/HjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813A1C4CED7;
	Tue, 12 Nov 2024 10:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407831;
	bh=U9b+eLc1tjJsqUG05GH1DrP39BYXsnMfYA8c50U/PfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6hl/HjIQygltgZaCa0KldLgQQv3OTB69U+8nbGYjDT61fy/xoqC4M4e6aO/8pEzz
	 o/OmnQGJZkv4ehG5pQoYr8IdnibyRQaH/6ArSi6+d73Vs9O+hXa41Rfm+pCcx2h1eO
	 JDQqwq7Z50PVBXUPYX/nYWqvpYFeEuZnSCP3PTlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 064/119] media: pulse8-cec: fix data timestamp at pulse8_setup()
Date: Tue, 12 Nov 2024 11:21:12 +0100
Message-ID: <20241112101851.159843420@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit ba9cf6b430433e57bfc8072364e944b7c0eca2a4 upstream.

As pointed by Coverity, there is a hidden overflow condition there.
As date is signed and u8 is unsigned, doing:

	date = (data[0] << 24)

With a value bigger than 07f will make all upper bits of date
0xffffffff. This can be demonstrated with this small code:

<code>
typedef int64_t time64_t;
typedef uint8_t u8;

int main(void)
{
	u8 data[] = { 0xde ,0xad , 0xbe, 0xef };
	time64_t date;

	date = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
	printf("Invalid data = 0x%08lx\n", date);

	date = ((unsigned)data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
	printf("Expected data = 0x%08lx\n", date);

	return 0;
}
</code>

Fix it by converting the upper bit calculation to unsigned.

Fixes: cea28e7a55e7 ("media: pulse8-cec: reorganize function order")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/usb/pulse8/pulse8-cec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/cec/usb/pulse8/pulse8-cec.c
+++ b/drivers/media/cec/usb/pulse8/pulse8-cec.c
@@ -685,7 +685,7 @@ static int pulse8_setup(struct pulse8 *p
 	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 4);
 	if (err)
 		return err;
-	date = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
+	date = ((unsigned)data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
 	dev_info(pulse8->dev, "Firmware build date %ptT\n", &date);
 
 	dev_dbg(pulse8->dev, "Persistent config:\n");


