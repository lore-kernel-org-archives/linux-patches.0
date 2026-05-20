Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96993FE36A;
	Wed, 20 May 2026 18:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303071; cv=none; b=e21kPHhzo/NSKuroqbg5Wd7pmld6/btEc6Sx1VwRvnre35k461z1SkY2Plax6ZtsPe1mfubu07ks4+Np+NZJPeM0jxeXyp16K0Xed/1XiB4//yKZ79aTYfxkQQAyPJjRoNfNGNsk0AmLya2/8KAXYVGNDUYK3WoYtSYUtx3Bqk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303071; c=relaxed/simple;
	bh=rU6BgKgagahF4L5NJhVBEnCPnM53VDjdcPsYhiz7tlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odsNLaspAWc/z77A9VjvMarv29L0P+yLMjZpIHi+UMXStpDYsUocm+9D4R1qY5Byu3Zgw1SJQLyqETo9MDCixjGKlOuaafGs07oTdFMFjXu3jKOzzavUzIE97pK60uqGiYHmW0FHQlb/fvfZ1I/lYOPpBGBdvlZWMsVLRNVLF4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vumWzdyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vumWzdyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A96A1F000E9;
	Wed, 20 May 2026 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303069;
	bh=1NNQldjUqXYr4WoLtKrTFfh+dfZByB0FtZQTliBh7/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vumWzdyEYEtKWLYae1uRJUpN7o6fMyCi//i1TT2TmNEQ9cM3hh8COPoB9d7//ZmY9
	 D54odqJ0YcDuWVGvEbzaN1je7gzgjvhPvTr4k9jyPkyYAWxEp3MJ7hQxe0GsiybnMY
	 OFNZ3/xVoqyGLOdHM5iXwwtdpkRIDQiqNpSeJVJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.6 481/508] drm/gma500/oaktrail_hdmi: fix i2c adapter leak on setup
Date: Wed, 20 May 2026 18:25:04 +0200
Message-ID: <20260520162109.014833215@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
@@ -579,6 +579,7 @@ static int oaktrail_hdmi_get_modes(struc
 	} else {
 		edid = (struct edid *)raw_edid;
 		/* FIXME ? edid = drm_get_edid(connector, i2c_adap); */
+		i2c_put_adapter(i2c_adap);
 	}
 
 	if (edid) {


