Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC419F510;
	Wed,  5 Feb 2025 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764259; cv=none; b=A7dUhYnSnLDOmXmWFwEmKSFQBVaX+eh27eQD5TrmgQD/4s6nKcSEp0wPDvpezyRCmgFLFFtwjn6mrCEG1s5nIJLTiHBmSo1PdCLeeL2yt4ocUvRbG004bQETX99zdcMQDeaRE7DQdNYsxvuIZX0nEJU46A9iUYNmSkVRp1G+82U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764259; c=relaxed/simple;
	bh=ZWlnPNPBhGhgQmd4ZnrB1snKeFppyRIo6dLBkAX56Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUCYjGd9tkddXHO0tW73AtzdBy2Ogkt1l8H3vq/EmTaduFpJU9LYY5bwt5NoIOJJ09z+qJn+rKnB6Ji0NIsLNhVWLzMLNzKFhRugQSjDyAY0VLQO9hLjyqGBXeF+Z4o4N+eTU3RySGNRCMMOxh4e6PMIuIMjDlEFUckuoSyZsuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2jcWUth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2jcWUth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C59DC4CED1;
	Wed,  5 Feb 2025 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764258;
	bh=ZWlnPNPBhGhgQmd4ZnrB1snKeFppyRIo6dLBkAX56Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2jcWUthSkQJgp56xlZi2/O2wuQ72Tp21By8b8ly58MqHmzrQ+yIVoMPDpu575vz5
	 BGFCBB8VrZlJhsZpvzuzjZOWuezyO4JETuY92srcwfiMYUk1sEOd1PAlonWBxMz1dB
	 Owr+K9x9QzKNGDlF1CAKn2ufllGQNCFpCWj62jXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/590] wifi: cfg80211: tests: Fix potential NULL dereference in test_cfg80211_parse_colocated_ap()
Date: Wed,  5 Feb 2025 14:37:19 +0100
Message-ID: <20250205134458.466166514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9f458be716595..79a99cf5e8922 100644
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



