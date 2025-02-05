Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0936F15198D;
	Wed,  5 Feb 2025 14:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764623; cv=none; b=ERWRH4mzuttsLO0ssPMkUvZsJ/EVHNx3oOWAhvzWoRX7YvWHjV8nUkMRv5hKw5Or+44cTx+/pSWKQ+0u3wlHnzoDCqZQ3woSPXhKVZPr+rt3DfDedzJ+8hkDfJl/DPuDjjoVRqsfx9XA6QG6uBeJicVzgTX7Zc/qQnlkqInqJiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764623; c=relaxed/simple;
	bh=gXpf5UAuYYzp4JkFkuzvD95ZCET708SLtjogSC+Awt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+QHD3h+M++X/zD1WOvP3QO5bppdWwjzq41TUclrBAAMmNwkSI8ykYR6ySQe0IWXUULew3pFMTCGExQwWCJ0QxKdtIMzWe4bG0ypfE47E15gEHXgguHFhKYUR6MbnTCYRwHz/U2ySHsK042Ep1QZ1jLtG76NTGRuUB+EnEBt8IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAmdIm1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAmdIm1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8C3C4CED1;
	Wed,  5 Feb 2025 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764622;
	bh=gXpf5UAuYYzp4JkFkuzvD95ZCET708SLtjogSC+Awt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAmdIm1Rupu/0xM2jThfPvGm+xikt+/rMNnzPwsAQdNW2H6OTa/I6BmEULNrvipP5
	 +kCGHSI+hkyxcT8RiDCzujYy7ShE2UUz7e4ORZyLZRGTShawoByfbPefcth00+ONmZ
	 RDvFA182taHymCM91QHN+uvlegZfeevuihmZYBvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 096/623] wifi: cfg80211: tests: Fix potential NULL dereference in test_cfg80211_parse_colocated_ap()
Date: Wed,  5 Feb 2025 14:37:18 +0100
Message-ID: <20250205134459.896033335@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

[ Upstream commit 13c4f7714c6a1ecf748a2f22099447c14fe6ed8c ]

kunit_kzalloc() may return NULL, dereferencing it without NULL check may
lead to NULL dereference.
Add a NULL check for ies.

Fixes: 45d43937a44c ("wifi: cfg80211: add a kunit test for 6 GHz colocated AP parsing")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Link: https://patch.msgid.link/20241115063835.5888-1-zichenxie0106@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/tests/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/tests/scan.c b/net/wireless/tests/scan.c
index e12f620b5f424..b1a9c1466d6cb 100644
--- a/net/wireless/tests/scan.c
+++ b/net/wireless/tests/scan.c
@@ -810,6 +810,8 @@ static void test_cfg80211_parse_colocated_ap(struct kunit *test)
 		skb_put_data(input, "123", 3);
 
 	ies = kunit_kzalloc(test, struct_size(ies, data, input->len), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ies);
+
 	ies->len = input->len;
 	memcpy(ies->data, input->data, input->len);
 
-- 
2.39.5



