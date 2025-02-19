Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A2B188CCA;
	Wed, 19 Feb 2025 09:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956155; cv=none; b=Kljd3d5aYzTcj+EP3K+wXP9103dW9vpjNOYCy796vfcLXdvyHWzwtxfFE/ZnsyS0m5GZtIcilLpnb02wGsrt2tlFWaq4DdG7Bq1Bw3N6vvfZbQHIOlFVWrWSJwLQv3KuSNzuhiFHqc3aS9sTL4cAGt518NqUKFiwXNRWlsAItDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956155; c=relaxed/simple;
	bh=yOsvzToJnQAFNeNm3rh4SB9Bc32ZLqMw3Nguh4AGCwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOTtfXwm6KeIkoWuO9L45wmX1qHeBthav3ysicSy4fLcB7QDE7C0z8Alki3Iu+DThuqJnWb+tXG7G1lCq3abHRGYtmvg5E8MjxIB46iPGSwKzwM81jarZVzOp0Ciaquc4GhbEUwhML3litAEhuoKAFXYpNp3mXrLWB4+4FzNA4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGp+ou3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGp+ou3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39661C4CED1;
	Wed, 19 Feb 2025 09:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956155;
	bh=yOsvzToJnQAFNeNm3rh4SB9Bc32ZLqMw3Nguh4AGCwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGp+ou3xVsIUiWNVtmQz/i00Xc06PCsU526TmDtqOy7Jxf4xJbAvpaY2gzXQcZiUG
	 fOlh68Gz2yeQQVyQW3Uqn9oDalG/eT7w9pSFvtOPXyqDdfCWdJs1C77fj8YrVvp8oC
	 3xKE/gUTVlU5YG6Dq6jPyCX9yNwutyVXZU4F+5Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	David Ruth <druth@chromium.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/578] wifi: mt76: mt7921: fix using incorrect group cipher after disconnection.
Date: Wed, 19 Feb 2025 09:21:28 +0100
Message-ID: <20250219082656.268290259@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Lo <michael.lo@mediatek.com>

[ Upstream commit aa566ac6b7272e7ea5359cb682bdca36d2fc7e73 ]

To avoid incorrect cipher after disconnection, we should
do the key deletion process in this case.

Fixes: e6db67fa871d ("wifi: mt76: ignore key disable commands")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Tested-by: David Ruth <druth@chromium.org>
Reviewed-by: David Ruth <druth@chromium.org>
Link: https://patch.msgid.link/20240801024335.12981-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -469,7 +469,13 @@ static int mt7921_set_key(struct ieee802
 	} else {
 		if (idx == *wcid_keyidx)
 			*wcid_keyidx = -1;
-		goto out;
+
+		/* For security issue we don't trigger the key deletion when
+		 * reassociating. But we should trigger the deletion process
+		 * to avoid using incorrect cipher after disconnection,
+		 */
+		if (vif->type != NL80211_IFTYPE_STATION || vif->cfg.assoc)
+			goto out;
 	}
 
 	mt76_wcid_key_setup(&dev->mt76, wcid, key);


