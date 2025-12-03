Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CA830BF65;
	Wed,  3 Dec 2025 16:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780053; cv=none; b=GAZ8SA4H1XGGj3CYVIJHGhyZU5oE0s2hszQBTvTzFRhd0bm04FtAZLK2LNvQKTYIDrQyNZSOaXp5EXxph3b4YrQ1yU4h+TGrUt6pL01A66EL1gEZmgf+VLt79U4a6ZSoVs7NfT3fVtP5+g7/EBK4X4WUINeF6umjAvzbF2PL0qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780053; c=relaxed/simple;
	bh=+aG8K6BqPjMRc/7SYKNgGOGpfRyGjfyUDamw2bjAAZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2me616U2YbYgH4jZEki7FwBQwDxdqLqGMEmqJ7M16Tt9sXh71TgTmC1NxGrXmA0nme/IVtumefvC6j7k9tGi88jDyW6MaKp3eGqisQXszztICev+ErSz7U862N+LfnXQH2GSdNneCARutG9rL79mdaSLfsBHMe7bTf7eoFLvLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADNiVzCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADNiVzCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB05DC4CEF5;
	Wed,  3 Dec 2025 16:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780053;
	bh=+aG8K6BqPjMRc/7SYKNgGOGpfRyGjfyUDamw2bjAAZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADNiVzCrERLu25uoOxHU482BPtvgof/stzjN3H6wIac+VFUsbnAdXE8WsHZM+CKDz
	 72HV8xhtV0UEVHYlJQ6PztH5S4a76Es+Lpm0/4w5ES0sa1ts2B7bqvUiiN7NU//APG
	 TpyYW+WN4WDT7YEpfHmyflbhpHe+yZ76LdSdA5b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 424/568] net/sched: act_connmark: handle errno on tcf_idr_check_alloc
Date: Wed,  3 Dec 2025 16:27:06 +0100
Message-ID: <20251203152456.227151401@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

commit fb07390463c95e6eef254044d6dde050bfb9807a upstream.

Smatch reports that 'ci' can be used uninitialized.
The current code ignores errno coming from tcf_idr_check_alloc, which
will lead to the incorrect usage of 'ci'. Handle the errno as it should.

Fixes: 288864effe33 ("net/sched: act_connmark: transition to percpu stats and rcu")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_connmark.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -156,6 +156,9 @@ static int tcf_connmark_init(struct net
 		nparms->zone = parm->zone;
 
 		ret = 0;
+	} else {
+		err = ret;
+		goto out_free;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);


