Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057056;
	b=XKjEi7xlnuMv8tnsezZzbrsQxK5Gakm8PMyIgLYrSbKDRvvx1KLGD9i450aAaa9Kkq3U
	 0QnOpAJbsdopUQj4lHuthQqBxIA8/RQxtBywtgnhqE15ToWr1Bxg0vgVemC7gqD8CaJCn
	 lRJS+tp+X8i2Sitwh/9mOnEEoledMKcWtg5o+q7Rpu7EuAEqvaZoE7X/7E5I8Xr5g3uqS
	 vRQ4oIUPuJXIqn0Hx6AKFKm6tPD64nUaS7Q85tAYIokrZlcxmT8QRqD/JR548/zBQ6D5F
	 QvK9h2JNzW9mtFCgQeo4wSHmR0M6V+aQIKLNP3VsFYzazKJNA7vID1V0YQp3yACNL1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hzD7/EXRwUIlVwyLgsCM2oSIlCP96D+ab5yTtyPhs1U=;
	b=TN9g6mAeY/0IZT1ime6zmMyTiC+8NILA6Fz64pP7FS5xFwR+ete+whBKnfWm9E5TnrKQ
	 29ZpZgo637x1efXKHvPCodhFLe4IXF4o53m12oycaQM7nEK9QuOkhKlyQWHaOQV++dTGE
	 yKMt5MQ8DBk8086Tmigpbj+HKYO6bo6iBGL7mV7Mk4FnS6ypIvJ1aQQ0M/1AElvK6AzVB
	 UdTbH1L/FMi1f1ZhMRocGdWEmZGKBrsF5KFvLx318CpQYIU2IjmZ60/v1ghuMGwoe2zl1
	 xymXpdSZgHYZfAXJFbWt9GheoGYSiXd3Vl6KUzi2ehkdIp7jZbaSslXWG8rxtsPbLnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpr5TqU9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A9A606A32C;
	Thu, 19 Nov 2026 02:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpr5TqU9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA7A1F000C4;
	Thu, 19 Nov 2026 02:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057056;
	bh=hzD7/EXRwUIlVwyLgsCM2oSIlCP96D+ab5yTtyPhs1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hpr5TqU9Q4eGAvQAXm9kNv4zGc0gSIzhxHBeof5G9+tqrZ9ChdKSxP9uTrwCUBYjS
	 zWiTWZBWLvopH7BvPtybH8o11wYTFtZyqnFNWlS2489V5vTl/C/QSZcVilRr/b8qUI
	 WlMIYFpMPm1kOcWTJq2toch9ecFsG0mcRuxvcgl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 2206/2214] selftests/net: fix EVP_MD_CTX leak in tcp_mmap
Date: Wed, 18 Nov 2026 16:04:42 +0100
Message-ID: <20261118150138.517953376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yan <wangyan01@kylinos.cn>

commit f4ef35efbb49527293309f668ea73ec5de9b8e7a upstream.

In tcp_mmap.c, both child_thread() and main() allocate an EVP_MD_CTX
via EVP_MD_CTX_new() when integrity checking is enabled, but neither
function releases the context.  child_thread() misses the free in its
common cleanup block, and main() returns without freeing the context.

This results in a SHA256 context leak on every run that uses the
‑i (integrity) option.  Add the missing EVP_MD_CTX_free() calls to
the appropriate cleanup paths to fix the leak.

Fixes: 5c5945dc695c ("selftests/net: Add SHA256 computation over data sent in tcp_mmap")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Link: https://patch.msgid.link/20260702025949.442523-1-wangyan01@kylinos.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tcp_mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -297,6 +297,8 @@ end:
 				ru.ru_nvcsw);
 	}
 error:
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	munmap(buffer, buffer_sz);
 	close(fd);
 	if (zflg)
@@ -587,6 +589,8 @@ int main(int argc, char *argv[])
 		EVP_DigestFinal_ex(ctx, digest, &digest_len);
 		send(fd, digest, (size_t)SHA256_DIGEST_LENGTH, 0);
 	}
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	close(fd);
 	munmap(buffer, buffer_sz);
 	return 0;


