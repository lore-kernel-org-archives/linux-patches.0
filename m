Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062128;
	b=1I1BHTBHgzclcvqcwgLK+oxcrJikRjlJz18NKWovaMfj/WjYMDw5+GXMwgtPf635nphm
	 CiX04YcVx2rNN/UipVQeUokU5sfHbMRvUgrEujVEMx0cGmk805uE8QnXQk00Bx52r3G0t
	 jv81kpeLwXEYMAkAGGzMeDddjedTS5YctKHFLXk2SPPXE49DZq4D1DPlM+Ejn4HAqeYhJ
	 67sw1ZLqVBLlDjoAMNCLdJZJTPEnwIiSOoO/DbxgSpjWIGQXuWmdFLC7i4WFtxB3KCqP5
	 IJLV4wkYPYiDWskv81ENy4yrldjMlwgvrd4VUZgsEBNXJfwZBEU9vcQ9ktnPDQ7ZHCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eagi2ovkNhJWDiQekSdmMQPjplPpu9qmb1Dt2gi/eKo=;
	b=a60v4+1ufuZBffKTV7GftNldk2loLWMd7oYCJiaSxn90ha8q90MbyMdzgFJRLFFFqu8r
	 LFyk5Ol7okifPZEYuHZTMSbbYMvOQvPKChI8w3D5RDqLhdaSIEWpgQiNbDcivD/vhqgUI
	 0pU/Ct2c8KJJK91IsYxItw18HNRSe0rn37frTPGkbFx7jhRG68WmYtJp6+stNvfI1S0xG
	 hH6uhlXLIy8dSdQMRam7ESGwzmm+LU88J0Zv3JhSiOQUjuZ/S7Qw5vWI6pLz2N18jhNfp
	 JY4cFNkoQ20PLYwbitTmX8Y5f3MVjprPVEU0dxK37/Rq9x2/59wxGcbiDZB66FbQGXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEcY+jPW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D692D606EE98;
	Sat,  7 Nov 2026 14:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEcY+jPW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F681F008A1;
	Sat,  7 Nov 2026 14:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062127;
	bh=eagi2ovkNhJWDiQekSdmMQPjplPpu9qmb1Dt2gi/eKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEcY+jPWYrsVmD7+nfchfEZV0BXECwUUc1dxmcm0y79dAuJA6eSI/8wqUgHtCqx7G
	 DmAtrz/sQjuEvubyWgU30g1Ys4bGx2RaeqkDuzFsAOUysj3ZV1F6j9dcrqlQhgcncA
	 LreJuP6WPti9xUzsgKuxg09wXLT8XGxJIS0mj8Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Costa <2000.costalucas@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1096/1536] spi: bcm2835: fix device_node reference leak in bcm2835_spi_setup()
Date: Sat,  7 Nov 2026 08:51:52 -0500
Message-ID: <20261107135028.483205952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Costa <2000.costalucas@gmail.com>

[ Upstream commit 8db44cca03df066186d6220bfad9fa482d7cdc13 ]

of_find_compatible_node() returns a device_node with its reference count
incremented, but bcm2835_spi_setup() only uses the return value to test
for a matching node in the loop and never releases it.

Declare the node with a scope-based __free(device_node) cleanup so the
reference is dropped automatically when leaving the loop body, matching
the existing __free(kfree) usage in the same function.

Fixes: e19c1272c80a ("spi: bcm2835: Restore native CS probing when pinctrl-bcm2835 is absent")
Cc: stable@vger.kernel.org
Signed-off-by: Lucas Costa <2000.costalucas@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260925193008.127314-1-2000.costalucas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 5926e004d9a65..8fadb216b87ea 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1297,7 +1297,9 @@ static int bcm2835_spi_setup(struct spi_device *spi)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(pinctrl_compats); i++) {
-		if (of_find_compatible_node(NULL, NULL, pinctrl_compats[i]))
+		struct device_node *np __free(device_node) =
+			of_find_compatible_node(NULL, NULL, pinctrl_compats[i]);
+		if (np)
 			break;
 	}
 
-- 
2.53.0



