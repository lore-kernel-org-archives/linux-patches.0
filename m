Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D4646D570;
	Tue, 21 Jul 2026 18:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658886; cv=none; b=AsoZqsMQ0h5ZTJHStkA9GnFH6dcvgOkS0ai0AmvcRBsBnIs8ALsNM7Szr5RB7AFewKOORKUVU9PM86c8ac2lJeZhQu5VYPDaKli8eH9gagfDt3f6aWnaHiq4Bly3JO1nRlqiyu8U4nqeSNScsPUB3gPKi59QqjV3GsrgBbOSi+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658886; c=relaxed/simple;
	bh=FSH9TcdqcB66YeesuUdzL0gHlWIZY2zpPSVEDhfUCN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoeqZ/lzfVjbu79Tb/mMikfvSppBiCtLJ+Z5OhR7eenAkufDollEzdjmx2zSRl6Zg/SfneSItflhZcY+K7eXsgKOnH3WH7QPnAfPwrk7S9g+z/S040yOVTrp25B++umqfB0aXAJjwxVqHq8f4qi/DIYe4BFBY6Lt8yYzlC4XYrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtF56exw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtF56exw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456BF1F000E9;
	Tue, 21 Jul 2026 18:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658885;
	bh=t6+pFAcQAgbpJO9t4dpzOMzyxngYzKE9HDa+4kDybXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtF56exwldbJWeWjQKjE2VZXzHRdcF3a/Wn4ynYQZLvPzIVoHd/FgOoWa+atwA2UI
	 9d5OH7V1o0A5NqLnKza544Lc94VYR8+1cF0b8cHPgt9aqDHMZikNpoGvPOCNjo+BlG
	 AseWdjskcXvBEkMWgmrT3bv4SBZ4y7pJAdWD/XSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1314/1611] tcp: Decrement tcp_md5_needed static branch
Date: Tue, 21 Jul 2026 17:23:50 +0200
Message-ID: <20260721152545.010798639@linuxfoundation.org>
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

From: Dmitry Safonov <0x7f454c46@gmail.com>

commit 6f6e860e370c9e4e919b92118a25e9e1f82e9180 upstream.

In case of early freeing an unwanted TCP-MD5 key on TCP-AO connect(),
md5sig_info is freed right away (and set to NULL). Later, at
the moment of socket destruction, the static branch counter
is not getting decremented.

Add a missing decrement for TCP-MD5 static branch.

Reported-by: Qihang <q.h.hack.winter@gmail.com>
Fixes: 0aadc73995d0 ("net/tcp: Prevent TCP-MD5 with TCP-AO being set")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20260625-tcp-md5-connect-v3-3-1fd313d6c1e0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4268,8 +4268,8 @@ int tcp_connect(struct sock *sk)
 			tcp_clear_md5_list(sk);
 			md5sig = rcu_replace_pointer(tp->md5sig_info, NULL,
 						     lockdep_sock_is_held(sk));
-			if (md5sig)
-				kfree_rcu(md5sig, rcu);
+			kfree_rcu(md5sig, rcu);
+			static_branch_slow_dec_deferred(&tcp_md5_needed);
 		}
 	}
 #endif


