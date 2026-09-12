Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A4E221FD4;
	Sat, 12 Sep 2026 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224354; cv=none; b=Zaq7PGsY/3PkIq+vj7vW1j1mzITeQdjzXB/JBswMJ6cy7rvkAo6NTz0b4bkyE0Q3mHEbx1XUWahgZNDpno2DfJH9l0QvdGuih8EKuegk4zDG5nFRXhpBB9bFB7I914QzA3h8EIoGWbDc9zifvCg/4njlcfDrKpfGhzbbZY0Nhcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224354; c=relaxed/simple;
	bh=a2Ghwza8HzrS9MPyEMGtB834vRtLL4bqy72Ez3WDnss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1G37IGJduwxz39JP82ilShid/0uE3heL0BrwMrWaJ5oyps5pgNkXi2u9WRedFmNnsWyha9lY/r5DQeTohjTHdlYMAKLp7OKnQ+fWlX0un7AGt7uIav3lM9Jz2LvSetTjp4hz/U4NjKnufdqgJAs+zIUn5tsyAtiltsp1qDJNys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGLNHrqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGLNHrqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0831F000FF;
	Sat, 12 Sep 2026 14:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224353;
	bh=qi8EU8GdFw3EZaf4DdnD66DtXNpCaE0UffxUAa7I8kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGLNHrqwISwrdfxtR8Sm2O3+KNvwVYiJcLIuAdf3PbfuLmH7+dylhwlTvCA02HL0w
	 JRb2PDcSi7NsFmZOjyB5h9G3MwjZ+a1OP6kR7ewzoMIRCNJxZdNrugvpZrOp7Wkern
	 hz88kaXHdk6B10UfqRuZnILG8zGLFYbYvr6lAfTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0976/1424] wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie
Date: Sat, 12 Sep 2026 08:56:48 +0200
Message-ID: <20260912065629.171380576@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit dd59a6126a8f1bd52bf6bd057bf0c8307f76a74b ]

The clock enable path for the second adie sets MT_ADIE_SLP_CTRL_CK0(1)
but polled the busy bit of MT_ADIE_SLP_CTRL_CK0(0), so dual-adie
bring-up could proceed before the adie1 clock was stable.

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Link: https://patch.msgid.link/20260722082610.2699628-18-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index 37348b208736e..f182ea7c5f1b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -913,7 +913,7 @@ static void mt7986_wmac_clock_enable(struct mt7915_dev *dev, u32 adie_type)
 
 		read_poll_timeout(mt76_rr, cur, !(cur & MT_SLP_CTRL_BSY_MASK),
 				  USEC_PER_MSEC, 50 * USEC_PER_MSEC, false,
-				  dev, MT_ADIE_SLP_CTRL_CK0(0));
+				  dev, MT_ADIE_SLP_CTRL_CK0(1));
 	}
 	mt76_wmac_spi_unlock(dev);
 
-- 
2.53.0



