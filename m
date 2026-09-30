Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C71A3A784F;
	Wed, 30 Sep 2026 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788644; cv=none; b=Klx83k+ZNReybbAjppmaDq4OuQrFQEbiRypNesI/Vg1aPyuaHAxSWp9KBIQ4FAT8mh+6BFAiH1fel3l6uyDShfToh/EZgyV3WSIemzvoTAlU+8Yz/5lcpjiUUigkchOigFKw9jV6sHt5DnuQp5fkWxzFj/y6VVetroJ1piKs/QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788644; c=relaxed/simple;
	bh=qGvoq4QlUQzesx/UsddI29Vk7dca25gNlNItkp8GgfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVi1XWw1kHM9czaISLgqdNlBOWlcCm+zd28nQJuc+7v92+s2Yv07JX8YtgAPKv5Po7dj+gn7xIx2kn28nqlyddPgNvRCB1lvxAHhyHW/u92pf40d0MqjGaVhETQLxQh5fYIQS0qE8ianQ2HXTzPwb9Nvbpz2hAjw1YZyWHKmSMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pir9kdLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pir9kdLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787EA1F00898;
	Wed, 30 Sep 2026 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788643;
	bh=kZXGdvIHMsEXWQEvw0LjnRwug5TyWCCkjjRKeGKyV7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pir9kdLBGbHvTO9r4mfEdIhh3gqB+tV0YqdN9RaJzQ/U/eDGPLxg8OeNDGP8NnL4s
	 OEVMMoYye6l/gYA1Maun1HgSdTyrxZfuuSgRPKGz2JxJCHvkM+eYCScFBQuFIcyPhp
	 ql7bobUiJyvPlLR8aAdFU+wKY4H1srwJmBpETJj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 196/877] net/sched: act_api: release tail references on DELACTION failure
Date: Wed, 30 Sep 2026 17:18:27 +0200
Message-ID: <20260930152418.954461612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 6e05e46fa821a5c1b281355f1f622ac76cb6080a upstream.

A batched RTM_DELACTION request takes a temporary reference on each
action before attempting any deletion. tcf_action_delete() clears
each processed slot and drops its temporary reference before attempting
the deletion. If deletion fails, tca_action_gd() calls
tcf_action_put_many() to release the remaining references, but its
tcf_act_for_each_action() iterator stops at the first NULL slot.

When a batch stops at an action bound to a filter, this leaks a
reference on each subsequent action. A later delete of an unbound
action can then return success without removing it from the IDR.

Walk the full array in tcf_action_put_many() and skip NULL slots to
release the references held on the unprocessed actions.

Fixes: a0e947c9ccff ("net/sched: act_api: avoid non-contiguous action array")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260910093413.34509-2-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1165,11 +1165,16 @@ static int tcf_action_put(struct tc_acti
 
 static void tcf_action_put_many(struct tc_action *actions[])
 {
-	struct tc_action *a;
 	int i;
 
-	tcf_act_for_each_action(i, a, actions) {
-		const struct tc_action_ops *ops = a->ops;
+	/* Deletion may have cleared entries before failing. */
+	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
+		struct tc_action *a = actions[i];
+		const struct tc_action_ops *ops;
+
+		if (!a)
+			continue;
+		ops = a->ops;
 		if (tcf_action_put(a))
 			module_put(ops->owner);
 	}


