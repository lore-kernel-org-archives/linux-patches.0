Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9194F96CB;
	Thu, 17 Sep 2026 17:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664845; cv=none; b=DC6o82OHWnyGjoQiCBI4/Hyx+Qr6lMELs9YmpP5UzoNyAdEAAZWNgJGRdTP3ggqxwHEr3BDFO6dEPvhf5+nsftgOfXkY3Ce1P5XfhYremdGeGU7UfjtmJ6IvP9pDzKIYM/WEggoZd9TCQJDz5kB5ROgZoaWMZYmtfyMJe/yJW0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664845; c=relaxed/simple;
	bh=6E0FPNjNfa87/MDRr3OXzqE/UVD8rGGSk1RKngNrOI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4p8VsShrtKhDX6u6a/heNtP6B2xqLVm00HdAad0PLXJEJx3ZHw1ZCJmet7+FWfiLXVPQdbl8q9OP3ZGFAQqKMKAcc72I0tvNWB0waN/x7HGYT/WwGIVmvq2+aFFUBy/fzPq2FKCnQgEqXjImwk72m0C54Y++ir0TZlRYXemHEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOOy1Xxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOOy1Xxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6051F000FF;
	Thu, 17 Sep 2026 17:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664843;
	bh=mb05EITSdl9m2HLfBQ66Sm03WVFSzmuyCLEIhTz2B+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOOy1XxvQ8vNrhJO+kPx6367ksfV955fnHy4+Cw84OadSTnxkXfca3FM9B/EQ3Cbq
	 +Hki2nyhGIWcRp33ujeLKgfX37CqwZuHBMC0/wSDz9Q425VqxxyudPLQxvRBlD8rjQ
	 /yx+K7xv13K0BFBLSmIQztjnq5LBs9RO0AglGV2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianze Shao <shaotianze@outlook.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0506/1250] ASoC: rt712-sdca: reset codec at io_init to fix silent headphone
Date: Thu, 17 Sep 2026 16:05:01 +0100
Message-ID: <20260917151605.673975881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Tianze Shao <shaotianze@outlook.com>

[ Upstream commit 4c9854ad3cdc7ce408453207f153bb910cc6f3c1 ]

On ThinkPad X1 Carbon Gen 13 (Lunar Lake, RT712-SDCA version VA) the
3.5mm headphone jack is silent after rebooting from Windows.
rt712_sdca_va_io_init() gates rt712_sdca_calibration() on the persisted
vendor SW_CONFIG1 flag, and io_init writes SW_CONFIG1=1 at the end
regardless of whether the calibration succeeded. Across a warm reboot
the codec keeps power, so SW_CONFIG1 stays unchanged, the calibration
may be skipped, and the retained state can be invalid, leaving the
headphone amp disabled.

This patch mimics the reset sequence in rt711-sdca.c, it adds an
rt712_sdca_reset() helper, and calls it from io_init so the codec is
reset before initialization. RT712_PARA_VERB_CTL,
RT712_HIDDEN_REG_SW_RESET and RT712_HDA_LEGACY_RESET_CTL are already
defined but were unused. The reset clears SW_CONFIG1 and the analog
state so rt712_sdca_calibration() runs from a clean state and
completes.

Problem reproducible: boot Windows (headphone is good) -> reboot
to Linux (silent).
The reproducibility may depend on Windows' behaviour.

Signed-off-by: Tianze Shao <shaotianze@outlook.com>
Link: https://patch.msgid.link/TYCPR01MB872223CB999D2099A5E0F58DC4F62@TYCPR01MB8722.jpnprd01.prod.outlook.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/rt712-sdca.c b/sound/soc/codecs/rt712-sdca.c
index 0ebaae426e73b..d8b40663fa92f 100644
--- a/sound/soc/codecs/rt712-sdca.c
+++ b/sound/soc/codecs/rt712-sdca.c
@@ -1849,6 +1849,15 @@ static void rt712_sdca_vb_io_init(struct rt712_sdca_priv *rt712)
 	}
 }
 
+static void rt712_sdca_reset(struct rt712_sdca_priv *rt712)
+{
+	rt712_sdca_index_update_bits(rt712, RT712_VENDOR_REG,
+		RT712_PARA_VERB_CTL, RT712_HIDDEN_REG_SW_RESET,
+		RT712_HIDDEN_REG_SW_RESET);
+	rt712_sdca_index_update_bits(rt712, RT712_VENDOR_HDA_CTL,
+		RT712_HDA_LEGACY_RESET_CTL, 0x1, 0x1);
+}
+
 int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 {
 	struct rt712_sdca_priv *rt712 = dev_get_drvdata(dev);
@@ -1876,6 +1885,8 @@ int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 
 	pm_runtime_get_noresume(&slave->dev);
 
+	rt712_sdca_reset(rt712);
+
 	rt712_sdca_index_read(rt712, RT712_VENDOR_REG, RT712_JD_PRODUCT_NUM, &val);
 	rt712->hw_id = (val & 0xf000) >> 12;
 	rt712->version_id = (val & 0x0f00) >> 8;
-- 
2.53.0



