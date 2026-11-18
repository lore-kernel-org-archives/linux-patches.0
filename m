Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054035;
	b=tVHX4u7CTq8fI0jWCmMVGVeSjAKDllrSmVkLhzI7ZVht3WXCEHmCczUdrMKMPmt3p8Ni
	 /tlP4v880pMwnVwnw0CFGpeJs9yjDbbmibkct4zk9qdg9zCpQwON1H73F7+6S2zrqID6y
	 uUynVS/yw2QFaWbj+yAoHOaJHQ2nAWvSst15SPVx2bUMM3o2f5vFM8SmznxGPxMMCmMjq
	 AZUr2JaFbGWg/O6KHmlhEotSFgHbpW9NhxUB1pLdAxUke3TpBFN+9j6UiyRxSFKpxQy9Z
	 /57zrCzQuwbvO2kF5PnRvZ0VC2AtnbohyEBGA9YcMgO3xi5dDsFNiZAMc8/0vEJAgsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qpKH6l0q+O5H+59+dLBrbB+ZGtSekZme6nz6CKUPYDw=;
	b=qphVI9MPITnKoBvCFE4RbnAOnqC43zPv9gAOWI9U9NtGWCb8NCg75eTpkPTXIQ1bB0Ow
	 viC0e5TK+vMZ6lC+SHLp/LPYONtRBOIbi3mCqnB56NyLRteRUuAvKKnU68EJZ9Ne/T1Rb
	 JKaM+SjOoXLF78G068PM+BSt6u5vNieh31Ric/7wPL07uM6wb5MMv7o3a7rO3wz46v7qh
	 Tc1fotVrijgR3873ALqGuZzWO6tbeeFwKzQHlojokEo61lAN5U9QVhsRkcpPZ9Y1atCri
	 0XnCv+JuZlibkHf5Qrsya3mk0iAkW9JsG154jlgqBEm4VZOWCJmh7SaZxvJYMYeiBeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/S5SFGZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80316606A320;
	Thu, 19 Nov 2026 02:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/S5SFGZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D480F1F000C4;
	Thu, 19 Nov 2026 02:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054035;
	bh=qpKH6l0q+O5H+59+dLBrbB+ZGtSekZme6nz6CKUPYDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/S5SFGZt7EXMSCTy1To3CTVo86SbUS/A9+l0QnNEg5qbI1puEujL/qibLVMvECnE
	 t9PI4Ok325CJ127ciZtlp1EsVVyYthApnvvugzWdyDsiunydBFuNWBD5/VYE9Oi007
	 vH8d0e8WXjGcDV5LxxgA0AhXK6Yk+EcdyL9TrTfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1132/2214] ceph: fix 32-bit overflow in readdir reply count check
Date: Wed, 18 Nov 2026 15:46:48 +0100
Message-ID: <20261118150057.336765665@linuxfoundation.org>
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

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 52913831ba56efceaafd80b501d68fa00f79bde6 ]

parse_reply_info_readdir() checks how many entries are in a readdir
reply by computing the end pointer of the decoded array. That pointer
addition can wrap on 32-bit kernels and let an oversized count pass the
check. For example, a count of 0x40000000 with 156-byte entries wraps
to a zero offset, so the decoder can write past the preallocated buffer.

Check the count against the number of entries that fit in the allocation
before publishing dir_nr. Reject oversized replies through the existing
error path.

Cc: stable@vger.kernel.org
Fixes: 54008399dc0c ("ceph: preallocate buffer for readdir reply")
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ sashal: adjusted error-path context to match pr_err() without WARN_ON(1) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d1bac25eb3e72..e5040a67a14f7 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -363,10 +363,8 @@ static int parse_reply_info_readdir(void **p, void *end,
 		goto done;
 
 	BUG_ON(!info->dir_entries);
-	if ((unsigned long)(info->dir_entries + num) >
-	    (unsigned long)info->dir_entries + info->dir_buf_size) {
+	if (num > info->dir_buf_size / sizeof(*info->dir_entries)) {
 		pr_err("dir contents are larger than expected\n");
-		WARN_ON(1);
 		goto bad;
 	}
 
-- 
2.53.0



