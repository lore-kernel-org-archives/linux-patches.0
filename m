Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CCD188CC1;
	Tue, 10 Sep 2024 09:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962037; cv=none; b=rUPP3VoKn6NXtRQvqB7eacuGVb1BhP5ROMrZrcyKPEkrFzXxThnexbmkNjG9RwbL5Vzy4VK1/b1/fF+OKQY/pBQ39iQHAq2yxuno9txyDIt0GrneHeWb/ZmGWA28VvDOWUTG75eOH0cJt835QGI708pauSLFTgfswxpI+oANRSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962037; c=relaxed/simple;
	bh=CrqtFi4tvf8jU//7dKQ2y2s/EuD80EiV1tYXbJ2Li4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAaK7n+Y1B/seggVT85o41a4Ogf7mLr1RnmGWMxoShuPB7urUgE8QsM4BMxlkPLeGujT8pofM7bR7LuayYRPXglQnIQLGcKKEcpu5zVrZ4whVXMVzwGcHLfcIcoBl8bQbViE54LPBsjmIX9tlW6xL10Xd13jg3QUp6jHL+t2Zzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSHxjdVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSHxjdVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD06C4CEC3;
	Tue, 10 Sep 2024 09:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962037;
	bh=CrqtFi4tvf8jU//7dKQ2y2s/EuD80EiV1tYXbJ2Li4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSHxjdVLk65TN8K3jYEOqWUEGb2RbJ2uVQ7wj7zAC0vXJ8Uq4Ydus1GP+B+pf8iHb
	 /qDLnFVsLA9LKgjFiLT4qMMjy2zPs1n7cs0hAxB7Kj+Su1MeC9T0Z59ZOntZt/AEJ/
	 Hm04KPxAdHbhkW5gqQ1BP+k7c5hreSlb4dMf7Dm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	David Gow <davidgow@google.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 273/375] kunit/overflow: Fix UB in overflow_allocation_test
Date: Tue, 10 Sep 2024 11:31:10 +0200
Message-ID: <20240910092631.729218162@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Orlov <ivan.orlov0322@gmail.com>

[ Upstream commit 92e9bac18124682c4b99ede9ee3bcdd68f121e92 ]

The 'device_name' array doesn't exist out of the
'overflow_allocation_test' function scope. However, it is being used as
a driver name when calling 'kunit_driver_create' from
'kunit_device_register'. It produces the kernel panic with KASAN
enabled.

Since this variable is used in one place only, remove it and pass the
device name into kunit_device_register directly as an ascii string.

Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/r/20240815000431.401869-1-ivan.orlov0322@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/overflow_kunit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/overflow_kunit.c b/lib/overflow_kunit.c
index d305b0c054bb..9249181fff37 100644
--- a/lib/overflow_kunit.c
+++ b/lib/overflow_kunit.c
@@ -668,7 +668,6 @@ DEFINE_TEST_ALLOC(devm_kzalloc,  devm_kfree, 1, 1, 0);
 
 static void overflow_allocation_test(struct kunit *test)
 {
-	const char device_name[] = "overflow-test";
 	struct device *dev;
 	int count = 0;
 
@@ -678,7 +677,7 @@ static void overflow_allocation_test(struct kunit *test)
 } while (0)
 
 	/* Create dummy device for devm_kmalloc()-family tests. */
-	dev = kunit_device_register(test, device_name);
+	dev = kunit_device_register(test, "overflow-test");
 	KUNIT_ASSERT_FALSE_MSG(test, IS_ERR(dev),
 			       "Cannot register test device\n");
 
-- 
2.43.0



