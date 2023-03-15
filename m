Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3D74431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36E7C433D2;
	Wed, 15 Mar 2023 12:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883507;
	bh=pY5oKRL/60m1hFyGM31zA6AIXDpuAGgqf/QG1Ny+1ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rqe4azQsMtNbfkz5kxYShO0XRnsD6aU5HTXfBC5hkRU92VGrZXUeurtvyPcR/nkP5
	 M4DY1VJLnYAhT5SmFy/Stm6SeygBsb5OK4dgr2R8V172uNb0fFbFta57n2f9MVX/n/
	 2T6OXNrjzIJ5JGpYN1qxKsZND7s54tIsdndKcRoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 025/143] nfc: change order inside nfc_se_io error path
Date: Wed, 15 Mar 2023 13:11:51 +0100
Message-Id: <20230315115741.268204990@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 7d834b4d1ab66c48e8c0810fdeadaabb80fa2c81 upstream.

cb_context should be freed on the error path in nfc_se_io as stated by
commit 25ff6f8a5a3b ("nfc: fix memory leak of se_io context in
nfc_genl_se_io").

Make the error path in nfc_se_io unwind everything in reverse order, i.e.
free the cb_context after unlocking the device.

Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230306212650.230322-1-pchelkin@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1446,8 +1446,8 @@ static int nfc_se_io(struct nfc_dev *dev
 	return rc;
 
 error:
-	kfree(cb_context);
 	device_unlock(&dev->dev);
+	kfree(cb_context);
 	return rc;
 }
 


