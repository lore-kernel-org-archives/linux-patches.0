Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6B2349AF7;
	Fri, 21 Nov 2025 13:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733442; cv=none; b=Ng5HI3BVfAdsnQH/LTb+M26++2LQGU6ZyD/v1FiMGr7soQsQKeNh2KGHxIS/K8pxPzp3QtEn3sdvLuYXITB86S3/SKShXMxrxItAey0hIdTIay2wtHZ+/K6tS7Jx837OSHczij4tf9hGTMZMtqP4r4u+oq26PH9K4UMDqrx8z+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733442; c=relaxed/simple;
	bh=oVmdlw5c4/s3Fe6ejPL0T2ezQmK11fjibYJXNxlZvgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lteXNvyTgWi/8kmQ+HFjq9ZKV8ppoxIRMi0eOamcxQ5BdSj2ab7JBF6CATuPj5ouNrFnDhMlv9PaKcVzO655bScNdw9BbF4ob298KBxMJH41UI31MJrFcOQwT9xbVgUxfd8//ZVAo5GNCsWRn/ZsLY8cagEZB6NOe+P+BZDYMfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWBpbjBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWBpbjBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E6EC116D0;
	Fri, 21 Nov 2025 13:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733442;
	bh=oVmdlw5c4/s3Fe6ejPL0T2ezQmK11fjibYJXNxlZvgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWBpbjBkPUlmE26qAdQg268levj2ifX8OGGHJBNkpZaGMa5Wp+kV8aWQo7W+4rVhI
	 BB3j/JiTGUqS24Z6Y6QEA4r9F/PfeNznJWF2WrAGnWyokXvowfvr72/ouCYIygYx5j
	 JUgru3qMhM0at3bG/t0Iw82mnTgOGIm9hy17VNlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuang Wang <nashuiliang@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 470/529] ipv4: route: Prevent rt_bind_exception() from rebinding stale fnhe
Date: Fri, 21 Nov 2025 14:12:49 +0100
Message-ID: <20251121130247.733041466@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuang Wang <nashuiliang@gmail.com>

commit ac1499fcd40fe06479e9b933347b837ccabc2a40 upstream.

The sit driver's packet transmission path calls: sit_tunnel_xmit() ->
update_or_create_fnhe(), which lead to fnhe_remove_oldest() being called
to delete entries exceeding FNHE_RECLAIM_DEPTH+random.

The race window is between fnhe_remove_oldest() selecting fnheX for
deletion and the subsequent kfree_rcu(). During this time, the
concurrent path's __mkroute_output() -> find_exception() can fetch the
soon-to-be-deleted fnheX, and rt_bind_exception() then binds it with a
new dst using a dst_hold(). When the original fnheX is freed via RCU,
the dst reference remains permanently leaked.

CPU 0                             CPU 1
__mkroute_output()
  find_exception() [fnheX]
                                  update_or_create_fnhe()
                                    fnhe_remove_oldest() [fnheX]
  rt_bind_exception() [bind dst]
                                  RCU callback [fnheX freed, dst leak]

This issue manifests as a device reference count leak and a warning in
dmesg when unregistering the net device:

  unregister_netdevice: waiting for sitX to become free. Usage count = N

Ido Schimmel provided the simple test validation method [1].

The fix clears 'oldest->fnhe_daddr' before calling fnhe_flush_routes().
Since rt_bind_exception() checks this field, setting it to zero prevents
the stale fnhe from being reused and bound to a new dst just before it
is freed.

[1]
ip netns add ns1
ip -n ns1 link set dev lo up
ip -n ns1 address add 192.0.2.1/32 dev lo
ip -n ns1 link add name dummy1 up type dummy
ip -n ns1 route add 192.0.2.2/32 dev dummy1
ip -n ns1 link add name gretap1 up arp off type gretap \
    local 192.0.2.1 remote 192.0.2.2
ip -n ns1 route add 198.51.0.0/16 dev gretap1
taskset -c 0 ip netns exec ns1 mausezahn gretap1 \
    -A 198.51.100.1 -B 198.51.0.0/16 -t udp -p 1000 -c 0 -q &
taskset -c 2 ip netns exec ns1 mausezahn gretap1 \
    -A 198.51.100.1 -B 198.51.0.0/16 -t udp -p 1000 -c 0 -q &
sleep 10
ip netns pids ns1 | xargs kill
ip netns del ns1

Cc: stable@vger.kernel.org
Fixes: 67d6d681e15b ("ipv4: make exception cache less predictible")
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251111064328.24440-1-nashuiliang@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -617,6 +617,11 @@ static void fnhe_remove_oldest(struct fn
 			oldest_p = fnhe_p;
 		}
 	}
+
+	/* Clear oldest->fnhe_daddr to prevent this fnhe from being
+	 * rebound with new dsts in rt_bind_exception().
+	 */
+	oldest->fnhe_daddr = 0;
 	fnhe_flush_routes(oldest);
 	*oldest_p = oldest->fnhe_next;
 	kfree_rcu(oldest, rcu);


