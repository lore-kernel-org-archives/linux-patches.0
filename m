Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58F812DDA1;
	Tue, 11 Nov 2025 00:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822334; cv=none; b=kCGnMwyqsqX3FaztQwYl1garDQfHrAn2qYqGSXFwRsyNx57M6Gs1oQ9foJkiFgQ5CXlqQ42/8uRk0qoDADGsOURFlTVhzgiHG0Q+eU9dKx2k3QcjO9ZVyf9Ptqp99EKJQfcZF8RfCT3QzlQKO9jp/5H1KyU45WN1Cf48eTiiuEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822334; c=relaxed/simple;
	bh=MqywhlTTt7qzgK1H+oMqAVJYJ9YbpwfLv4y2E+URqdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni9G38JU1+H2P4xWJZydd4ZJ2d3Jzl9iIwL5ZanrJt0/XsGPXGs8OOPlgp58X+R5RsoumERzPE5v9tWKQ6d4y08h/Jal/vxtHTs+bGEI3jMV9x+yq5n8GpkbMv7Du6ZzNykPIwx0v5s5eJVC0faKJIiJHbinOuZupICPKrHcuuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEBvBIFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEBvBIFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BAEC16AAE;
	Tue, 11 Nov 2025 00:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822334;
	bh=MqywhlTTt7qzgK1H+oMqAVJYJ9YbpwfLv4y2E+URqdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEBvBIFPjxuNOAMVp9ebCIiXVNf88rzHIPmeVbSQTOX68cqmBlufemkbua1eN1uw4
	 f8/APfp9O9zEOFldGsUuA6yziVDrB2gWyZJLtiGtgZTojK/gR68V4SK5cy24O77zz7
	 MCTaa2ERc+F5cqLtp21ZQeBq6kKW0sbEN9cgT7Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Florian Schmaus <florian.schmaus@codasip.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/565] kunit: test_dev_action: Correctly cast priv pointer to long*
Date: Tue, 11 Nov 2025 09:38:05 +0900
Message-ID: <20251111004527.535542454@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d9c781c859fde..580374e081071 100644
--- a/lib/kunit/kunit-test.c
+++ b/lib/kunit/kunit-test.c
@@ -735,7 +735,7 @@ static struct kunit_case kunit_current_test_cases[] = {
 
 static void test_dev_action(void *priv)
 {
-	*(void **)priv = (void *)1;
+	*(long *)priv = 1;
 }
 
 static void kunit_device_test(struct kunit *test)
-- 
2.51.0



