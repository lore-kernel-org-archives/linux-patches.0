Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033467;
	b=OwxmUvO+2WF+ON8hBJiSlmBvWJGL90QpdgIbgVCV8kdEwA4xTI/LLwee/0QBh2PyQCfd
	 ZIjnirtP2eEctWFSvT3D/Os5PhzNuWpZpQSoqR7B/XKpZP+dU0Rx7uCwkz2iO+mXfj7IN
	 Z7hfwAk8N0ZjWJYZiU2fbgLiZuTVERiruD+rwc26wOna3TDVmhpd4HHrAv0P6PhmlP28x
	 8PMqfVPzKn/3a+sMMqbRmN9QWX+bbFJmJhNdRM3w4jHbHvDSfGRyRIRtzBHh77JUTlgJy
	 TKv4FI6hTjd/SqN5MP4Kaqjdcyev8D8T5j2EbkseSoeDWSQGkkDW4PGTVBwpANQnwyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rUDTIGqpntY890CNudxzLqXkOrlK9MIIMjzmkK5hReE=;
	b=MRQFIRoSgtnStBWtxYEvzYwFyzJskf95KBn0vzpAa2lrQsfgAtHb3V5yNU7GB+ErAXvO
	 XA0BDCLTkTuhL5XXBh2D4yurTPwSkjwv12NDqvctkBAuDGYGPzIf9mmSKsa3QCj+Iqh74
	 uI+dxDNbeklhKPamJmMCK6PXP8FBHTLJgXVVf+43DPV6kkoNrm0/BqH/LsVovJagYx/5a
	 eOkWWE1vHX1XF7a1SNKMYlQdo44uc9QE5czmWgzZOS2J64nYyhqP/VjWGVBfESnIphLeW
	 MPE7ei3EomCH22PHR1qDE+iPj4OvZLmHd5XPD4KGfzrUHoXQgpq64JieO6GjQgNfmwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owwngxRD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3C4606A32A;
	Wed, 18 Nov 2026 20:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owwngxRD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318611F000C4;
	Wed, 18 Nov 2026 20:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033467;
	bh=rUDTIGqpntY890CNudxzLqXkOrlK9MIIMjzmkK5hReE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owwngxRDYeO8EejpscqyqmuG41fRG4Cr5Geg+pSW1xYrpQqZDihKg+wcC5eaxYrYw
	 ekrqjUUn115W0GzQw4opbnQvt1wyiFKe+guAR34ziVU2pt91wTOaArIej2nCmJb1P5
	 caAg36vDHfnK2MLdLpHrorl84FQK1svklUvMw28A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0007/3318] mm/damon/sysfs: put target pids for damon_start() failure
Date: Wed, 18 Nov 2026 15:10:29 +0100
Message-ID: <20261118150313.852207568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 46980a4bef23a..d95fda1054a00 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1465,6 +1465,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		return PTR_ERR(ctx);
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
-- 
2.53.0



