Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E4C227E97;
	Mon,  2 Jun 2025 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875171; cv=none; b=YdVOPKd/kovkQZ1H6FVjZHMC8iE+G3EVMmYZU8yywWSx76ZHtsiSUJrUt90I8Edl/nSjRdfc+URWWd6+rwWceFu/C5ANJierp6ZCT5cqp0NGK8icw3OldbQUB2mdjK0fFUuNR6GdLoZUvRIEsSK8XLzjdFQn5HT0Fq/SDJnbWtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875171; c=relaxed/simple;
	bh=zNg8NsBxzUrNiL81PTeKYeZD/ovLIfj5NQk3xUCF8p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhnXJuSf3ZcLUIdtbdHH2BC53cPDWw+CKRNmek8DFrGi6SFbkqTKTG/1BG19VVPVoHdMJU4vfVNZeIs/Ycwi6JEnhen8HBzjKEn5LktEGKzJ+ydM7k7v4DsOhUlvF1xT3R5wIQAwDs2NUT/sflW6qOHP0zp2+9y14ERIT3cYPXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jFQaGb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jFQaGb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2916C4CEEB;
	Mon,  2 Jun 2025 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875171;
	bh=zNg8NsBxzUrNiL81PTeKYeZD/ovLIfj5NQk3xUCF8p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jFQaGb6h+w1B8GcUC4nQI9Z0DRB0DOLFzkeKM/+Cem9lo/WbfnpZYLceNKFiz5Dn
	 MwVbFqANKMhXX3W7eSpTGAhLPsc4eU1aqAoU/vkjijWDegn7ceZlKsm+2/yVvtMbSJ
	 lgNXwUkK/nsWI8KJZjLozYrcUNCTXpLpyP+LWI2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/270] net: dsa: b53: fix learning on VLAN unaware bridges
Date: Mon,  2 Jun 2025 15:45:35 +0200
Message-ID: <20250602134309.243541732@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 9f34ad89bcf0e6df6f8b01f1bdab211493fc66d1 ]

When VLAN filtering is off, we configure the switch to forward, but not
learn on VLAN table misses. This effectively disables learning while not
filtering.

Fix this by switching to forward and learn. Setting the learning disable
register will still control whether learning actually happens.

Fixes: dad8d7c6452b ("net: dsa: b53: Properly account for VLAN filtering")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-11-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 0914982a80c11..39a56cedbc1f4 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -383,7 +383,7 @@ static void b53_enable_vlan(struct b53_device *dev, bool enable,
 			vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
 			vc5 |= VC5_DROP_VTABLE_MISS;
 		} else {
-			vc4 |= VC4_ING_VID_VIO_FWD << VC4_ING_VID_CHECK_S;
+			vc4 |= VC4_NO_ING_VID_CHK << VC4_ING_VID_CHECK_S;
 			vc5 &= ~VC5_DROP_VTABLE_MISS;
 		}
 
-- 
2.39.5



