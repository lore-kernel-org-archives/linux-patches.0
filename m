Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222784F3EBA;
	Thu, 17 Sep 2026 17:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666694; cv=none; b=p68cliRCXGX9iMluK3qyVKHWujxKANoManJAuLmbMr/bN3ibbIxZXbOW6zn9ZA4CS0PolpchR0/NArQDLkpg076mSAlxqQb992VJOzIgjYWKjIdmLTo9kLOhEIDujoSY5GAzoKax9IAzSAOZGUO2bUzUo9TnJB1zWvZSFHPhjk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666694; c=relaxed/simple;
	bh=FbL8HC6XKxDoinu5bVj2CB6eSfzSntg5cJKi8dVkILA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bphcEKbdPlv07386Hbr6qLQKrmCujKotsHd0WcJIfhIkc72b+NhbbfCahD6HAqmCgw5rZf6AItyU4tQbwHigMk0WvbKn0eBtLigCldQptfDp88fbR6dFf2vYJvcfc0zkXzCvVvcPO19kHd2/ytlp3nPhERIlPgZqAinvWLOhwZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJUDQ7J+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJUDQ7J+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3801F000FF;
	Thu, 17 Sep 2026 17:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666693;
	bh=N1HM/V+qV+lNEKvD5ERwXc2N50t+w7FP0teGrABttqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJUDQ7J+TdsGztk3PPVwgdziOZi92CpJCCel3sK16Q66y2L83vid8vBMQniLKJ9Aw
	 41K7iMMa0aEG3x4Qr6ECIlzP3uIPTwAibSOaxIm8cGt6PkCejtwYaU2f2W8rvGBvyy
	 7F/suRC8s4LzWMnGNR4u/FpbQBzHDixqZQJVuu20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1105/1250] xfs: fix short ifork reaping computation in xreap_bmapi_binval
Date: Thu, 17 Sep 2026 16:15:00 +0100
Message-ID: <20260917151622.136725864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit eacb8479507756c3305994e87fb2fb1183827e98 upstream.

LOLLM got really confused about the update to imap->br_blockcount in
xreap_bmapi_binval if xreap_inc_binval returns false.  The intent of
this code is that we shorten the imap to whatever length of space we
invalidated so that the next iteration through the loop will start
wherever we left off.  Unfortunately, the calculation sets br_blockcount
to the amount of *unfinished* work, which means that we pointlessly
re-scan blocks that we already reaped.  This is benign, but we should
fix the computation anyway.

Cc: stable@vger.kernel.org # v6.10
Fixes: 5befb047b9f4de ("xfs: add the ability to reap entire inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1400,7 +1400,7 @@ xreap_bmapi_binval(
 			 * far we've gotten.
 			 */
 			if (!xreap_inc_binval(rs)) {
-				imap->br_blockcount = agbno_next - bno;
+				imap->br_blockcount = bno - agbno;
 				goto out;
 			}
 		}


