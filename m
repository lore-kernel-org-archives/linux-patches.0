Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C134315F;
	Wed, 19 Jun 2024 13:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803019; cv=none; b=XhXZjCW534hFfEsGWhRRfCG3Fs8xCSLQrTeRo/5vkD3bHY+uHO94HGdqLK7lB52Nv+WGEaYBBTrbD/dlb+9wujvrvWRznR53oVOtyVlEjAxDYQ0O2UoAFUAMs6wJaK8PXjUKMAhBNXM6pgpUrw0IcxQ7HDcJwn3v6jXOnO2ccIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803019; c=relaxed/simple;
	bh=mF2mOPWDHBMM+TC8BtWIHOTxfz8fsFbjmcgq6li51j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhMRfEKC52Bw+4O5wI37VOAc9CY8Jsz+TxWr302vC1ziVl/hPTOjgfdmW7AeJyTjB51fh6hKORj30FH0L1MZPQfE4EubgOseCa78lyd514dR/yLFI6cAD92IOhJJDuaJTHsrDMREpZBdCADLBnorHegmQMNkwT4vUDFaGMaMPEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dvy8YZOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dvy8YZOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E707C32786;
	Wed, 19 Jun 2024 13:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803019;
	bh=mF2mOPWDHBMM+TC8BtWIHOTxfz8fsFbjmcgq6li51j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dvy8YZOYSyW3ZNNztTKGc6Gxj1opu41GbkvLbnifPGrMai9QSJr5thXojJY62TJym
	 DvHhKcVw6icNHKryL8flQM4QqGBaT02/QDiG6Gydl60FyGLf8HXzsiHQRCkWBaPtkk
	 2tjXbcjj69Jbqb4CaQjDyl5612MtfJWqYBSGkTA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	John Hubbard <jhubbard@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 126/281] selftests/futex: dont pass a const char* to asprintf(3)
Date: Wed, 19 Jun 2024 14:54:45 +0200
Message-ID: <20240619125614.693591261@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit 4bf15b1c657d22d1d70173e43264e4606dfe75ff ]

When building with clang, via:

    make LLVM=1 -C tools/testing/selftests

...clang issues this warning:

futex_requeue_pi.c:403:17: warning: passing 'const char **' to parameter
of type 'char **' discards qualifiers in nested pointer types
[-Wincompatible-pointer-types-discards-qualifiers]

This warning fires because test_name is passed into asprintf(3), which
then changes it.

Fix this by simply removing the const qualifier. This is a local
automatic variable in a very short function, so there is not much need
to use the compiler to enforce const-ness at this scope.

[1] https://lore.kernel.org/all/20240329-selftests-libmk-llvm-rfc-v1-1-2f9ed7d1c49f@valentinobst.de/

Fixes: f17d8a87ecb5 ("selftests: fuxex: Report a unique test name per run of futex_requeue_pi")
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/futex/functional/futex_requeue_pi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/futex/functional/futex_requeue_pi.c b/tools/testing/selftests/futex/functional/futex_requeue_pi.c
index 7f3ca5c78df12..215c6cb539b4a 100644
--- a/tools/testing/selftests/futex/functional/futex_requeue_pi.c
+++ b/tools/testing/selftests/futex/functional/futex_requeue_pi.c
@@ -360,7 +360,7 @@ int unit_test(int broadcast, long lock, int third_party_owner, long timeout_ns)
 
 int main(int argc, char *argv[])
 {
-	const char *test_name;
+	char *test_name;
 	int c, ret;
 
 	while ((c = getopt(argc, argv, "bchlot:v:")) != -1) {
-- 
2.43.0



