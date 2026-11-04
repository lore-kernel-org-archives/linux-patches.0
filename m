Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829015;
	b=U1XkKu3iH+teABjyPtFsncxbqabxGScnD6elJZ6zWMhmyTK/ASxuAV3rLZ/UzLxWpldQ
	 jDZzkfsq93ljV7pP9Y9kQgYwRg12qbGFPsff+TM+oPpDBsojGfBzXcMsOlXx5riQht3Ff
	 nhZBHX7f37MnyYzvBQot/P30mi877aVYqpv0WiogHvvYzcrgeUzL1ScrMYTcC6L+vY5pz
	 fHGSs7chQGl4BTGgET4CuMg8wdrYctWZHR0KCeotHskmsyeSmCV+bGiZzx2xYOU3+k5Dn
	 s9NQkc+CRr8j3brCtJgqHUT64+Julpo2AQfZs4PgDS+OTJD1ChJAD2mk6n1dPnXlPEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TffNSX9jXcnhHzpNz5xvoRb1jpCqAkqXp0tHg2prKXc=;
	b=yP5TQ6aGSZ6keToGq265i8yjt5qWULO3m+9xANDeY93F8P89ldj1VNxKhAiCWUE6L0bw
	 tswSA5uaXL/W3ROKZeeudxNYYExK9zft5AdbZneTh0u4fUL51kkodvdiqV8BZzKjAY69B
	 oHbNtfGTqq5XJJ6aOkJV8GDjRMpWZUxKZ4TOhaVxACOotLz0etRPGkuz+3yPUM4BrSQEI
	 D6eCCRAJx7tm+Jnw2T8ABntwQD7l3/hA3h5LZ0KRAjmmvRp693hxSMoEMk49fs6RGncJK
	 rOHr6Bx93u2plkuzf0sTtC3+OEm5MAbeb80fa81Gsov/8ky76zw4LHrjGeKJbHoz8vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwUk4UoS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEF3607074C;
	Wed,  4 Nov 2026 21:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwUk4UoS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AAB1F000C1;
	Wed,  4 Nov 2026 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829015;
	bh=TffNSX9jXcnhHzpNz5xvoRb1jpCqAkqXp0tHg2prKXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwUk4UoSqgrRt/0o5d+7CBurOFk9z8xrUr6lDGKsTgVg1kedUcEA7uNXnwG8JmIKB
	 jvggIZrHWixA83QT0jeEW1a29eMRcIxomfdkMTvooLb9u8PO39bSeKhipClrj2s+Cf
	 ITMkGbsVIzZ4AIF2gHEJQRnOypjEP1jYc8AfLOT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 350/547] xfs: check for fragments when full-extent sharing matches
Date: Wed,  4 Nov 2026 16:08:54 -0500
Message-ID: <20261104211048.216240651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 95e213c1ddb40dfb0a8178ed35c9f29992a320e1 upstream.

LOLLM noticed that xchk_refcountbt_process_rmap_fragments returns early
if there are enough rmap records that overlap the space referenced by a
refcountbt record to match the refcount in that refcountbt record.
Unfortunately, it never checks the fragment list in this case, so it
won't find the discrepancy between the rmap and refcount btrees.

Cc: stable@vger.kernel.org # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -173,8 +173,11 @@ xchk_refcountbt_process_rmap_fragments(
 	xfs_nlink_t			target_nr;
 
 	target_nr = refchk->refcount - refchk->seen;
-	if (target_nr == 0)
+	if (target_nr == 0) {
+		if (!list_empty(&refchk->fragments))
+			refchk->seen = 0;
 		return;
+	}
 
 	/*
 	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)


