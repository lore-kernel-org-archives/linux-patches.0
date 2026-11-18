Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042882;
	b=kXfT0V3Ir1tNj4ZYLHKx9idBdbb2aSeXy4yqFV1ch+X71VsXNEtg9U+Llx5NAKTdDE5V
	 2JJOty+KP2iKBLZjp5sZ4d9ty+IKqbDGoAR39azsUCsvwbVquE3rcfyYJCcWnqtT+icq7
	 fL4LWn3U17O+fa5x3wTWPkXubOlTssSdLCJgr3+ySjD77gzyGSDryIxCPqYIO7iwjIZkf
	 7/yfsyWh9i05YXIP+aKnJtJ+l/6k+5Vl+vAHSLElXo7zTzhdjkrVhNkAxWH5NQgZfCFS1
	 qJ/1gwJ51zHETUsrVmw4Jbxq2xqJ+VbP3CuMlexfn0eFJx6aKWUZELuqebxEX/iESHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H92IImXn8v1gkxuFdTmfo7LSFBL8li3fahRMeEOiYKA=;
	b=i6ENUYZKV35Xji+y2Ym6OMXh1jMZHFyyVN82W/c1s0aVocUFzOwiT2sWRFK2sz90QUoG
	 abA710YUXilxFPLMCozGHcAJutjSXU3QQkU5teo3wHymskWacARnVCZLeofV3sD+EE0aQ
	 vmzBF1QdUYAVOgji0CGt3KWxLC9FlEfMpoi6ZcNmZbUdy8zvQy4Y4z0HPMAbRJWuLbF8r
	 opiaJZwVxZ/RXtHZGyB0phmyyfMvOYrgZ9ggG8rJaBJzdtZLolYRzk0vc4m4gcHyUi+Ax
	 us57jR8vzRYG1oKNyXYWSfTYQgKrlB1xdBVqmhPLwbSGAs5ULgnsonVEplX323KouEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+JHz4TX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF7E606A32C;
	Wed, 18 Nov 2026 23:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+JHz4TX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327441F000C4;
	Wed, 18 Nov 2026 23:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042882;
	bh=H92IImXn8v1gkxuFdTmfo7LSFBL8li3fahRMeEOiYKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+JHz4TX2aG1iMG/z0NsCkM1btDw00XrVegpPoNmHPy8oL1vnW12sGr8RdGPEelbq
	 4Aa2BrgysTSWv6AkbPsA+OPwTD0I2u8cQJkhbormQfeUq4qFQ0hrrHwbv1ELRmcJbG
	 R46//aYepPkt5+yCD8XGwaZ3IMGBw+swmCht6/Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0006/2857] mm/damon/sysfs: put target pids for damon_start() failure
Date: Wed, 18 Nov 2026 15:17:20 +0100
Message-ID: <20261118150201.551181837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

damon_sysfs_turn_damon_on() allocates and sets up damon_ctx to start.
If it is for virtual address space monitoring, the setup increases the
reference counts of the target pids.  After the setup, the function
invokes damon_start().  If damon_start() fails, it deallocates the
damon_ctx object without decreasing the reference counts of target pids.
As a result, pids can be leaked.

Fix the leak by putting pids using damon_sysfs_destroy_targets() before
deallocating the damon_ctx object.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 9a918f8e4c6bf..4b28bb9ba0a24 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2547,6 +2547,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		return PTR_ERR(ctx);
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
-- 
2.53.0



