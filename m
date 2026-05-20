Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81343EC2DB;
	Wed, 20 May 2026 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298870; cv=none; b=llcB9+xOdHRidtayVvD9sJXzoCKwug7jtPKymo5vQ7XoYWGLBn64K7Y47LjaiOYKwbip4mBMOcqv7rnThmfC0RlXPRDWorYuHysrY1D7br5pgU5ZXlrPhHjRdvx3DZd4E/WIGgi0FuqbJAVlidqd80CFqoiOTjS2hcQLn8AUowI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298870; c=relaxed/simple;
	bh=OuWwZVSAg6SzfCs1cUKVK+4r9sYElmemmM5o1MN1KYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9UhCEHmYXGnbAmd+BNmkBMBqtUk67Ea6ti/gvAkxMIAdFn82ORnbmdh2s0YiC4xpRqbgwjvyXrRrAaktX0aFrj/h00pr4DaEugwAJ5a1NDBHcXUy3ACb8mxMnT5NP9L6elE5l0qZfK+IN8qabgR388k+0PUAZr2jqL8mEbOduI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGIP9aqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGIP9aqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A331F000E9;
	Wed, 20 May 2026 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298869;
	bh=RGxDTKXnTzb7IjGbfP67BhEDmc7D76iy9c3di+2bctM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGIP9aqftGjg2Hll75EI9RhvYA7g5lUbAEjkbNOcc4d7sTkB9z4iCwgtroDNzkUaO
	 2RWsENTWyyGNv0IU9UjNorJtaUVXKXcNouZYlDxWEMXI6K6F1yF90xos3r6RZtGHxw
	 Abkb+jHXwzjQIX33y6mFzU+f0BpnK7xuIOAGMsV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 533/957] tty: hvc_iucv: fix off-by-one in number of supported devices
Date: Wed, 20 May 2026 18:16:56 +0200
Message-ID: <20260520162146.091744472@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit f2a880e802ad12d1e38039d1334fb1475d0f5241 ]

MAX_HVC_IUCV_LINES == HVC_ALLOC_TTY_ADAPTERS == 8.
This is the number of entries in:
  static struct hvc_iucv_private *hvc_iucv_table[MAX_HVC_IUCV_LINES];

Sometimes hvc_iucv_table[] is limited by:
(a)	if (num > hvc_iucv_devices) // for error detection
or
(b)	for (i = 0; i < hvc_iucv_devices; i++) // in 2 places
(so these 2 don't agree; second one appears to be correct to me.)

hvc_iucv_devices can be 0..8. This is a counter.
(c)	if (hvc_iucv_devices > MAX_HVC_IUCV_LINES)

If hvc_iucv_devices == 8, (a) allows the code to access hvc_iucv_table[8].
Oops.

Fixes: 44a01d5ba8a4 ("[S390] s390/hvc_console: z/VM IUCV hypervisor console support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260130072939.1535869-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_iucv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index 4ca7472c38e01..612e13b6f22bc 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -131,7 +131,7 @@ static struct iucv_handler hvc_iucv_handler = {
  */
 static struct hvc_iucv_private *hvc_iucv_get_private(uint32_t num)
 {
-	if (num > hvc_iucv_devices)
+	if (num >= hvc_iucv_devices)
 		return NULL;
 	return hvc_iucv_table[num];
 }
-- 
2.53.0



