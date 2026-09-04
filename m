Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18CD415F06;
	Fri,  4 Sep 2026 05:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500104; cv=none; b=SbO6AXJkZo7cUmpQkF8R2lY92damytoFsp3GdoqSntgwPFPIo8UqTsXBptwVE7LQhmCXhDKXV4XyFwajARCAATRui929eq6KokuNreCkqN37ORQbWwQ/RrPPjBjbH29XGOSilQS8oinsmD38qhTQP85cD9HTn+TDXVCr6hg9yH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500104; c=relaxed/simple;
	bh=H6IboPhyyAgoJJiBxzyShIZcF/OrfVtQE1Kk4xwqRNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7Hz0BZlPLxfIFUpieoWKOGe9HSAVhC5UlKeiQjKje+L2gPdRn0AyVJY9gJiqAjtX3L7U5IuakOHXjj0PsjecWkJ69vlVQZc8GbKdYgrhM9a+syWGLthwb7j40OcDPUFRxCd+BNaDRZIULTI1ODifkuBsj/PsVJa9WcKfOUC7oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaHvy83C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaHvy83C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182211F00A3D;
	Fri,  4 Sep 2026 05:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500103;
	bh=9N/7umrlRSYjgCyUmxpqqIzSq5GCzTHq6yJqjqyB9So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iaHvy83Cfekgolod61+IK33tSTIn4Sk7nESd0zaCovfeeXstNQGz7Ng8+uBkvstQn
	 k6DlTrL8Oem5PmOIq+Koqzf26tZzcBvM61bwkLV2me6U1ZiNjCoezUKfT4T+XLhEp2
	 rR/hRQuE5V9qJAYXVTnoEX57JQ476qH3si1TX10k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junzhe Yu <junzheyu1@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 652/713] dm-stats: fix a crash if allocation of per-cpu data fails
Date: Fri,  4 Sep 2026 07:00:20 +0200
Message-ID: <20260904045818.447555648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -178,8 +178,10 @@ static void dm_stat_free(struct rcu_head
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


