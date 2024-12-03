Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446E31F76BF;
	Tue,  3 Dec 2024 16:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242479; cv=none; b=OMxdbTmnttHoKyWIqZYmXoFSkZDEIUrcUuBldDwj2XCDDodVs069klXyXk37krHIIfXQ3Ep1EhkV/gjgmfvOAuhqIfnQBEb2t2Itu9AVlu/wNmfhszuqXMyDUTWyI4jdnrDH60C0xZzFqMXzJcSGjTuBKFQ+G4uuq5ywj+arkjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242479; c=relaxed/simple;
	bh=boloXJbE19sBiKTRSUjA0UZcU4rReThFa/FQSIfY2fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mr+5WrYAemgRG+gdtZbL8jXmyNxZv1n/bFGmGNB3pHPRbRhfIWlXNbzr3+r/kdzhDJBdcbvOW8nblfqwGz889sjGX3Xa72hr8OLrsSlPHyioYAVVBgB0YjClMxSlWMYUim08c3kXwQMp3aXqmg8IpoWh7a3pr97/W8fbZHua7Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7akQOBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7akQOBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAC9C4CECF;
	Tue,  3 Dec 2024 16:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242479;
	bh=boloXJbE19sBiKTRSUjA0UZcU4rReThFa/FQSIfY2fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7akQOBm7W+/4pxf6bMoVqZ6G4xOFWjhTCYXsq5IN8K8CcdU4dycb+hPUxK67nlsx
	 IQpeW+g0xy76Gv5coWwDPifz9NVGwVSXhqfmLGJ+WIc1SfCCfplGl3WPPCCSyqTx7x
	 Pz2AZrVgpvGL0wWW4xqPdxkHoLdjlZYKGzRLgo4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.12 685/826] wifi: brcmfmac: release root node in all execution paths
Date: Tue,  3 Dec 2024 15:46:52 +0100
Message-ID: <20241203144810.478086300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 2e19a3b590ebf2e351fc9d0e7c323430e65b6b6d upstream.

The fixed patch introduced an additional condition to enter the scope
where the 'root' device_node is released (!settings->board_type,
currently 'err'), which avoid decrementing the refcount with a call to
of_node_put() if that second condition is not satisfied.

Move the call to of_node_put() to the point where 'root' is no longer
required to avoid leaking the resource if err is not zero.

Cc: stable@vger.kernel.org
Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241030-brcmfmac-of-cleanup-v1-1-0b90eefb4279@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -110,9 +110,8 @@ void brcmf_of_probe(struct device *dev,
 		}
 		strreplace(board_type, '/', '-');
 		settings->board_type = board_type;
-
-		of_node_put(root);
 	}
+	of_node_put(root);
 
 	if (!np || !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
 		return;


