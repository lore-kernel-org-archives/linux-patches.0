Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59521D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT6zgFkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C1CC433C7;
	Wed,  4 Oct 2023 18:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443888;
	bh=2GKQLDJ8HgmC4QLaGRu8FHx06krB9UMFC2IXEo1wj7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WT6zgFkPTntKCrTTt8L5ut/kIMupR2kEf9id8E60Tzej6xmLRJCtUuOD7dAHwck5o
	 rjyl2o64DGrv7lA7qNuNTMZlgSL8u0Q0jTuvM7jLXghaacesCZXCRrXpiKfU6qziK9
	 yKpW6YCfeF9tLe08MjMZOivhoR8OJmaZGxP7/4kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Wei Hung <hsinweih@uci.edu>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 027/321] bpf: Avoid deadlock when using queue and stack maps from NMI
Date: Wed,  4 Oct 2023 19:52:52 +0200
Message-ID: <20231004175230.424546914@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit a34a9f1a19afe9c60ca0ea61dfeee63a1c2baac8 ]

Sysbot discovered that the queue and stack maps can deadlock if they are
being used from a BPF program that can be called from NMI context (such as
one that is attached to a perf HW counter event). To fix this, add an
in_nmi() check and use raw_spin_trylock() in NMI context, erroring out if
grabbing the lock fails.

Fixes: f1a2e44a3aec ("bpf: add queue and stack maps")
Reported-by: Hsin-Wei Hung <hsinweih@uci.edu>
Tested-by: Hsin-Wei Hung <hsinweih@uci.edu>
Co-developed-by: Hsin-Wei Hung <hsinweih@uci.edu>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20230911132815.717240-1-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/queue_stack_maps.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index 8d2ddcb7566b7..d869f51ea93a0 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -98,7 +98,12 @@ static long __queue_map_get(struct bpf_map *map, void *value, bool delete)
 	int err = 0;
 	void *ptr;
 
-	raw_spin_lock_irqsave(&qs->lock, flags);
+	if (in_nmi()) {
+		if (!raw_spin_trylock_irqsave(&qs->lock, flags))
+			return -EBUSY;
+	} else {
+		raw_spin_lock_irqsave(&qs->lock, flags);
+	}
 
 	if (queue_stack_map_is_empty(qs)) {
 		memset(value, 0, qs->map.value_size);
@@ -128,7 +133,12 @@ static long __stack_map_get(struct bpf_map *map, void *value, bool delete)
 	void *ptr;
 	u32 index;
 
-	raw_spin_lock_irqsave(&qs->lock, flags);
+	if (in_nmi()) {
+		if (!raw_spin_trylock_irqsave(&qs->lock, flags))
+			return -EBUSY;
+	} else {
+		raw_spin_lock_irqsave(&qs->lock, flags);
+	}
 
 	if (queue_stack_map_is_empty(qs)) {
 		memset(value, 0, qs->map.value_size);
@@ -193,7 +203,12 @@ static long queue_stack_map_push_elem(struct bpf_map *map, void *value,
 	if (flags & BPF_NOEXIST || flags > BPF_EXIST)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&qs->lock, irq_flags);
+	if (in_nmi()) {
+		if (!raw_spin_trylock_irqsave(&qs->lock, irq_flags))
+			return -EBUSY;
+	} else {
+		raw_spin_lock_irqsave(&qs->lock, irq_flags);
+	}
 
 	if (queue_stack_map_is_full(qs)) {
 		if (!replace) {
-- 
2.40.1



