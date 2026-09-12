Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E0433993;
	Sat, 12 Sep 2026 09:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203730; cv=none; b=m7JLy8nw6e8VhrOFx5kbNBgtBkcK9OtmhAuFRFylFVWpc8rwjV+g9X3aa1BmOXqyo0ofxAC5VfKnrFhAXb1TbEzWA45ucMJ0a4ibcA11Sq69TEEItLuVYOHyvijYaMDtzdbe3FPZe2HQM5yVvOEFkXZGH8nJHdAV/xXWSTuhejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203730; c=relaxed/simple;
	bh=GgW3QnO9SoZOCx+iiMezD1KRqhXZk4LEuCZuKa5+0NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR101FO/cYqXxsPXhYpbl4uZo554zEUuzM6lquP4Vf8quWI/+8f2M236ELgAJts4Sr0R7TGMmKvan+ff3gELG9uQch9ZdoKvipz5saQbyOB6K42mR/mK7dDOAj96kOUAwVyzR2Yy/865wLDRyUkqkGar58fN31LHkKvTSoYTgSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjaZtdWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjaZtdWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4131F000FF;
	Sat, 12 Sep 2026 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203728;
	bh=2r+qdAvE3yk2jcJVuFhVeXRXAsJK/qQ8Comf3UJ7YTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjaZtdWsYpgPyJfQeD0080CqGbaummk5zr2HrapyKmKnrzso3oT68Ok+gYZh6EGWN
	 uuhyvT0Qn2xXniLvHgHgxpB9Fs2i5eOLE4IOjvwE4jIm68WyYT5IxxtAOUF+/Xjs8T
	 dYihauYTMRqWXon+l4M+D/B1eBTJKIRcf8ywMgdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhu <zhuhui@kylinos.cn>,
	Leon Hwang <leon.hwang@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1424/1815] bpf: Fix UAF in bpf_trampoline_multi_attach_free on update failure
Date: Sat, 12 Sep 2026 08:52:54 +0200
Message-ID: <20260912065722.448793460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Zhu <zhuhui@kylinos.cn>

[ Upstream commit 0253073fb7d79a2dd2eae9581ea16db2aef395a6 ]

When bpf_trampoline_update() fails before modify_fentry_multi()/
unregister_fentry_multi() is called, cur_image is unchanged
(cur_image == old_image) and ftrace still calls into it.  Freeing
old_image in that case causes a UAF.

Only free old_image when it differs from cur_image.

Fixes: aef4dfa790b2 ("bpf: Add bpf_trampoline_multi_attach/detach functions")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/aaa3829e11e2e26bcd3bda9ee6df7a0101a718ac.1786412280.git.zhuhui@kylinos.cn
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 129d07db117ec..02c208bd2b637 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -1592,7 +1592,17 @@ static void bpf_trampoline_multi_attach_init(struct bpf_trampoline *tr)
 
 static void bpf_trampoline_multi_attach_free(struct bpf_trampoline *tr)
 {
-	if (tr->multi_attach.old_image)
+	/*
+	 * Only free old_image if it is no longer the active image.
+	 * When bpf_trampoline_update() fails before modify_fentry_multi()/
+	 * unregister_fentry_multi() is called, cur_image is unchanged
+	 * (cur_image == old_image) and ftrace still points to it. Freeing
+	 * it would cause a UAF when ftrace calls into the freed memory.
+	 * On success, cur_image is either a new image or NULL, so
+	 * old_image != cur_image means the image is stale.
+	 */
+	if (tr->multi_attach.old_image &&
+	    tr->multi_attach.old_image != tr->cur_image)
 		bpf_tramp_image_put(tr->multi_attach.old_image);
 
 	tr->multi_attach.old_image = NULL;
-- 
2.53.0



