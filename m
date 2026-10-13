Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0686A4F475B;
	Tue, 13 Oct 2026 12:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894990; cv=none; b=NX7DtptgX/bCxvQyzw2Z/g5rVrt2aC+1Lr6GDuHvKicy9SfqPdfMN4rJxzhj/kjrOJYyOM86LqW2MNfjN6dQBJP7g8lp5tdpUa87H31s39eVOo/1129H4Gsz2i4WMWnon4c6QmAYDG9D7jPtkwb75hzmBGgxWSV9V3hEoNiKLCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894990; c=relaxed/simple;
	bh=+85fvh2+kdC1Mvv57i3UCHpANLKe+YMGnZcKSQfWyUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sX/pkTdvYbHu+ZjmBdeJVXG8INHuQQM9Y89D6m2pAoRIKWVoAGGafbiXCuTPpGRP30Rdxw20iKI96d59NJ7X8awLNLQFBXXf1a18vUJ2eOcvkbqKK+WB+KeRFYfIv55FWATa/4iWTs/xjgYc36V+JpVRVf76WNkt3HJamgUsVAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AW/2J+aU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AW/2J+aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6291C1F000FF;
	Tue, 13 Oct 2026 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894988;
	bh=lBq/yDD2yrPrB5S3Mdr3GbB1YU2hi2Iq+7pYDdKnIlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AW/2J+aURBEN+Baj4QRIAETqX17EAXTeN8AUjr+Q4KuZY12V2ulkTsDAE+CvAvL7S
	 OmkRjKIFl8KFqM+AD+7OJ0lK+3WDoQLXZqgqQzaKUyYU+Bq0xnSresvoJAbi3CsmPz
	 VbNTrCQ6An1BETUnK/B/IaOuk9bliz6ubBhgFNeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.12 123/497] binder: fix is_failure flag for superseded transaction cleanup
Date: Tue, 13 Oct 2026 13:34:50 +0200
Message-ID: <20261013112910.811169286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomer Pomeranc <tomerpo@gmail.com>

commit 22c135635fdd9816c0ef140d6de7b2e4fdf73e89 upstream.

When a TF_UPDATE_TXN transaction supersedes a pending async transaction,
binder_release_entire_buffer() is called with is_failure=false. Since the
superseded transaction was never delivered, binder_apply_fd_fixups() was
never called and no fds were installed in the target process.

With is_failure=false, the BINDER_TYPE_FDA cleanup handler interprets
stale buffer contents as installed fd numbers and passes them to
binder_deferred_fd_close(), closing unrelated file descriptors.

Pass is_failure=true since the transaction was never delivered to the
target, matching the semantics of all other undelivered-transaction
cleanup paths.

Fixes: 9864bb480133 ("Binder: add TF_UPDATE_TXN to replace outdated txn")
Cc: stable <stable@kernel.org>
Signed-off-by: Tomer Pomeranc <tomerpo@gmail.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260812195316.259136-3-tomerpo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2926,7 +2926,7 @@ static int binder_proc_transaction(struc
 		t_outdated->buffer = NULL;
 		buffer->transaction = NULL;
 		trace_binder_transaction_update_buffer_release(buffer);
-		binder_release_entire_buffer(proc, NULL, buffer, false);
+		binder_release_entire_buffer(proc, NULL, buffer, true);
 		binder_alloc_free_buf(&proc->alloc, buffer);
 		kfree(t_outdated);
 		binder_stats_deleted(BINDER_STAT_TRANSACTION);


