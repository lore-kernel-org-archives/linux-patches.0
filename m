Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51F04FC8E6;
	Wed, 30 Sep 2026 15:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783230; cv=none; b=mG9NKvtyyrPOb03Pu/SFQqqDxykkiWdR9PuziegSK/ubX1v5Vg5XIOsC0wADzDncbvC7WAygXcRHwlJ5wWkX5MBk8IpCcDwRjm3FDCtRtFMNDERQaLE8kKJkt+3bnKdQsfo3W2JbC7amEg4OGWYD/Lesfc4XwEySdtlqfk1T9bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783230; c=relaxed/simple;
	bh=qlREYLa5nX5ZnfHjOgQg1xx7Z0EgdmYSD/d3UbtadoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIJhdUusL6UCvyvKmG/mIHHUFTmD9WKg5ZAHbdvSjeM8opAlkKg8JUCiJ6tdgu5i2YldQmoOuTDQGhKzGoZdD1bpP/KbT2fGhZgy/DDOklgDmRtKvCsPiA9aVjvWbNiSIcXdBPHNVipB/l5A81VMt1+foWJuLsQcPCSqNmZ1+SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tV+zecI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tV+zecI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40641F00898;
	Wed, 30 Sep 2026 15:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783225;
	bh=ajt+uWKlnFAOLlgHcQmxtYTdbh7zzy+b4Mlz1f/4K7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tV+zecI/nNONeXzf0VZB3BHH9aKXoPrj1dPAzfcm6lOROFYYGzgFW85HQbpNKaVb
	 pIdU/s/T4L5mkgAGnC4JxJZZq8RQpOeCFEDpxxOVL6mAUL6oTHWEkIG4ZbJO496l/e
	 QsrF721meFSY5iBs/u/mNlYdlHMypxT9R9E7x9/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Dmitriy Okunev <dokunevdmitriy@gmail.com>
Subject: [PATCH 5.10 324/595] fou: Fix use-after-free in fou_create()
Date: Wed, 30 Sep 2026 17:23:37 +0200
Message-ID: <20260930152354.653019335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit b14361aca6350ff7907b0e9903c7b94dc7d5d4a0 upstream.

fou_create() publishes struct fou through sk_user_data before adding the
new FOU port to the per-netns list.  If fou_add_to_port_list() fails,
the error path frees fou while it is still reachable through
sk_user_data.  A concurrent receive can then dereference the freed
object in fou_from_sock().

This ordering issue was previously noted in the linked discussion.

The failure is reachable when local port 0 is requested.  Each socket
binds to a different ephemeral port, but fou_cfg_cmp() compares the
requested port 0 and reports -EALREADY once an entry already exists.

Release the tunnel socket before freeing fou so sk_user_data is cleared
first, and defer reclamation with kfree_rcu() to protect concurrent RCU
readers.  This matches the lifetime handling in fou_release().

Fixes: 23461551c006 ("fou: Support for foo-over-udp RX path")
Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://lore.kernel.org/netdev/20260502031401.3557229-12-kuniyu@google.com/
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260722083858.182506-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fou_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -639,9 +639,9 @@ static int fou_create(struct net *net, s
 	return 0;
 
 error:
-	kfree(fou);
 	if (sock)
 		udp_tunnel_sock_release(sock);
+	kfree_rcu(fou, rcu);
 
 	return err;
 }


