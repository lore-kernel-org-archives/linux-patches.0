Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C706D1F754A;
	Tue,  3 Dec 2024 15:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239640; cv=none; b=IokkqDtcdPpAB4/ffLdRCdBtbMtFTA+tglMYU1X4GEgWGp1gGS0b7/3bfu0qZd02wZdgWMDYFnwPlYU6Yp5IbqxXL7tLsguiZd2FLTQk0+EGPRrZw67bR0xMDOwMvDc9phWgPPWQuexpsnPiyjplNyCXsRK6oDRGyD4VGGiuFVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239640; c=relaxed/simple;
	bh=L7Bi9ai8DtpleX4JIDKO77VuIE7pTPIvXtYKaq8Lp+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGur850AnEZW6HKyXCuTHIZbqLPlVS9ywiODXoFB1sVOgNjZ9BdYpr6M2+2SJ8mSLnvAKTsD+j1AFEkOspbMvDELNdt+1shno2skz13zlQnU4g+mplH334WTew1tm/UCmGg6j5odVPaa6Im5zPrcQJnVgBl+zPxG13gi6+wkGBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewwjTjFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewwjTjFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063E3C4CED9;
	Tue,  3 Dec 2024 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239640;
	bh=L7Bi9ai8DtpleX4JIDKO77VuIE7pTPIvXtYKaq8Lp+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewwjTjFEOJzK/rzIglinx2/fB65gjm4h2lnUZO7OCBCRB5L6djsksLzo8FFq6r1bS
	 rfZCcq5SuPgya+4L05pGjrtd+j8IEjF5bbcfwb9AMHooX5qU+N/JS6JFNPpFAKNumv
	 x9g1zfrwBO0QBOYGZGf/8pyP6eXZgxzqGtLr3qWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 642/817] ASoC: da7213: Populate max_register to regmap_config
Date: Tue,  3 Dec 2024 15:43:34 +0100
Message-ID: <20241203144021.010900443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 9d4f9f6a7bb1afbde57d08c98f2db4ff019ee19d upstream.

On the Renesas RZ/G3S SMARC Carrier II board having a DA7212 codec (using
da7213 driver) connected to one SSIF-2 available on the Renesas RZ/G3S SoC
it has been discovered that using the runtime PM API for suspend/resume
(as will be proposed in the following commits) leads to the codec not
being propertly initialized after resume. This is because w/o
max_register populated to regmap_config the regcache_rbtree_sync()
breaks on base_reg > max condition and the regcache_sync_block() call is
skipped.

Fixes: ef5c2eba2412 ("ASoC: codecs: Add da7213 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20241106081826.1211088-23-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/da7213.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -2136,6 +2136,7 @@ static const struct regmap_config da7213
 	.reg_bits = 8,
 	.val_bits = 8,
 
+	.max_register = DA7213_TONE_GEN_OFF_PER,
 	.reg_defaults = da7213_reg_defaults,
 	.num_reg_defaults = ARRAY_SIZE(da7213_reg_defaults),
 	.volatile_reg = da7213_volatile_register,


