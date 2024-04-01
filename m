Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9178447A6B;
	Mon,  1 Apr 2024 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989750; cv=none; b=Ejz2SUHgbPQHr3MWqAQ4FCsHcg10sIYeMLhhnW6K1tnqc/f1PII2Bjtbz8mbYIqp3VEjtsLKs4L6NFkf2K0HeJKcyUwPAczhgzibGHqZ+B+hq7NrG94KdYUqhFdEMpeEBnjebHbZX10SC7YziVERgf+ac5c3vxzbXuCTG0FQL5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989750; c=relaxed/simple;
	bh=A4Jr9IxONjoDv82G+ay2AmyrN/DMrYqZ8Pp4csmyWVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fv8MyPmYh285Ck+FhHFgHVMKsIDpG8T1Z/2Tea1FpZ6kfKUjRhXpYuxEnFYJTDQEytlWEWuH30wvGnd/Arf7Sx2KIiCgAWekwwf6tlh5sDEuvIlxk8WuQWwAE/kRguBQhgryIxmWFtB6C/mVLdB1GuedRSfckwOMTaI9d8J1O8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w17hQhmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w17hQhmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA26FC433F1;
	Mon,  1 Apr 2024 16:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989750;
	bh=A4Jr9IxONjoDv82G+ay2AmyrN/DMrYqZ8Pp4csmyWVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w17hQhmNrQfQxmSGMnjI6oEVLJzbrLGQPo0nuk6DjrticnG7Iklu9cCgJa03O/j/D
	 NYS7jeI2E/1Sy4HwAzkeSmcKyUIpqs7NCzmhKMfD/pkPDgQNLAH5sgXMrQEz1uTigb
	 yCyYzhVhGrRBk3y2+Cl1YmXp4mP4U4O5P5iyly5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Valentin=20Vidi=C4=87?= <vvidic@valentin-vidic.from.hr>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/396] dlm: fix user space lkb refcounting
Date: Mon,  1 Apr 2024 17:43:10 +0200
Message-ID: <20240401152552.123077702@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 2ab3d705ca5d4f7ea345a21c3da41a447a549649 ]

This patch fixes to check on the right return value if it was the last
callback. The rv variable got overwritten by the return of
copy_result_to_user(). Fixing it by introducing a second variable for
the return value and don't let rv being overwritten.

Cc: stable@vger.kernel.org
Fixes: 61bed0baa4db ("fs: dlm: use a non-static queue for callbacks")
Reported-by: Valentin Vidić <vvidic@valentin-vidic.from.hr>
Closes: https://lore.kernel.org/gfs2/Ze4qSvzGJDt5yxC3@valentin-vidic.from.hr
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 695e691b38b31..9f9b68448830e 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -806,7 +806,7 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	struct dlm_lkb *lkb;
 	DECLARE_WAITQUEUE(wait, current);
 	struct dlm_callback *cb;
-	int rv, copy_lvb = 0;
+	int rv, ret, copy_lvb = 0;
 	int old_mode, new_mode;
 
 	if (count == sizeof(struct dlm_device_version)) {
@@ -906,9 +906,9 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 		trace_dlm_ast(lkb->lkb_resource->res_ls, lkb);
 	}
 
-	rv = copy_result_to_user(lkb->lkb_ua,
-				 test_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags),
-				 cb->flags, cb->mode, copy_lvb, buf, count);
+	ret = copy_result_to_user(lkb->lkb_ua,
+				  test_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags),
+				  cb->flags, cb->mode, copy_lvb, buf, count);
 
 	kref_put(&cb->ref, dlm_release_callback);
 
@@ -916,7 +916,7 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	if (rv == DLM_DEQUEUE_CALLBACK_LAST)
 		dlm_put_lkb(lkb);
 
-	return rv;
+	return ret;
 }
 
 static __poll_t device_poll(struct file *file, poll_table *wait)
-- 
2.43.0



