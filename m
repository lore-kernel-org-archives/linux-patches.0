Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351B44C97;
	Tue, 11 Nov 2025 00:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822163; cv=none; b=NUbREsR5MQzbfXfKC4NGF6sUsEq1vh7UuP0GFHaNj1lwjjo0wUzahByeBwQZ2spkRRv/cJ21AyNPGKBTeHh+kYli3b0rtqlZLGoCYqI/TGvNyhM2bSo9WHB3rB+aQq9/3GX/xgtHwTzHA5sipY9D5qNnFKjCj+O2pINIvv6lu80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822163; c=relaxed/simple;
	bh=snm5QkyCQeu56tXkJTe3Muy2VqvYP3mSauz/+HhCmxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8WZxt56T6mfoJBGkxkDZaV0KV4zdyd+mKBUqzFKITtoIH1KqkmAFvgU4penupo0LQWi0xTtv1VWx4DEQWCeU2jtblDsPiLPrwum/cyDkP7O7JKf1ziUrpoOj3VqGrWnFCQk9Slqddq5zwukyaQxp6HY+AHpRCKQi84MswJR5AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzvMopTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzvMopTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F69C2BC87;
	Tue, 11 Nov 2025 00:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822162;
	bh=snm5QkyCQeu56tXkJTe3Muy2VqvYP3mSauz/+HhCmxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzvMopTI2mnUP9XpLgP/Ad0GRShvLB9b2aWC6l1ll2HcEKAUZHklUenyzsx8g7cqE
	 4xIM2Qc9Ipi+fEFpci+pgsNA7LC9/eLDUlJ5wr0qFf2O2Gz3f3/oyK/EfPqXjoL6Ws
	 5/RoZIzRlyw/rZnyFjlADKQ2eia3Wm2SaePFZTYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Florian Schmaus <florian.schmaus@codasip.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 042/849] kunit: test_dev_action: Correctly cast priv pointer to long*
Date: Tue, 11 Nov 2025 09:33:32 +0900
Message-ID: <20251111004537.454432413@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Schmaus <florian.schmaus@codasip.com>

[ Upstream commit 2551a1eedc09f5a86f94b038dc1bb16855c256f1 ]

The previous implementation incorrectly assumed the original type of
'priv' was void**, leading to an unnecessary and misleading
cast. Correct the cast of the 'priv' pointer in test_dev_action() to
its actual type, long*, removing an unnecessary cast.

As an additional benefit, this fixes an out-of-bounds CHERI fault on
hardware with architectural capabilities. The original implementation
tried to store a capability-sized pointer using the priv
pointer. However, the priv pointer's capability only granted access to
the memory region of its original long type, leading to a bounds
violation since the size of a long is smaller than the size of a
capability. This change ensures that the pointer usage respects the
capabilities' bounds.

Link: https://lore.kernel.org/r/20251017092814.80022-1-florian.schmaus@codasip.com
Fixes: d03c720e03bd ("kunit: Add APIs for managing devices")
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/kunit-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kunit/kunit-test.c b/lib/kunit/kunit-test.c
index 8c01eabd4eaf2..63130a48e2371 100644
--- a/lib/kunit/kunit-test.c
+++ b/lib/kunit/kunit-test.c
@@ -739,7 +739,7 @@ static struct kunit_case kunit_current_test_cases[] = {
 
 static void test_dev_action(void *priv)
 {
-	*(void **)priv = (void *)1;
+	*(long *)priv = 1;
 }
 
 static void kunit_device_test(struct kunit *test)
-- 
2.51.0



