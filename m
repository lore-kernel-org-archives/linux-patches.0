Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69551714DD;
	Thu, 15 Aug 2024 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730549; cv=none; b=Odo4iuW8eBQ43+5Gzcyfv9LgHCw5//Vvm7+3PJE86d8XWFt39KlNnV4dfkPPrHYt2jhRR0xIiokZK2VMu05rwl5yLc3WS9ZDu6vGbIDjTlcqlUDupIACIm6/+OTG8ip6y++boOhiO687o/3Y8GIV5sdCXWzAeEKI0iZshsa3NmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730549; c=relaxed/simple;
	bh=61rqu7snz4G0O+p7iljs+yvSWE/I8Nk3ulmVx1/hRGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGMsXkx6ygrsjMZ59IqG7hy1OjF98S+lnoKF5NmUYpAGrVb+rtXWJbYNxKvStb4LDGPHhbeKb8lIp4OLbj+Y+t5+EgQfBgZ8XlvqRFGyr7j5dBursN1Cc0t1y/UMu+UAvr5aMimn0BU86HXDCX2lDhjkZGOqhutMhNgz2E8CFkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEHdklKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEHdklKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFCCC32786;
	Thu, 15 Aug 2024 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730549;
	bh=61rqu7snz4G0O+p7iljs+yvSWE/I8Nk3ulmVx1/hRGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEHdklKjFEv2AO4hsbOeSEUsu4nadoi/EkjBDTK5PHDJEPEu1j70gf/cvaUnUsbzt
	 nM81zWfjdzF20vImhvZtSlthfMwgDVWTIrix+cltef6fJGTa7C5ZO5mfefRiMGoQ+9
	 8fFtLffEE92NxV9N1vS4I2wRUYG2/c2uMoiIQQbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Cheng-Jui Wang <cheng-jui.wang@mediatek.com>,
	Tze-nan Wu <Tze-nan.Wu@mediatek.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 444/484] tracing: Fix overflow in get_free_elt()
Date: Thu, 15 Aug 2024 15:25:02 +0200
Message-ID: <20240815131958.610062684@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tze-nan Wu <Tze-nan.Wu@mediatek.com>

commit bcf86c01ca4676316557dd482c8416ece8c2e143 upstream.

"tracing_map->next_elt" in get_free_elt() is at risk of overflowing.

Once it overflows, new elements can still be inserted into the tracing_map
even though the maximum number of elements (`max_elts`) has been reached.
Continuing to insert elements after the overflow could result in the
tracing_map containing "tracing_map->max_size" elements, leaving no empty
entries.
If any attempt is made to insert an element into a full tracing_map using
`__tracing_map_insert()`, it will cause an infinite loop with preemption
disabled, leading to a CPU hang problem.

Fix this by preventing any further increments to "tracing_map->next_elt"
once it reaches "tracing_map->max_elt".

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 08d43a5fa063e ("tracing: Add lock-free tracing_map")
Co-developed-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Link: https://lore.kernel.org/20240805055922.6277-1-Tze-nan.Wu@mediatek.com
Signed-off-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/tracing_map.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -454,7 +454,7 @@ static struct tracing_map_elt *get_free_
 	struct tracing_map_elt *elt = NULL;
 	int idx;
 
-	idx = atomic_inc_return(&map->next_elt);
+	idx = atomic_fetch_add_unless(&map->next_elt, 1, map->max_elts);
 	if (idx < map->max_elts) {
 		elt = *(TRACING_MAP_ELT(map->elts, idx));
 		if (map->ops && map->ops->elt_init)
@@ -699,7 +699,7 @@ void tracing_map_clear(struct tracing_ma
 {
 	unsigned int i;
 
-	atomic_set(&map->next_elt, -1);
+	atomic_set(&map->next_elt, 0);
 	atomic64_set(&map->hits, 0);
 	atomic64_set(&map->drops, 0);
 
@@ -783,7 +783,7 @@ struct tracing_map *tracing_map_create(u
 
 	map->map_bits = map_bits;
 	map->max_elts = (1 << map_bits);
-	atomic_set(&map->next_elt, -1);
+	atomic_set(&map->next_elt, 0);
 
 	map->map_size = (1 << (map_bits + 1));
 	map->ops = ops;


