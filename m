Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE4E191F98;
	Tue, 12 Aug 2025 18:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023757; cv=none; b=sQd/FIlz3zT2p2sjpSZwtNHt6N6PxHOIDLaNjqpmWldkz7ltwx6SmG8lm8S2VdcRYNCmnG9Uf+i3Jq7eEtoWlxGUTFf6+RG/K86NkJufuFvjSiG4a2MxbwxByku/BeyW4yQvtvayNsowsHnnCEJFKApjcxJAFLy4qSBItKzW5Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023757; c=relaxed/simple;
	bh=m90vc4FxuklknpqH66ddUpXvtYViKW/N3Bd7VAyse8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGF2pFYRKzDCX4YFJ/cyrb1jzfwQ0RkJwekszQMRN1pQBiwPgb9Maj/qGhYqKmraLgDBa9e4axoDEXe+AOvnkB+2jDU4A3q1DUN8dxH4RUOr65LFi5JSaXsxTXxeBFrqXtjVxoU6HxrRLyV2Z3vyxK03XoAOofqpJEHFsPaNYPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpbqs3vJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpbqs3vJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEACEC4CEF0;
	Tue, 12 Aug 2025 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023757;
	bh=m90vc4FxuklknpqH66ddUpXvtYViKW/N3Bd7VAyse8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpbqs3vJxzPima0oGcHZkj7s8sM+Sbw/xp5t0CQ2DgEW1Wu4+iAJN5/DULDSAskhl
	 ZZ6gU0CZ1e+Hy/VXfNO6NjaJEx8rfhNohryU/TuiDRtm37BUfVn8TIFB2FPBczc5y3
	 sjyW6YxUiUEWf/DNrD+tM+S04FYWxjV1AVR/Xxio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 139/627] wifi: rtw89: sar: do not assert wiphy lock held until probing is done
Date: Tue, 12 Aug 2025 19:27:14 +0200
Message-ID: <20250812173424.588592926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit dad7aafa5216e307b357b801668451a3b8945810 ]

rtw89_sar_set_src() may be called at driver early init phase when
applying SAR configuration via ACPI. wiphy lock is not held there.

Since the assertion was initially added for rtw89_apply_sar_common() call
path and may be helpful for other places in future changes, keep it but
move it under RTW89_FLAG_PROBE_DONE test.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 88ca3107d2ce ("wifi: rtw89: sar: add skeleton for SAR configuration via ACPI")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250604161339.119954-2-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/sar.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/sar.c b/drivers/net/wireless/realtek/rtw89/sar.c
index 33a4b5c23fe7..7f568ffb3766 100644
--- a/drivers/net/wireless/realtek/rtw89/sar.c
+++ b/drivers/net/wireless/realtek/rtw89/sar.c
@@ -199,7 +199,8 @@ struct rtw89_sar_handler rtw89_sar_handlers[RTW89_SAR_SOURCE_NR] = {
 		typeof(_dev) _d = (_dev);				\
 		BUILD_BUG_ON(!rtw89_sar_handlers[_s].descr_sar_source);	\
 		BUILD_BUG_ON(!rtw89_sar_handlers[_s].query_sar_config);	\
-		lockdep_assert_wiphy(_d->hw->wiphy);			\
+		if (test_bit(RTW89_FLAG_PROBE_DONE, _d->flags))		\
+			lockdep_assert_wiphy(_d->hw->wiphy);		\
 		_d->sar._cfg_name = *(_cfg_data);			\
 		_d->sar.src = _s;					\
 	} while (0)
-- 
2.39.5



