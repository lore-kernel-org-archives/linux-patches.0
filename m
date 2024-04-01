Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E089117552;
	Mon,  1 Apr 2024 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987032; cv=none; b=kSBlMz0VWSrFyZ7DqLjxFUTMb+OiuCF3znleajGyfldQ8MQ1ZnqJTfeqEXPgGC6hoiLP1TaIh/HIEWQYZQDseqC2tmi2UFWxl0LRcGga04VR0b92s8Ka0LXallhcgr6vNrp5FaHq+N7VoQkbcOLL0EW+ojuKqSmoT9aQavDogSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987032; c=relaxed/simple;
	bh=5pKqjeKhGIVt29of9DMyrkXMqK5LH+/o/q5HVGWnP9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JiaTpuOAohbEo3OXX3dIF76q6xR5RmwGMvjkYnwym0e43bKYR5jj1gMlLn6YdE050h0St1HvoihSzf5QgP6eBGlFxQDLmkTnn7r8iXtFSvsJLVCYOm/+nZrwHOyEuoehwbXD+nOdDNyC61IZ/ozmmJ/4jKKgmJL6MMt+4GCH99w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xv8Yhatr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xv8Yhatr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01358C433C7;
	Mon,  1 Apr 2024 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987031;
	bh=5pKqjeKhGIVt29of9DMyrkXMqK5LH+/o/q5HVGWnP9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xv8YhatrCuCA3Qid9OzjYkFd2iaN1Ea5juT6MnGBuSbYSiQuE5D4reiP54xcPYaOu
	 HBBy5Tn9VA+QOsx2hQ6omAlfuCPsrqq4iYBIadVF8OtYffMed3+Ggon5U4E5ylNnB+
	 IpUHL+mvGIPH9pjhq3ccgE9m2l7YBgwlguLNNat8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Valentin=20Vidi=C4=87?= <vvidic@valentin-vidic.from.hr>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 161/399] dlm: fix user space lkb refcounting
Date: Mon,  1 Apr 2024 17:42:07 +0200
Message-ID: <20240401152553.989174562@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



