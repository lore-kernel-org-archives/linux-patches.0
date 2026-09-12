Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEFF3264F4;
	Sat, 12 Sep 2026 13:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220984; cv=none; b=J0sEQTTVaFZwcXDecn0D6txGdDwFGNAmFqeIUXHBrItGTtg6cPbJiYWAhlPzFI4g6yavdvQeRl/S8Vc1GtFSyMH3jR5ITIOlU6zR7dUBAZ1kBqVI35wDO0inGEIQMd0Decs/qQV9wL7NVKyqCqik6+LcOzkAadJ4w6eiIxKVFes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220984; c=relaxed/simple;
	bh=gB+1Wzacm8g7nw1erpebqfX9YdO7dNllt4cIXlPoZl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOPL2nh54ZiD7UzIVS87yZndqBdyScc2zucDENeB4ecYsJCkJYOQp7IfU9Xy0dtmE3KlGpGeLRpULkpcWV9I7VLzOOEQJamQyTAaAgTBlMhs830Xwvlh51qVIkKD/tDqd8GUQVzwF10JXxnk1BEafOjeWe6vDCsurg5Ht2W348M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRluGeh+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRluGeh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DD01F000FF;
	Sat, 12 Sep 2026 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220982;
	bh=StpM9h/f6liPFax4+T1nVRdRRcIzxOd6onjDNZvL+qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRluGeh+oNYDdZzO/OG7DBr8ORffu/++2D2J4hQB2gm5DHCLVJXDqJk58AFrJJvyi
	 jWpMB/yyvJOv7V7cieCX3kZjU26OVEpGtLul6BZqNzg/w55tB8Buk7L1GYd6szz9Lp
	 lsXTKCkqxEY7bLt7Aty4JavtLnC/TpO/+58RiHv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junzhe Yu <junzheyu1@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 0289/1424] dm-stats: fix a crash if allocation of per-cpu data fails
Date: Sat, 12 Sep 2026 08:45:21 +0200
Message-ID: <20260912065613.754588396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit cc87e26d9cce22061dc21e51e11afef29dbbc36a upstream.

If "dm_kvzalloc(percpu_alloc_size, cpu_to_node(cpu))" fails, the code
jumps to the "out" label and calls dm_stat_free. dm_stat_free does
"for_each_possible_cpu(cpu) { dm_kvfree(s->stat_percpu[cpu][0].histogram,
s->histogram_alloc_size);", which crashes with NULL pointer dereference
if s->stat_percpu[cpu] is NULL.

This commit fixes the bug by testing s->stat_percpu[cpu] for NULL before
using it.

Reported-by: Junzhe Yu <junzheyu1@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -175,8 +175,10 @@ static void dm_stat_free(struct rcu_head
 	kfree(s->program_id);
 	kfree(s->aux_data);
 	for_each_possible_cpu(cpu) {
-		dm_kvfree(s->stat_percpu[cpu][0].histogram, s->histogram_alloc_size);
-		dm_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
+		if (s->stat_percpu[cpu]) {
+			dm_kvfree(s->stat_percpu[cpu][0].histogram, s->histogram_alloc_size);
+			dm_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
+		}
 	}
 	dm_kvfree(s->stat_shared[0].tmp.histogram, s->histogram_alloc_size);
 	dm_kvfree(s, s->shared_alloc_size);


