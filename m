Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050781;
	b=DGSxb5YhilXVNoTY3piDBXZLMI5/MN05PUGhqaU9zgK5yLvd996JiH/0wyaEjezT2zU4
	 dDhl33DbtfWpltm9bu6E5RufT5sBkbBGuZ+e7cw5b83kBpUFcysqPk8FhE70hiHeHMsKB
	 wITPUAPdCZ038PCWVUY3SFAAv+Bdjxi0EuEpm/OWhKP7kTgSEINh3HwstnWXheVbi0bGY
	 M9gAi4ZapucJgzyDmwhrLZVAopujCNtqMOVKFj03mLURLrdYNNEZm4RwzamzE4T3t6VLx
	 UEMp/e0qxFFz2WjNACNztEuuuQQNdpfqKKmvMHrxqx/ITK0Wf0Qp7/ejCuD7mV6s0KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BypZZonUQuVTK7GqEhcxml05jcWTToBZA0msMgqrWMY=;
	b=nkdMNWN1Lqai+F6P2mXSNSv2HvW8T2W6JR3eOz7ht3hKBQM9kD6xyF82JFw4Ydh0U3Xp
	 ss7NdW+gfXICBP0J/5gwrh0QHa6Gb/VJZwm+A0KTfpcCkcWdEINQOnCPyrlRVDPSNWdQg
	 kHlkFdnwx5ICx3EWWvPLHyCcle/TfvQ9KO/q1S1YNBQ8u+1BpV4dJV7h38gee/xredLFe
	 fFTS+eA/qc4GC8OcMchffAU6K4aThphTqNMQ96MIIcCngboYZ80x3EwMghpGMp8ZBlkNE
	 hL5O5NgONtu/3cYRn9rgHfgjCXxSFM3/ckuYkaDT9S9qPwFUJu6cjzMTrxURSjWd0XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=By6x9LAx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19683606A32C;
	Thu, 19 Nov 2026 01:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=By6x9LAx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E1F1F000C4;
	Thu, 19 Nov 2026 01:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050780;
	bh=BypZZonUQuVTK7GqEhcxml05jcWTToBZA0msMgqrWMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=By6x9LAxay1VX/QTbEXEH2JCwKHumDcbQCyrLMjHDds3UVfdcxoDpgRVP5frdHy1Z
	 h02bPX+ObFllzSt/at3EZXHzhCLo4wZ4rU/IrsYKMlJB3xaYXzwOzksGlvGFmaVMmY
	 nFhjitDJv1UlkwHWQLeIbdDeO1V1vMjq03DzH4f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2829/2857] ucount: read the parent ucounts before dropping the rlimit count
Date: Wed, 18 Nov 2026 16:04:23 +0100
Message-ID: <20261118150343.443127112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 38bf603d1ea5d5a65a9cb277df75327ffec01ff1 ]

do_dec_rlimit_put_ucounts() drops its share of iter->rlimit[type] and
only then loads iter->ns->ucounts. If the decrement leaves the count
non-zero, a concurrent caller can take it to zero and put the last
reference, which frees the ucounts and possibly its user namespace with
kfree_rcu(). An exiting task frees its pending signals without siglock
or any RCU read-side section, so when it is preempted between the
decrement and the load for a grace period it reads freed memory and
then decrements a counter through the pointer it found there.

A pending signal holds no reference on its ucounts: the reference is
taken by whoever moves the count from 0 to 1 and dropped by whoever
moves it back to 0, so the caller's share of the count is all that
keeps iter alive, and only until it is dropped.

Load the parent first; it stays pinned by the caller's share of its
own count.

Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261024015513.830312-1-nickolai@csail.mit.edu
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index e218ea54af92f..a5714d84fd1d0 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -294,9 +294,12 @@ static void do_dec_rlimit_put_ucounts(struct ucounts *ucounts,
 {
 	struct ucounts *iter, *next;
 	for (iter = ucounts; iter != last; iter = next) {
-		long dec = atomic_long_sub_return(1, &iter->rlimit[type]);
-		WARN_ON_ONCE(dec < 0);
+		long dec;
+
+		/* Our count pins @iter; once it is dropped @iter may be freed. */
 		next = iter->ns->ucounts;
+		dec = atomic_long_sub_return(1, &iter->rlimit[type]);
+		WARN_ON_ONCE(dec < 0);
 		if (dec == 0)
 			put_ucounts(iter);
 	}
-- 
2.53.0



