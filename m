Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5559C5A1768;
	Mon, 31 Aug 2026 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184324; cv=none; b=e0fCnE39p/UBKmhHHPV5MaeS0iMo2fUdh5jHGsfvAppQOflK8f48a8YGI8aKMCmlrAGm9io+qljPaKp4sCi5zhc4atxG++nNZD857edRJU3Vlh6NYXJsKJ06ycjsOyNtF2D0KUIyoEH+m8Jj1gktPcdJqcYkoEoPEW/wlDZpC/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184324; c=relaxed/simple;
	bh=12QXnHxiwjOW6amq6mzVgmvdDcKNq5Myr8FzMrydb2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbksWD/oNcVjFMtYNiXL+Hte+UYtOJEMmvv0cUA84j1l8wrTY1NkdUtmmdjTyZ9vbfVJnHUpgaDJZVm2JOx4vJACOoviZgWjPyB2VGklaWVuYtdRQmd0K5Yr+gqHV8iAXOvZ2VJrKEWp81SPY1F6SvpEBV6T8uZTWAcjo8f3Bw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grvqn51X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grvqn51X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09AA1F000E9;
	Mon, 31 Aug 2026 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184323;
	bh=uTOpXGVmB6fGEiqvyHJbXjMQcOuj+vCCaTFlSi/xO5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grvqn51X8HkVBlfIjJoiM29bFNznVhfiTkOks4qvtidGTzW4RkOE3YhP9VFkUe7jX
	 7QCvjXjqhXUCbBUzTTmIk1zd35ohXyB5OZ47gnVBN32PSpctebzpzbpB3Zz1zbDMd2
	 HI64R3BUMKgx1OhL/tsPHoICvBoYT2gigFK/O/1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rastislav Szabo <rastislav.szabo@isovalent.com>,
	David Ahern <dsahern@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 68/99] net/tcp: fix TCP-AO key deletion in VRFs
Date: Mon, 31 Aug 2026 15:34:37 +0200
Message-ID: <20260831133403.357467893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

From: Rastislav Szabo <rastislav.szabo@isovalent.com>

commit 94ad9e114a1c7b16ea418c1456ac3835e038ab3f upstream.

TCP-AO keys with TCP_AO_KEYF_IFINDEX store the VRF L3 interface index in
l3index. tcp_ao_del_cmd() validates the supplied ifindex, but does not
assign it to its local l3index before matching keys.

As a result, deleting a key scoped to a non-default VRF always fails with
ENOENT because it is matched against l3index 0.

Fixes: 248411b8cb89 ("net/tcp: Wire up l3index to TCP-AO")
Cc: stable@vger.kernel.org
Signed-off-by: Rastislav Szabo <rastislav.szabo@isovalent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Acked-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20260822201119.272269-1-rastislav.szabo@isovalent.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ao.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1854,6 +1854,9 @@ static int tcp_ao_del_cmd(struct sock *s
 	if (cmd.ifindex && !(cmd.keyflags & TCP_AO_KEYF_IFINDEX))
 		return -EINVAL;
 
+	if (cmd.keyflags & TCP_AO_KEYF_IFINDEX)
+		l3index = cmd.ifindex;
+
 	ao_info = setsockopt_ao_info(sk);
 	if (IS_ERR(ao_info))
 		return PTR_ERR(ao_info);


