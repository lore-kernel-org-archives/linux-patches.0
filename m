Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4A528E0;
	Sat, 12 Sep 2026 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230660; cv=none; b=GaJFx/oJmjTMDkdMqgS/4W9d8K+lD1l/vCCL5LbNgNgZvQGKWHk5Hx9eu6ZTUoJngSQ4txtFqzSjvk/FhJ5hMFw+bZeHfxdnm70vCES3jd1vkPN1loSg7E7ILG75uAp6y/A6o6vTO3bGpbGQRqliO+Q05Ns2sEJbk0VXqMP7Vqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230660; c=relaxed/simple;
	bh=hTdXoidpd3GdZeZcaGzpWts0nB9eqo2cWNoWDdgWurs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjR9mT96TA3n6Vomksq+NooBcHGUq2XWDuqNhbQzH3eaZsAJuxt2GhZNMbjH+wuhFcwyI7fDMO8fycFTeT5FKZc71+RWBpMiIG5Z+VYZL9zItcYPWHycE2zGaniMloenEcOeM1ZxdzkM4n7dhKoGnKBmvsaVlohl4mnkPCpjtRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqV+nums; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqV+nums"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB03B1F000FF;
	Sat, 12 Sep 2026 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230658;
	bh=jnD5bINQPI8TlqD3gLMpgVdHI+Zv6xb3c3KDK8VugZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqV+numsU+/80NJTgpQQ4J8i6WjHqjtpSl0qaFcVgDIWS2jnwTjN0SemaD3rS20Eo
	 qWvUyuXXdwAsk/kmLmJu5gI+3fKkCiddYWViV71eHPCRiXtsFhrzyyKuhVL8E3NKpQ
	 DNMmazF7+a9WHZ5EftJEYvY4Lmrjpll7YdmLnEEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0840/1191] HID: i2c-hid: Switch i2c_hid_parse() to goto style error handling
Date: Sat, 12 Sep 2026 08:59:28 +0200
Message-ID: <20260912065607.125687442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4d59ddf2c1b04..a198b679c7902 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -755,23 +755,21 @@ static int i2c_hid_parse(struct hid_device *hid)
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



