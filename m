Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E56A33ADBA;
	Tue, 12 May 2026 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609414; cv=none; b=cg49k1POs9JMbck0lTyXclK1r/Pfnt5FaCk6J0nzhhy23IsQYl4qjVcI1rVSDbw/hCL9ctP5eYRGnBzOijTWXyFI9mJPeFqQGo+sHt2AljEUQAzTcxCRJtsxqgdSvpNGu3EeDQeEtLhzK+O4onaET0KDRnBS0ftPVRUyl2yG1uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609414; c=relaxed/simple;
	bh=9pmw+mWZNKigYH7rjiS9+2Nu8JS9HFf90xGTx1LyGr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5e19ielg1/6i2P4nYl7GAb+5Lh8eOCxy4Tsj+zxGn+xxIt2aPGAAE2TNKmAxxKBVoMDW4rZf6lt1JxsZxJQIafe8iyGsrukeRNyXrUGOZiPwY06tBhdLHG5oFxk9bjs9ykYjknmTuTvOqPOjT99UOhCWrK9bHIAS4r3F+ifG8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVDSZfwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVDSZfwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0682EC2BCB0;
	Tue, 12 May 2026 18:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609414;
	bh=9pmw+mWZNKigYH7rjiS9+2Nu8JS9HFf90xGTx1LyGr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVDSZfwJ5c00nryI76R8VSB7l049S7XHXR7rIS5IqpTHfwQkjWgOnVxL51AKUBHX/
	 f4N8/zrc4xWRHrrWRkgfD9ScVhJfnw0jZ0wnWSmoJNf1TFhmyLggxh5qSCFTnVOgn5
	 t5XVHz6LPMkmvzyIqwDgCR1zRGJlGt1IPSFskaqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhankar Mishra <shubhankarm@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.0 186/307] dm-verity-fec: fix corrected block count stat
Date: Tue, 12 May 2026 19:39:41 +0200
Message-ID: <20260512173944.041956189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 48640c88a8ddd482b6456fcbc084b08dd2bac083 upstream.

dm_verity_fec::corrected seems to have been intended to count the number
of corrected blocks.  However, it actually counted the number of calls
to fec_decode_bufs() that corrected at least one error.  That's not the
same thing.  For example, in low-memory situations correcting a single
block can require many calls to fec_decode_bufs().

Fix it to count corrected blocks instead.

Fixes: ae97648e14f7 ("dm verity fec: Expose corrected block count via status")
Cc: Shubhankar Mishra <shubhankarm@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -163,11 +163,9 @@ error:
 	if (r < 0 && neras)
 		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
 			    v->data_dev->name, (unsigned long long)rsb, r);
-	else if (r > 0) {
+	else if (r > 0)
 		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
 			     v->data_dev->name, (unsigned long long)rsb, r);
-		atomic64_inc(&v->fec->corrected);
-	}
 
 	return r;
 }
@@ -439,6 +437,7 @@ int verity_fec_decode(struct dm_verity *
 	}
 
 	memcpy(dest, fio->output, 1 << v->data_dev_block_bits);
+	atomic64_inc(&v->fec->corrected);
 
 done:
 	fio->level--;


