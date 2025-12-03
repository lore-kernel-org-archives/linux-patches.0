Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5C8348440;
	Wed,  3 Dec 2025 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778334; cv=none; b=p5lqSwNmMTqdq7sbBj81PWPBBPY/mhkJanq9zgWC9XPiXeiL5v15eAkERZW3xLzk3jnBqge1Krs6bd7gMQna3RNGM1wHIyemZBTOu7ZbqxlVILnaWUGNyu44RwSWkc7+hnzB1KYc8jnrlA5+tNe3xvelXwrRD54/kRhOjFKzedQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778334; c=relaxed/simple;
	bh=PMea5S1fHPbFIiJp7TCc5QTncc1kAuoUXASEaiKqJDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnvN++hTUN/39knDuYU93COwUMzea7Y8nybyoFIJ9bOdoUFa7Q06J3pT+jxLuIBYLOuoXx8TbM3nn49zvXTo3HYqrpqVtPw9sVCcfsn/qrSeIuFDjyApbMBUsoAhV2solBdajg005lJ3wqVbwJco6oIbopqX4Co/8Jau9WTw364=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMHjPQfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMHjPQfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5ABEC4CEF5;
	Wed,  3 Dec 2025 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778334;
	bh=PMea5S1fHPbFIiJp7TCc5QTncc1kAuoUXASEaiKqJDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMHjPQfHmrMuwi7aiKNECaaBB5SrVcKqIML2mjeK7l6KaK7B6yR37iwi2yMddSpwm
	 U6YVIpg4hrxiylTn/oImPECGBrNmNRzh6uzRKD+qQGOUctyySptKnw+xlaR/zZd+V5
	 ug9AYoz/pxpdGBjUYBXTqCKW86aWZqGse7+9/1VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 281/392] net/sched: act_connmark: handle errno on tcf_idr_check_alloc
Date: Wed,  3 Dec 2025 16:27:11 +0100
Message-ID: <20251203152424.499966704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


