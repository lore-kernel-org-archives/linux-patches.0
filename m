Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B864515E87
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VB897XNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34306C433C7;
	Mon, 23 Oct 2023 11:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060801;
	bh=aLoBhnxgBl3WGzVMP4xFqB1HNmbs5zhIdT9rQVNGdeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VB897XNWVNDTw40zfq+Az1u45yL23pJK/9AGdac1IQfc4wi0jxpBf8SRvF7v6jk4L
	 Kcbb5d2c2veMkEa+pZ9j5XMIbOBP5HB0tl5g5wO6bLCYS2yoRCl5drC3KrLgyynasD
	 QALPjObEUKljDDKZUaAEkalB9i1L2wOF+2rIpmkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 070/123] neighbor: tracing: Move pin6 inside CONFIG_IPV6=y section
Date: Mon, 23 Oct 2023 12:57:08 +0200
Message-ID: <20231023104820.013431470@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 2915240eddba96b37de4c7e9a3d0ac6f9548454b upstream.

When CONFIG_IPV6=n, and building with W=1:

    In file included from include/trace/define_trace.h:102,
		     from include/trace/events/neigh.h:255,
		     from net/core/net-traces.c:51:
    include/trace/events/neigh.h: In function ‘trace_event_raw_event_neigh_create’:
    include/trace/events/neigh.h:42:34: error: variable ‘pin6’ set but not used [-Werror=unused-but-set-variable]
       42 |                 struct in6_addr *pin6;
	  |                                  ^~~~
    include/trace/trace_events.h:402:11: note: in definition of macro ‘DECLARE_EVENT_CLASS’
      402 |         { assign; }                                                     \
	  |           ^~~~~~
    include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
       44 |                              PARAMS(assign),                   \
	  |                              ^~~~~~
    include/trace/events/neigh.h:23:1: note: in expansion of macro ‘TRACE_EVENT’
       23 | TRACE_EVENT(neigh_create,
	  | ^~~~~~~~~~~
    include/trace/events/neigh.h:41:9: note: in expansion of macro ‘TP_fast_assign’
       41 |         TP_fast_assign(
	  |         ^~~~~~~~~~~~~~
    In file included from include/trace/define_trace.h:103,
		     from include/trace/events/neigh.h:255,
		     from net/core/net-traces.c:51:
    include/trace/events/neigh.h: In function ‘perf_trace_neigh_create’:
    include/trace/events/neigh.h:42:34: error: variable ‘pin6’ set but not used [-Werror=unused-but-set-variable]
       42 |                 struct in6_addr *pin6;
	  |                                  ^~~~
    include/trace/perf.h:51:11: note: in definition of macro ‘DECLARE_EVENT_CLASS’
       51 |         { assign; }                                                     \
	  |           ^~~~~~
    include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
       44 |                              PARAMS(assign),                   \
	  |                              ^~~~~~
    include/trace/events/neigh.h:23:1: note: in expansion of macro ‘TRACE_EVENT’
       23 | TRACE_EVENT(neigh_create,
	  | ^~~~~~~~~~~
    include/trace/events/neigh.h:41:9: note: in expansion of macro ‘TP_fast_assign’
       41 |         TP_fast_assign(
	  |         ^~~~~~~~~~~~~~

Indeed, the variable pin6 is declared and initialized unconditionally,
while it is only used and needlessly re-initialized when support for
IPv6 is enabled.

Fix this by dropping the unused variable initialization, and moving the
variable declaration inside the existing section protected by a check
for CONFIG_IPV6.

Fixes: fc651001d2c5ca4f ("neighbor: Add tracepoint to __neigh_create")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org> # build-tested
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/neigh.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/trace/events/neigh.h
+++ b/include/trace/events/neigh.h
@@ -39,7 +39,6 @@ TRACE_EVENT(neigh_create,
 	),
 
 	TP_fast_assign(
-		struct in6_addr *pin6;
 		__be32 *p32;
 
 		__entry->family = tbl->family;
@@ -47,7 +46,6 @@ TRACE_EVENT(neigh_create,
 		__entry->entries = atomic_read(&tbl->gc_entries);
 		__entry->created = n != NULL;
 		__entry->gc_exempt = exempt_from_gc;
-		pin6 = (struct in6_addr *)__entry->primary_key6;
 		p32 = (__be32 *)__entry->primary_key4;
 
 		if (tbl->family == AF_INET)
@@ -57,6 +55,8 @@ TRACE_EVENT(neigh_create,
 
 #if IS_ENABLED(CONFIG_IPV6)
 		if (tbl->family == AF_INET6) {
+			struct in6_addr *pin6;
+
 			pin6 = (struct in6_addr *)__entry->primary_key6;
 			*pin6 = *(struct in6_addr *)pkey;
 		}


