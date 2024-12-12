Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D54C223320;
	Thu, 12 Dec 2024 17:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024608; cv=none; b=qFQq8yBKQLutH4aiX3v5sD+rOtp7i3iolF5L74si2tB3JLGJr7uikg6sHNF8t/hF1mPOuJS8Wqq0J+paeHaXRRYukQZ9VtiYcAvDeFfbAtnLpslHGw84APu6GiqE6m7eB++JK90azAEeuClg4M2TaiQKmbfkT5dma3UaHQmCjvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024608; c=relaxed/simple;
	bh=peJu836SFe7EytLwqTOJECHue+1MnnZqmfBBOivN/EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUaDFKSp0LWP74lcNDvhiqhC5oM/+DikPd++7nBpUcU/nMNdPMnQF45k4GYS552N1FITUAdVgALU7uuIS2KUFT2zNg6Zx5ASf8zDXKn/a3F5U1PpVIEqxetc/y6fVZf1lLdky/sIietwzAUkCBJoXFXE1IG2KBpbQyJ5slcGaQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZp7Skq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZp7Skq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B04C4CECE;
	Thu, 12 Dec 2024 17:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024608;
	bh=peJu836SFe7EytLwqTOJECHue+1MnnZqmfBBOivN/EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZp7Skq7BqlHnDZjBVB4n++qRHcqIruBEcz4RlVK7X0vUsFbqR+wOWk3LMb4AOSFV
	 bpPpURiwC/N3E7zpgokxdmFQIDxGWcK594t4ueSnZKiOjgK8SRFZ+vxZ6QKo5QyhSQ
	 Io12vEaMB6vGpSEZ+ZqrIP1stvXbtLNfCZt7T8D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 312/459] octeontx2-pf: Fix out-of-bounds read in otx2_get_fecparam()
Date: Thu, 12 Dec 2024 16:00:50 +0100
Message-ID: <20241212144305.969420049@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 93efb0c656837f4a31d7cc6117a7c8cecc8fadac upstream.

Code at line 967 implies that rsp->fwdata.supported_fec may be up to 4:

 967: if (rsp->fwdata.supported_fec <= FEC_MAX_INDEX)

If rsp->fwdata.supported_fec evaluates to 4, then there is an
out-of-bounds read at line 971 because fec is an array with
a maximum of 4 elements:

 954         const int fec[] = {
 955                 ETHTOOL_FEC_OFF,
 956                 ETHTOOL_FEC_BASER,
 957                 ETHTOOL_FEC_RS,
 958                 ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS};
 959 #define FEC_MAX_INDEX 4

 971: fecparam->fec = fec[rsp->fwdata.supported_fec];

Fix this by properly indexing fec[] with rsp->fwdata.supported_fec - 1.
In this case the proper indexes 0 to 3 are used when
rsp->fwdata.supported_fec evaluates to a range of 1 to 4, correspondingly.

Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
Addresses-Coverity-ID: 1501722 ("Out-of-bounds read")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -805,7 +805,7 @@ static int otx2_get_fecparam(struct net_
 		if (!rsp->fwdata.supported_fec)
 			fecparam->fec = ETHTOOL_FEC_NONE;
 		else
-			fecparam->fec = fec[rsp->fwdata.supported_fec];
+			fecparam->fec = fec[rsp->fwdata.supported_fec - 1];
 	}
 	return 0;
 }


