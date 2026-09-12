Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB2547AF5C;
	Sat, 12 Sep 2026 19:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239624; cv=none; b=o9CqKsSeBII0kwd82Q7H8wi1nNacdt8Gdgyx91Q/g6B9Z0yTYXNafW/NAZIZ7I6y3rTDtlXpaliQQ2ZXapoISUpFmn7fjEsbNW/8I3ZjBiO83RoMtR+6Sv31yn/kUUyWQJ10QuyPpghpnYwcgdPGq94Lv5w2I6nROP3KYwiSxLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239624; c=relaxed/simple;
	bh=nYuZOirhn2X0irdSEve0eySThTYbbeIxOwkn8ecOiw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NekApnxDmC19kCXMZDHx6dhT+UV9ssnpzODCp0gUb5MI5FWlv3yP4rxW3jGbdaivL+yUp9SkIeCC1kSdcOzTUDt4Aq8Ayz2EPU8t9830HZ/QpcfUvO4RqIhmZLvXtjIqWZmKhlAJIiUoCYSITUlaIF94TOolL97QlZz4TYcjAgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJ327FWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJ327FWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB37F1F000FF;
	Sat, 12 Sep 2026 19:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239623;
	bh=WSyQ4LON8W1NJssE1CfSpaboHGklsymgpKik2YtWvb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJ327FWXLVed7Lp0vnqQhHd4IOWbXCzDNspqtd6SOJgXcZn22b2ve1iiUb6Il1nLi
	 nlPnhPrXSe251wNCtBll264WCAfSVgvT/VJspZUoHjCSmUaiAEJtgbHO6iH1/RbOg/
	 GQEffrrdULHCEFwuFgCFpgSP1P/4JdhjXR8wq088=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 675/935] HID: i2c-hid: Switch i2c_hid_parse() to goto style error handling
Date: Sat, 12 Sep 2026 09:01:45 +0200
Message-ID: <20260912065542.323035427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f8c56810d260c..69831b5b0a19e 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -748,23 +748,21 @@ static int i2c_hid_parse(struct hid_device *hid)
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



