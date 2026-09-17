Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663D8484896;
	Thu, 17 Sep 2026 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659520; cv=none; b=a2xONyQJlhhD2Xsi7qe4UjVVZitdttJ8vUP+PbYLI5uwI0wZE30cWnbXNHGX/qR5g8hslmk0G8lBu4wLlg7dmyQwXrqI0RXRGY9TPByG3AWtPPDLhP/9T79UCnDP10GRLSNN8vz+qNdba6WcwsSFLTIFrCcQwkfhmzwyO4r/hqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659520; c=relaxed/simple;
	bh=DJwy+LLmHHFrFT9zum8kUJ9dFZGlSqYzux5hoHyuN0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAYGNy6C4/Y8wdLY5HFxuy4eoWJHYPtx6HMS0aeMrl7HQ38so7MPjV8Wg0YGQCcZFXuJ18ma6v6NAsN+RSraFajUHVcAHl0YIfrhvsHL2Xa/erFeHuFjcQtdw9MOuJMo7vUAGRu5Acg91RRiq0kil4Rtdv144AmnvbE+x8gcPYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0hnFKxM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0hnFKxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C67B1F00893;
	Thu, 17 Sep 2026 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659507;
	bh=21CKatLWXR1lbZyX/hVYBPzOkAc09cH42yW6JV5/6/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0hnFKxM9DgT0UizZXoDperyMCDLHbsQXNNd2iXn3tOtrMYbYMJsJFlbK2Eg9eFPF
	 /hDm+B93UGSmSFnVeU8HsKIxtBiRBo22/Dwe9FGF2nMguU7Y7U6x6kmLnNySKnf58I
	 QS5+LVt6+zOe/I7EjKaYBQG4hVrxyo8lzl/65Cw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Viswajith Murali <viswajithm@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 279/733] octeontx2-af: mcs: Clear stale X2P calibration state before calibration
Date: Thu, 17 Sep 2026 16:09:47 +0100
Message-ID: <20260917151358.321644500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viswajith Murali <viswajithm@marvell.com>

[ Upstream commit 1f29543126dde307e8b5fb6a740c54e59deaa2ff ]

Some firmware versions leave MCSX_MIL_GLOBAL bit 5 set on boot.
If the bit is already set when the driver attempts X2P calibration,
the hardware sees no rising edge and calibration never triggers.
Clear the bit and wait briefly before starting calibration to ensure
a clean rising edge.

Fixes: ca7f49ff8846 ("octeontx2-af: cn10k: Introduce driver for macsec block.")
Signed-off-by: Nitin Shetty J <nshettyj@marvell.com>
Signed-off-by: Viswajith Murali <viswajithm@marvell.com>
Link: https://patch.msgid.link/20260901094318.1395356-1-nshettyj@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index a07e0b3d8d000..211c10aa5880f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -1417,6 +1417,16 @@ static int mcs_x2p_calibration(struct mcs *mcs)
 	int i, err = 0;
 	u64 val;
 
+	/* Clear any stale calibration state left by firmware/bootloader.
+	 * Some firmware versions may leave MCSX_MIL_GLOBAL bit 5 set,
+	 * preventing the hardware from detecting the rising edge needed to
+	 * trigger X2P calibration.
+	 */
+	val = mcs_reg_read(mcs, MCSX_MIL_GLOBAL);
+	val &= ~BIT_ULL(5);
+	mcs_reg_write(mcs, MCSX_MIL_GLOBAL, val);
+	usleep_range(100, 200);
+
 	/* set X2P calibration */
 	val = mcs_reg_read(mcs, MCSX_MIL_GLOBAL);
 	val |= BIT_ULL(5);
-- 
2.53.0



