Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA40F61FD6;
	Mon, 27 May 2024 19:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836857; cv=none; b=KVjmVdNVn2sCy1WsDGgr8Jfdl/e5DEgihYCNJp+LDGMVX1nl9J+cc1BEGwfEzy9qrxcDXTFhJAdCLT/bVmo0xNS4gPeX5v4pRx4q1z9/WEOseDmrvbpPmtgZ+g+0l9rCNnqvQQGPDEd3ZsVWXt97A0eTkStAV+0CjSDrFAamCNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836857; c=relaxed/simple;
	bh=wuFJH2cFQ/HrGBI0gOlzBQHbue3n9mMQZMUOAKMYeGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QW3HGAKL6b9GgQLAlhcJwUyOZj71YFwTQByqKQqBVojAShIqy941P1ghYubD0rwKBckU8db7ZVVOthOyYl1ViV8+g0Eo8z7qmsGN5BKuITrB34lSxNxQdsYir3ExXgekigfzD7VS2EfP42pyDSJcBd2/aMUbVLZPkGEu6TXgCJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXjhNJJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXjhNJJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEEBC32786;
	Mon, 27 May 2024 19:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836857;
	bh=wuFJH2cFQ/HrGBI0gOlzBQHbue3n9mMQZMUOAKMYeGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXjhNJJnhg7HMzcf2GGq/1hMDHzTdjvDJQu0leigfqpNddTSAlqmeC6BnBVmNSUo9
	 t8Z6z5qeTjDPghfHig9+5TrKzdXS0xOY6jiHHSkYsXWtD2QyvAFKUuSPAZwo7sMyv1
	 b93TPFLQjrrMyoXSliIn+hOi6pBpb7/457CrprXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 214/427] kunit: unregister the device on error
Date: Mon, 27 May 2024 20:54:21 +0200
Message-ID: <20240527185622.460636557@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit fabd480b721eb30aa4e2c89507b53933069f9f6e ]

kunit_init_device() should unregister the device on bus register error,
but mistakenly it tries to unregister the bus.

Unregister the device instead of the bus.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Fixes: d03c720e03bd ("kunit: Add APIs for managing devices")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kunit/device.c b/lib/kunit/device.c
index abc603730b8ea..25c81ed465fb7 100644
--- a/lib/kunit/device.c
+++ b/lib/kunit/device.c
@@ -51,7 +51,7 @@ int kunit_bus_init(void)
 
 	error = bus_register(&kunit_bus_type);
 	if (error)
-		bus_unregister(&kunit_bus_type);
+		root_device_unregister(kunit_bus_device);
 	return error;
 }
 
-- 
2.43.0



