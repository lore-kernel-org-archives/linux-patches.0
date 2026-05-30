Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E65B33F5A0;
	Sat, 30 May 2026 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162180; cv=none; b=cqYSzTRmuuXN6QzdZffFAczOJogXxAD5YzBRITIGmBwz/4vMVpW2HuLLZT8g91GF6oJSVSBxwM+9UWZHoTixW6g5tC015u3amUzFkjIV3/5HBEWtYE5FnoAj3sB6JlrivonC6y+PuDK95ktb3cq2cGmBnF7V1FQBk92QY5gBtbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162180; c=relaxed/simple;
	bh=DoTtJtgSvbxBlLQxb70TpzGia4gNFHIdcOmQdBJfgKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wh7tk23+8omVIVURy2DwyyJXhC7ubfDpuyFNOydkdvx4PrvIGgTUsAOnvsYNK7kpNV7qvYoFdOeMhcO24Y3kKZlc8/puvrzbXiqAFQwpPVV9aBKFQ7crQq0bJsaUTjF6t63rBS6Wowpt56QlWMr8JbUG/X+Kj7ohriWFZnWh9EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeBVf0KP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeBVf0KP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7289E1F00893;
	Sat, 30 May 2026 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162179;
	bh=kORUTihLBkOExaBxi9u+C3f8a9lYJT5rp/t7s/MGzys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZeBVf0KPtFyTeXuRRwRQXZKLMG3B4Bq4GWJ15p4vnwY6EuT2flxlv8V4k4IY0JDLb
	 5GyMLC9FJnHI7wDlLQDTjPWmhqlwnWHXEG65f8k3vcUpeAnnKwTCytFG41gF2BgWfJ
	 B9LnnRVx0oRMRcy7Zt940wHy3G1WKuSBxw3ym+J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.1 827/969] drm/gma500/oaktrail_hdmi: fix i2c adapter leak on setup
Date: Sat, 30 May 2026 18:05:51 +0200
Message-ID: <20260530160323.479144588@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 950953f774b3f69da6f413e045ef075e1f3da2df upstream.

Make sure to drop the reference taken to the I2C adapter (and its
module) when setting up HDMI to allow the adapter to be deregistered.

Fixes: 1b082ccf5901 ("gma500: Add Oaktrail support")
Cc: stable@vger.kernel.org	# 3.3
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260508144446.59722-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -577,6 +577,7 @@ static int oaktrail_hdmi_get_modes(struc
 	} else {
 		edid = (struct edid *)raw_edid;
 		/* FIXME ? edid = drm_get_edid(connector, i2c_adap); */
+		i2c_put_adapter(i2c_adap);
 	}
 
 	if (edid) {


