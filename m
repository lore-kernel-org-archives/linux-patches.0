Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407F338D6A2;
	Sat, 12 Sep 2026 14:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224568; cv=none; b=n3M98h5oQ51p/vrZs9mnVc4rkaRZNgZygViODFG39KFMyLI0g0D/TmZyE9rnbZ4MBEfu4jLHJMSefMyZckR+qsKPEnTz0WkX4XildxBMIwJQAyG8PpfIubDE+byNMbHu0w9zluXY4iybbTwQHrxvylCssczLvV7HqJ7jCitZpEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224568; c=relaxed/simple;
	bh=xQ9i8eMv4Druw3ubUe7+z2qccn4JI0aWdC+/zL1n8rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgiSvZDc10hqq9oNkY0ZabMFzK3WLbjxjmYSvneJnzeJyEU571//oeNoR77QRvs38byo8d1Af0TKQ28Yqb0yocBgOttmMHVGpsQa6NyL8FizO95pELqRYOiXW0Xfg0LKQMfMklxi8m9HENGrf47k5CR7QcYF5enYbVU3msgV4UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1wMrEiF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1wMrEiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1033A1F000FF;
	Sat, 12 Sep 2026 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224565;
	bh=QmSeyyS9qffRbF7G29zxekcjHok+KxtgBQOyYLsy8y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o1wMrEiFLgP3eMpg/vn9jiwwRW/a4yz1cxdOTIP/rAnPxAR64+SzA87NRqdlauhVW
	 ZAKwvChHLiIlFItHGdNITaE+1VD9sTv80QrQjqx+QB27Xr24JOhBLwmobAACP/9IbC
	 wpUZKI90ZhW/C7qvwPd4hLvlH2ywLhFM7W8lUJW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1019/1424] HID: i2c-hid: Switch i2c_hid_parse() to goto style error handling
Date: Sat, 12 Sep 2026 08:57:31 +0200
Message-ID: <20260912065630.131397014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ef7d20484ded..ed92f7be9adcc 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -764,23 +764,21 @@ static int i2c_hid_parse(struct hid_device *hid)
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



