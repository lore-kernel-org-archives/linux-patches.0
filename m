Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6818846EC82;
	Tue, 21 Jul 2026 19:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660866; cv=none; b=gy324gLvJcjIJ/AUr0ggNm6G+k2lU2qUeRwSeQVxY4VLBcxQrc4G+u3J827ELlUPBMFkJpzPKDh9LJxtnuvhbAAPhxgs5ack71MRsIcZVJDiU3enElu8Yn+q4TxCWWtTg3BeYgyCc/2f+9mLiJggbE3bXtW+J2sbWTNFI+575Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660866; c=relaxed/simple;
	bh=vl1tRPqveT2NKf7gwxod2gHvOYIUOTMJ1Wph60vLxXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/DAMqYYAiUeJIMFcPnt3OjH5AsoBhj7OcZsNqmZ1PdYjaJ765f6r/ZX9qAU03Wsjl35VGz8+/bA6sbLf9hjmH0a8JcMbV7OjLT6MxEWBqFikEv/1/ItSo38UKxxjC1KCuIMhF7qA32JGV9Fc4YhbtxzjiM++et0vewpb7JfWBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCVdkOhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCVdkOhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD32F1F000E9;
	Tue, 21 Jul 2026 19:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660864;
	bh=ZmSxFYqvtz2tiPHkkGyGVXnb+z5Q8V1gJ33/VEI81rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCVdkOhYC7uIEriTVLdQaFTJPyazMd/8Ing0x1JcW9cv3W94OG8Q6zt3g1qGL3P3e
	 toT8V+ynFgZT9pIC33MKNFuX5DFB6vD/2LEXg4ZNKBkO5SavO/ZXe2ddNfsLlIRki7
	 qhKknaC3IFglzupY9o6AdnexdIMmyYt6TIRnkvXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1140/2077] mac802154: Prevent overwrite return code in mac802154_perform_association()
Date: Tue, 21 Jul 2026 17:13:33 +0200
Message-ID: <20260721152619.711764622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robertus Diawan Chris <robertusdchris@gmail.com>

[ Upstream commit 649147cb3f8b3c0c9aeba5d89d69a6ef221c12c2 ]

When assoc_status not equal to IEEE802154_ASSOCIATION_SUCCESSFUL, the
return value assigned to either "-ERANGE" or "-EPERM" but this return
value will be overwritten to 0 after exiting the conditional scope.
So, jump to clear_assoc label to preserve the return value when
assoc_status not equal to IEEE802154_ASSOCIATION_SUCCESSFUL.

This is reported by Coverity Scan as "Unused value".

Fixes: fefd19807fe9 ("mac802154: Handle associating")
Signed-off-by: Robertus Diawan Chris <robertusdchris@gmail.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/20260602054133.470293-1-robertusdchris@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac802154/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index 0a31ac8d84155d..300d4584533e6f 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -594,6 +594,7 @@ int mac802154_perform_association(struct ieee802154_sub_if_data *sdata,
 			 "Negative ASSOC RESP received from %8phC: %s\n", &ceaddr,
 			 local->assoc_status == IEEE802154_PAN_AT_CAPACITY ?
 			 "PAN at capacity" : "access denied");
+		goto clear_assoc;
 	}
 
 	ret = 0;
-- 
2.53.0



