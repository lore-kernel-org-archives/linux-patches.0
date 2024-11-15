Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD967185924;
	Fri, 15 Nov 2024 06:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653886; cv=none; b=kmqzBxP8d3n/cmkheV2y+OCpZ8ymw3YvfsCxLoJy5LHiZVas0mH+F4UWnXw7yhJ/M5Ro3R2X/y73DE4IHG7r7uOtMOd/F85psjbIjHmWBhw96oPa7i5D3KxgPDSAX789ETa9QGFKyF13tL1Ly2loQWGkfSv5MA8+2NTlpcvy9io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653886; c=relaxed/simple;
	bh=N3tDIAVgXV+6lUo4ixu33LI3zNwfM+Sum/A10oSxkGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBAeDZbCpw7AZ1t3ixad36StHleLteFKMlb2woo98hU3MHE5g2wahRi3QACntiu/ljHrgCKZCuzyMfKmHgQUBOarpDwo6UJpjZ84QkZWyIl+0XqvjZOVA5jQ9+/WjuhYrf8yNsP1nq6uusRFYJO6wqAhAkHwD8U/xyFx1/ZJqH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDTAk/l8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDTAk/l8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AA5C4CECF;
	Fri, 15 Nov 2024 06:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653885;
	bh=N3tDIAVgXV+6lUo4ixu33LI3zNwfM+Sum/A10oSxkGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDTAk/l8gDn1p8sHnk/ophT5+lefb2Rn2tHwt0uW5u1K916Rq52KlWWGU+GFkhye+
	 uLI52WYDyakTOB3hT3sMQLAdi74j/8H00l0NowVM73I5k8hfYlEaW+5dMZtNVjd+f9
	 0QuhtpBGGfG0swgbrbXhOpvEKnS14h1iPWCkmNDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 31/82] media: pulse8-cec: fix data timestamp at pulse8_setup()
Date: Fri, 15 Nov 2024 07:38:08 +0100
Message-ID: <20241115063726.685009417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/cec/usb/pulse8/pulse8-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/cec/usb/pulse8/pulse8-cec.c b/drivers/media/cec/usb/pulse8/pulse8-cec.c
index ba67587bd43e..171366fe3544 100644
--- a/drivers/media/cec/usb/pulse8/pulse8-cec.c
+++ b/drivers/media/cec/usb/pulse8/pulse8-cec.c
@@ -685,7 +685,7 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
 	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 4);
 	if (err)
 		return err;
-	date = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
+	date = ((unsigned)data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
 	dev_info(pulse8->dev, "Firmware build date %ptT\n", &date);
 
 	dev_dbg(pulse8->dev, "Persistent config:\n");
-- 
2.47.0



