Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058353;
	b=JU1nKxnjtkbdfsfo8GXS0pa6aEG4zF3lvt2Egx6s9t93RAJGNlhdWte/PwIH/BxbTH42
	 PQWpQgZKTCqfasoiWUuW1rUFpVOPar4wm9T/6bMSsUPHfsQbFMgSUkiXS6Qhq21B1OX5Q
	 lwzjkvCx8PIbeICCXC5VuvS3TsCQZ+q6nCPYPs9IMtmJsiBt2QuXMEHX+UdUHu/JrlOQl
	 uwQXwin6GFigDvEhgQMo4flLEReVeL8qxUNZn9/nzb3++dY47jSzYrEo9UgE7bRk0qFW5
	 ToAGojozO8xmpVy6OXWwaSyRDoPoGxvBpjSph0u6ec6DfKPd8AAsQ45+TD0iFwJVJLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7cu3AgdrROqnJuTOp5Yw/0KUF4DAcbuVtwG5M6EFDNk=;
	b=oSMo5NlgPQGLzoLmw6ElOnuCbCRRNjRkhY3z9cMY4iLXbak4eHWZZPkzYRyA8Sj3lErv
	 GBv/+Z39CNt4rR7PR9TIIy8mzgoh+pDFTJgHBnuMPhicKA8Mgu1AARBAO50qu5XPbWZym
	 zXA1S0qXiwIgW8fpz1KSda2RJTdpcphv01yxgbXpkwpUDdi8zZGu5LGNuSRtV5WnneEPr
	 C9ErQlfiLQdtAqSGgXlkA4/0Y29QuISwGEl4jk0RH/5uQkarSJvmc08piHymcdCyhCuQw
	 HAYwXgv66qycxHssiWMEv+ZE5lpL0zKjHvViNAKVH8Qsp9ZZYIAy/iusZ93JjN0MypQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cifcvBYp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E0C606A31C;
	Thu, 19 Nov 2026 03:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cifcvBYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E88A1F000C5;
	Thu, 19 Nov 2026 03:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058353;
	bh=7cu3AgdrROqnJuTOp5Yw/0KUF4DAcbuVtwG5M6EFDNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cifcvBYpLOF5I/nc+9kIPvArqGgvS9o/klsdLsgQ/Wt8ZZYT8Hm7SXS6hlYFQ9+t1
	 KpdiBHIqeuXtVC8W1qGYWYmyPtJChd5Dav0jE9u2aV3iuNXT6fvt86rUWG/c7h8O6a
	 AjdaUX1iB9mVE4S+iMNPynXEO7w1ydjIGKMJmRyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0456/1848] dm-writecache: fix a crash if we attempt to use non-dax device
Date: Wed, 18 Nov 2026 15:41:34 +0100
Message-ID: <20261118145933.566714063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit b15dc73f60ebf02410bc7014ce34fb7fd1040045 ]

If we specify a non-DAX device as a cache device in the 'P' mode,
dm-writecache crashes on NULL pointer dereference inside dax_synchronous.

Note that this is not a security bug because only root can trigger it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: a46624580376 ("dm writecache: reject asynchronous pmem devices")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 13cc318db012d..5124331a66f8d 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2335,6 +2335,11 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (WC_MODE_PMEM(wc)) {
+		if (!wc->ssd_dev->dax_dev) {
+			r = -EOPNOTSUPP;
+			ti->error = "Cache device is not a DAX device";
+			goto bad;
+		}
 		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
 			r = -EOPNOTSUPP;
 			ti->error = "Asynchronous persistent memory not supported as pmem cache";
-- 
2.53.0



