Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567C07B3FA;
	Mon,  4 Mar 2024 21:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587938; cv=none; b=WEMSup/8xGbchasIAHqWg6tY8Jc/aMdWEBv4/G/c9TNk99ITmvYloT2yjju/02F6OhMvtCaTTjb8RoffC/6pTbQC+dp6SBaYBA2fFcDEerUJP6nVuW5aR9bzw/5T9XMGBjHVGH1X8RR/um/ZY03PgHlD1kjzeh0i+iukel73qhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587938; c=relaxed/simple;
	bh=AOWPsOyynpCaS7Ghuj+1m4LIzvm5O4YWusneJ9YzQhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrG5EjXiDyYMJvVe2zq93LzbnE4145EpMfVfrgKc+Qz3089CanHpz80WMbWx2exEt9s4VoE5S5ONlsoAVXQe75+aghzOx/F5diRd9eUD45Yj9v/bngjsuVc6g5W6tObJsA0A5ju7u80e5pqhkiXbLJLjx5fb+VECyESgjIi0d/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGm/Z6Xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGm/Z6Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF64CC433C7;
	Mon,  4 Mar 2024 21:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587938;
	bh=AOWPsOyynpCaS7Ghuj+1m4LIzvm5O4YWusneJ9YzQhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGm/Z6XuGeokKYa1lulJGnJIxZo9QJctTcZ1sMHuJfUjfUkxzH7j5Jw+/wDCm0K02
	 OTZ8etGGwbvSdzxgOXpS7d8S+UTsTOtRlfaR7gcgFF2TYVVHAVatvOFBDN/5beIVqw
	 ouE2rXuIVYsp4vs8lN6yHQvQpEIjfrF64ilefb1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 123/162] mptcp: avoid printing warning once on client side
Date: Mon,  4 Mar 2024 21:23:08 +0000
Message-ID: <20240304211555.683796804@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 5b49c41ac8f27aa3a63a1712b1f54f91015c18f2 upstream.

After the 'Fixes' commit mentioned below, the client side might print
the following warning once when a subflow is fully established at the
reception of any valid additional ack:

  MPTCP: bogus mpc option on established client sk

That's a normal situation, and no warning should be printed for that. We
can then skip the check when the label is used.

Fixes: e4a0fa47e816 ("mptcp: corner case locking for rx path fields initialization")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-3-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -981,10 +981,10 @@ static bool check_fully_established(stru
 	if (mp_opt->deny_join_id0)
 		WRITE_ONCE(msk->pm.remote_deny_join_id0, true);
 
-set_fully_established:
 	if (unlikely(!READ_ONCE(msk->pm.server_side)))
 		pr_warn_once("bogus mpc option on established client sk");
 
+set_fully_established:
 	mptcp_data_lock((struct sock *)msk);
 	__mptcp_subflow_fully_established(msk, subflow, mp_opt);
 	mptcp_data_unlock((struct sock *)msk);


