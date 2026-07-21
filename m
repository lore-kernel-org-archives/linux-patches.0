Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7A8415F33;
	Tue, 21 Jul 2026 18:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657363; cv=none; b=cFXwrxQOeQ8i3MH9Qd8vQNAx8+OTykEI7+ENGbLdSyIbotEbPdKj+FXgN3C2sEtzwz6RoRLc6GizKe8iLDS5oWd03vPRjgYLyX1vqld10ocrBZCfnwv+pmAVht2IVwKIui5n4wH5LI2TOFtmYFL7d+ScEE9w8aaMdjhkPtLjLls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657363; c=relaxed/simple;
	bh=MqKoXstsUY6eP6RCxpNQxrJp/AZRE9eSKFGC0J6BAPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZk13LRMYaJbjGlpAncSRWlj9284fvu5jYTPPuNINtp4NK7r+x3bbHhD9YqOK81xBMRRwpCPitMWgHGdrUp9JaleUMY7ayBp+snyTMpZff7B7hXqLWtpV9Ymnqm6QyV6EM3nVRGIKDd6Lp3iNZX1RQAAbQ+BJMiIUuQNXCNBNo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHAGYOY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHAGYOY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C0E1F00A3A;
	Tue, 21 Jul 2026 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657361;
	bh=cdixEmNQshZtZbIl33dNVoOZFoe2+UNd3A4Kv31qihk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHAGYOY18B6AwDmTMbJOEM5tjCD2Y6KFbYN49Z/U04g32gAVwIN0vduNuxmWHn+YZ
	 cmv66TDjaFla4tD8nC//tXpVbouxEVxuqL/S6J4OFnza8ENpPVvzKFmtwC1LkBVF+S
	 yK4XH5Wa+eFYQShBAyi479n7orFlglv2a7MliEQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0735/1611] apparmor: fix refcount leak when updating the sk_ctx
Date: Tue, 21 Jul 2026 17:14:11 +0200
Message-ID: <20260721152531.912257992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 6d25e7b47616cb2db43351210929c8f19dc305a3 ]

Currently update_sk_ctx() transfers the plabel reference, unfortunately
it is also unconditionally put in the caller. Ideally we would make
the caller conditionally put the reference based on whether it was
transferred but for now just fix the bug by getting a reference.

Fixes: 88fec3526e841 ("apparmor: make sure unix socket labeling is correctly updated.")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/af_unix.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/af_unix.c b/security/apparmor/af_unix.c
index 81cba79f7aa237..1e061345c0b160 100644
--- a/security/apparmor/af_unix.c
+++ b/security/apparmor/af_unix.c
@@ -674,9 +674,11 @@ static void update_sk_ctx(struct sock *sk, struct aa_label *label,
 		old = rcu_dereference_protected(ctx->peer, lockdep_is_held(&unix_sk(sk)->lock));
 
 		if (old == plabel) {
-			rcu_assign_pointer(ctx->peer_lastupdate, plabel);
+			rcu_assign_pointer(ctx->peer_lastupdate,
+					   aa_get_label(plabel));
 		} else if (aa_label_is_subset(plabel, old)) {
-			rcu_assign_pointer(ctx->peer_lastupdate, plabel);
+			rcu_assign_pointer(ctx->peer_lastupdate,
+					   aa_get_label(plabel));
 			rcu_assign_pointer(ctx->peer, aa_get_label(plabel));
 			aa_put_label(old);
 		} /* else race or a subset - don't update */
-- 
2.53.0



