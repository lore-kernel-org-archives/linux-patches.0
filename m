Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4DF39022B;
	Sat, 12 Sep 2026 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242948; cv=none; b=oHIRbyLvlvmmjpi88M32gR3vU1dXSd6wUVF97Q9Us1YIGd7oHSPQbGqrIeL5Fn+YvmFiPo3+71xiZC7MTeYSrK5Q3cTkNdPtmdha4WveWWqFLPd95p0DX2/nzoH00Y8bqQ3zzfkwD7jSfEh2iifqNp5rk5JONSd8+9wlmvAeoCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242948; c=relaxed/simple;
	bh=qQzdGcqOvont77XfuYOpfJHjKL5iAfCTXOIYn6AsBuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0BbVbf6CsNIwQtn0WDUqK0tWVgUpf6IdSGSyO8Yh02yetHy3c6wWAM6izSkwlINPm62mRWssidXWhS/P2BeFiTUJvUrn9KJ2/o1UkUGbKV6ktwCo32zbIeJFRUN+/cBUDWTzVOBjv/r5KWXCVJXS6+uE08iQvgtNFeQSNBHPJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSCpytAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSCpytAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CB81F000FF;
	Sat, 12 Sep 2026 19:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242947;
	bh=n+Bt6WVsT9fHPNw1FAOeyrhtL/OpjU1TU5Z/toB1FdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSCpytAk2l87nc2voq9LvSXTjakl616t3xSoa9o7M4l38dHPD41zh4DYly+F/0xAE
	 5JZ7ybseEh/cOQtGLf9J/KyTx9nVJ0LUB2JwwY8Up0Z7xX7uY2VkNwfr+1xntaHuYf
	 1wswso5+4GS0RvceVvbJ+4xbuwjRlI27hyT+m6NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 583/798] HID: i2c-hid: Switch i2c_hid_parse() to goto style error handling
Date: Sat, 12 Sep 2026 09:03:31 +0200
Message-ID: <20260912065530.489472875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit aa69d6974185e9f7a552ba982540a38e34f69690 ]

Switch i2c_hid_parse() to goto style error handling.

This is a preparation patch for removing the need for
I2C_HID_QUIRK_NO_IRQ_AFTER_RESET by making i2c-hid behave
more like Windows.

Note this changes the descriptor read error path to propagate
the actual i2c_hid_read_register() error code (which is always
negative) instead of hardcoding a -EIO return.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 8da0f0951dee ("HID: i2c-hid: Fix "(null)" output when reading report descriptor fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 4f8e8f392daba..f60e24559f94c 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -753,23 +753,21 @@ static int i2c_hid_parse(struct hid_device *hid)
 				      rdesc, rsize);
 		if (ret) {
 			hid_err(hid, "reading report descriptor failed\n");
-			kfree(rdesc);
-			return -EIO;
+			goto out;
 		}
 	}
 
 	i2c_hid_dbg(ihid, "Report Descriptor: %*ph\n", rsize, rdesc);
 
 	ret = hid_parse_report(hid, rdesc, rsize);
+	if (ret)
+		dbg_hid("parsing report descriptor failed\n");
+
+out:
 	if (!use_override)
 		kfree(rdesc);
 
-	if (ret) {
-		dbg_hid("parsing report descriptor failed\n");
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
 static int i2c_hid_start(struct hid_device *hid)
-- 
2.53.0



