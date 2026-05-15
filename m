Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F8C3B1029;
	Fri, 15 May 2026 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861062; cv=none; b=kUadGZo1ldxHxu53sY2hk4Tu3z5IaaWuxTpk7ZkqOm11CWqJ6HJPOZybnH063PQZzGwbwCMFu0rpPqn+281oa1tWZCIXAYjZpzT1nV5ptX0l4AvvprDo0+RXLoxe0MSvXTkU4Pjk0pzUBTEmcdJ6JiWDtIrXkwW0ikackqlzFc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861062; c=relaxed/simple;
	bh=HICaXoGtM4xuDpiZjv5GM/f1hD1S6qQ+sSZb1jPVgy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhaqiebsNe9Ooq2pplFvhqHEFapGKFN79DL3PDA/UPt3n9EbTAb0FCPzQS/+KYi7fiBs0Ws3v1/Ygzut44K5FLlWpBEYMjqP0+bZb+eDa/zMhe4DFox8qz2Pars1bdlo5yc5/LK7kzu/rpiWmmjigz93gXv2bPksOeqP6k9DhMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0upsf0ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0upsf0ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B530C2BCB0;
	Fri, 15 May 2026 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861062;
	bh=HICaXoGtM4xuDpiZjv5GM/f1hD1S6qQ+sSZb1jPVgy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0upsf0qlV5jBb+3HAhUPsUEbzR8O4jJS+1+NsNxBhY2mFMQFANdQ3PyT3hEWFGbiN
	 Bx8Ny5W9dbZT+4pry9FbeSbRU5HnLZoe+K1sVbTiRrI4Dsk7AV4ERaGXeJ4Ie4ICz+
	 +tHG6W0JzJl9m24yEwwdTaSjmvnAsjbTIAjlkJj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Yen <leon.yen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.6 184/474] wifi: mt76: mt7921: fix a potential clc buffer length underflow
Date: Fri, 15 May 2026 17:44:53 +0200
Message-ID: <20260515154719.004955890@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Leon Yen <leon.yen@mediatek.com>

commit 5373f8b19e568b5c217832b9bbef165bd2b2df14 upstream.

The buf_len is used to limit the iterations for retrieving the country
power setting and may underflow under certain conditions due to changes
in the power table in CLC.

This underflow leads to an almost infinite loop or an invalid power
setting resulting in driver initialization failure.

Cc: stable@vger.kernel.org
Fixes: fa6ad88e023d ("wifi: mt76: mt7921: fix country count limitation for CLC")
Signed-off-by: Leon Yen <leon.yen@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20251009020158.1923429-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1155,6 +1155,9 @@ int __mt7921_mcu_set_clc(struct mt792x_d
 		u16 len = le16_to_cpu(rule->len);
 		u16 offset = len + sizeof(*rule);
 
+		if (buf_len < offset)
+			break;
+
 		pos += offset;
 		buf_len -= offset;
 		if (rule->alpha2[0] != alpha2[0] ||


