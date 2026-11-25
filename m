Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620861;
	b=FtPU4GXCpzHUJHXJtATpWIfgqrD2jSScESg05NJDkOchbseVGq26ao1GoScO/dWRgX9n
	 5iW+wecfpPxC6OZrSZb3km1YUDizYyOId0iSzT+N5OyQ+1GvNoF5UGzQXKK4btMRFBXpB
	 F2tbLM0SsOra1MX5m3imhqgdLwkF+hznPVC/I5fGX/n0FJiYwwOfpSgyM/z4mrqwf65Ei
	 bANaIBOf+HAoPg8Ue3RVR0s7lH2tUyT5KNremQFo2izr6LieHD8A9TDPPPGqdrJoXcLky
	 l6PnxQRFwVfIwWq6Jv9hXzpueN/uVsRDgU2CZ2reH96k1tDl8kQ/kklR6soQY+UwxIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sb8MxmgoJ5KEu4jKSFqhov6RIzu2XKU0TGaCGJQq0/k=;
	b=KQh8++fO+McfjoYKliLfQGI/oU54NrJXzJUg0zDniV6O1WXUOvgak3x+Xu3SmJ0p+Swh
	 RQL/rBqYFMi8GdVKxD3yvfTESBlxW28hkYI9qXdVDDd2zYk8NZ7vikNMr113+hiaLHq3G
	 Fe9f+VVbCHItgDZk+Ro4fZ5WH+myx8XJ3HX08yiZJkJbxy21pi/O+ggXGfJRhXRCcn/y+
	 UC1WSSWTpU6vnWasr+fFaaQHRC5sdzp7EM7qx0n7HDGksr61ITATL1ENR4LXrRtgeX1qY
	 VAHP81xvVKjlE0eYwXUmm9/ggEPklXDCtXXtdo8Ni3mWriyAFHU+aGDf+S5fppz3Mbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IPvYd3t/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E46606A31E;
	Wed, 25 Nov 2026 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IPvYd3t/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281321F000C0;
	Wed, 25 Nov 2026 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620860;
	bh=sb8MxmgoJ5KEu4jKSFqhov6RIzu2XKU0TGaCGJQq0/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPvYd3t/iAQ6J7S58zCZjzCXImVl9911vBbVV+KCAlol0b5P+k6jiU4xKcjZe/ihe
	 y6rpx0vXST6A+lhQ/hYXXY7o9Nh5EY7fi87n2hnpiElUR2/BTb2ClVr++kxbAKhSqW
	 gLvlUzNSDFTL4BYto+QErqqQRBcNxgw7JrkUw2+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/990] io_uring/futex: fail soft links when cancelling a wait
Date: Wed, 25 Nov 2026 15:23:32 +0100
Message-ID: <20261125143823.147344748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Commit 9a7cbe50dd95594d6fb3c57b8454ace58d8d8d0a upstream.

__io_futex_cancel() completes the request with -ECANCELED but does
not call req_set_fail(). IOSQE_IO_LINK dependents then still run.

Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20261114072246.741950-2-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/futex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 6f756de08705d..5986ce2a121e0 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -104,6 +104,7 @@ static bool __io_futex_cancel(struct io_kiocb *req)
 	}
 
 	hlist_del_init(&req->hash_node);
+	req_set_fail(req);
 	io_req_set_res(req, -ECANCELED, 0);
 	io_req_task_work_add(req);
 	return true;
-- 
2.53.0



