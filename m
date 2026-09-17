Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5B44B7A59;
	Thu, 17 Sep 2026 17:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666955; cv=none; b=aAUxZyFEekLGQmV2Moj28hpTi0xcp6k8m9cpPM8n24IxBB5LGvOeXMpjUCaNNZs7cL6FoW+mC0k29S5HXfjlZOdfHJHHR99gSPqZMOF931bx0g1ra5tJfMY8zrHmKrPS13+uL7BQLeZ+niSfpFrRnstgAIHcNn0hIPg2aZmpS3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666955; c=relaxed/simple;
	bh=id2PtP/lCkc6qr/dgV9gB9mQKmqyOeLAEKt4hVt4AMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhS+KTr6bD5uMC+CDcwARpGsq43etrZPI5GqkQO/AsKYQeSGi5seqcoAkfjIzlihYSFFBEAM8/prs4m6xee09jY/OCCnWWulKpMH59rFZNVsUVyhpgpGfu4A6RwCkzslw0hACPLz/gU+R4AqhDBSERpeMs7Q5fP86ukb7cyN6tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZcxBg3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZcxBg3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A257F1F000FF;
	Thu, 17 Sep 2026 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666952;
	bh=toyV+Cr+Ba3+T9wyhvRsCKGArDexH1pSCNi+eDaawrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZcxBg3jleltXV/JPhJBqVOezYpc5eQS0iowHaWzONXbauMLBKhgo1BGYBnmJ2l9m
	 OKWjR1K/fgzVAgAFfIN4+YT7BnXEfPBF/4bacKzfrMzNaXFZ191RP2s1W1elEiebd4
	 kfrEbrM89qEHi/IgC3hqGsaJtTEyGlceEDbXpSXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Dmitriy Okunev <dokunevdmitriy@gmail.com>
Subject: [PATCH 6.18 1178/1250] fou: Fix use-after-free in fou_create()
Date: Thu, 17 Sep 2026 16:16:13 +0100
Message-ID: <20260917151624.213911649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -632,9 +632,9 @@ static int fou_create(struct net *net, s
 	return 0;
 
 error:
-	kfree(fou);
 	if (sock)
 		udp_tunnel_sock_release(sock);
+	kfree_rcu(fou, rcu);
 
 	return err;
 }


