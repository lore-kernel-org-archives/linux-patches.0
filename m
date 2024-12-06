Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0262C1494D9;
	Fri,  6 Dec 2024 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496071; cv=none; b=DKwJGI5qlODD4q2m9OHz4RSxHu/bwS0uHn0QJkQ35GMp8i9JjK6i9ljIIEqC0bEbLHGjeOUdhAPW30gxi82YI+Yq4wqsD7fMgsTHiGNcZ5TdNabAkm0RXoCvLLxCEO+MWFksFXCUcueTYDlDt/Zy+UgOV0kiyg6OnHPLXOjtVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496071; c=relaxed/simple;
	bh=LhHlENCH3tfWqUIFMmB2+hrwz8kNb9eMAxfyJXJMuto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1i+NEH8ZaVEekAYAl2wrma/0a+gfkAKgyovtXTFmInUxcEKd1+xdEd9rYE/qIFsYDfONEcVOC1xV1DAsHM0c5fzDQEWPRxzbM5tnLKrVVogpLthK831srolHd45t15ieG3tkOuszbspmAcKu6M8XKGaNjI4nrp5N4iw/S2427o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZ2MMMI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZ2MMMI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63690C4CEDC;
	Fri,  6 Dec 2024 14:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496070;
	bh=LhHlENCH3tfWqUIFMmB2+hrwz8kNb9eMAxfyJXJMuto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZ2MMMI2opgPWyPeLeIKQx5eI+roOuLwwfMlvNS+3feic1zhq157YIrSLvTDvQ7yg
	 LRnlLzijUVHZOyGJtV2Zz7a6KVWaRIcUHCOmGGsHB85EcACFzoK7kEIDoxn+l/LfmW
	 lHzkvIna5Sy+JmVEbyJe7eflC8PjxNay8A5SjzPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.12 041/146] kunit: Fix potential null dereference in kunit_device_driver_test()
Date: Fri,  6 Dec 2024 15:36:12 +0100
Message-ID: <20241206143529.246426769@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Zichen Xie <zichenxie0106@gmail.com>

commit 435c20eed572a95709b1536ff78832836b2f91b1 upstream.

kunit_kzalloc() may return a NULL pointer, dereferencing it without
NULL check may lead to NULL dereference.
Add a NULL check for test_state.

Link: https://lore.kernel.org/r/20241115054335.21673-1-zichenxie0106@gmail.com
Fixes: d03c720e03bd ("kunit: Add APIs for managing devices")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/kunit/kunit-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/kunit/kunit-test.c b/lib/kunit/kunit-test.c
index 37e02be1e710..d9c781c859fd 100644
--- a/lib/kunit/kunit-test.c
+++ b/lib/kunit/kunit-test.c
@@ -805,6 +805,8 @@ static void kunit_device_driver_test(struct kunit *test)
 	struct device *test_device;
 	struct driver_test_state *test_state = kunit_kzalloc(test, sizeof(*test_state), GFP_KERNEL);
 
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_state);
+
 	test->priv = test_state;
 	test_driver = kunit_driver_create(test, "my_driver");
 
-- 
2.47.1



