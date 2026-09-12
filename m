Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FD33F9F50;
	Sat, 12 Sep 2026 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227616; cv=none; b=HhEj9vUpEHXAmRoZqsqC3VNuOt3VGkynR+duH3Af5Cgc7oW5alYw89hStnES5MI/Op3OPqq+Xyffwat7m1g8+acUGp2U6hi3foH8fTFpYFXw/1DilQ89KyGKiTFWgFEpbr28m1LYXZ7AU4tp34CoyvSy+pYUI2tUnlJwQz+p7vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227616; c=relaxed/simple;
	bh=z6InoPxB8bHJU7reujpeEWsBx0WzLxyMLdOXhJufb9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcykCej3YJdBa87Wu+XNwnVz3dTcZ+wnoXrKm1DbrkeW6xaq/vVvoBmxdV1v3h008vTFeuUtxADRO6rC3p/GTsEp2IU1ydZgh3g4Yx7jthjSUAIaxKYEfhjE1wm+Jf/GgSbqNszEMm5QfICC/4ILbVFxZV7aHeqVT11+4z67htk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiuxschF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiuxschF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FAC1F000FF;
	Sat, 12 Sep 2026 15:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227614;
	bh=tothnR5pUjHidll8dk2uaRepEfw+6Hm5o88c3lLcD/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiuxschFZt2f+t9QIjKSoampM5zlep8aGFPFc1abz/7GNJKxW5fs7Fnqt58s4u1Oa
	 UA4d2xP0azWF4frpletULv/gGPx3MMm9eIs0Aydv11ucdSUG5fLMINA73tsUi3JDL/
	 MIuZhLiiw2bNRHIorp3J0TdchFyATvYA0F8PFsws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0217/1191] net: fix spurious TX timeout after dev_activate()
Date: Sat, 12 Sep 2026 08:49:05 +0200
Message-ID: <20260912065553.087952710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 82aeed2400786bd3f79d88cb8b8f42e6127e5923 upstream.

While debugging another issue today, I found out that my TX queue is
reported as stopped for 4294907392 ms (49.7 days), on a machine that
had been up for four minutes.

    bnxt_en 0002:01:00.0 eth0: NETDEV WATCHDOG: CPU: 28: transmit queue 23 timed out 4294907392 ms

4294907392 is not an elapsed time. It is the value of jiffies at that
moment: INITIAL_JIFFIES is 4294667296, which leaves jiffies 59 seconds
short of wrapping.

dev_activate() runs transition_one_qdisc() over every TX queue, which
resets trans_start to 0, and then stamps only queue 0 through
netif_trans_update().

Stamp jiffies instead. A queue stopped across dev_activate() now gets a
full watchdog_timeo of grace, and is still reported if it is stopped
that long.

Fixes: 9b36627acecd ("net: remove dev->trans_start")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260825-trans_start-v2-1-286b4d6d70cb@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1235,7 +1235,7 @@ static void transition_one_qdisc(struct
 
 	rcu_assign_pointer(dev_queue->qdisc, new_qdisc);
 	if (need_watchdog_p) {
-		WRITE_ONCE(dev_queue->trans_start, 0);
+		WRITE_ONCE(dev_queue->trans_start, jiffies);
 		*need_watchdog_p = 1;
 	}
 }


