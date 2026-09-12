Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3113356744;
	Sat, 12 Sep 2026 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227702; cv=none; b=bbcYpP1WjWfhciGP9v239101YTsf2/SsrMMXjddjVVS+/JAWtuYryvixMeTo5/mYPXNJt8g49KGVUxkllpIdz8p24D25+8VLkZW11TqK+IblRlrK8p1PdHXQbnhCQKwZKrnEH835/q8VL/83TJVc/Y9pfXAjQXQNeUAohQVGhhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227702; c=relaxed/simple;
	bh=TAM6og897sDD8cTPqC4/KWWJUGwQmleIR1HDEn/Rc4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lc/dR66xjYIydcGdDF84na3rOVHCymowoT6byelpcUayY6Z+dhGmjXXqrNlG6xiOIeSi8FUAchg1m0QM83Fs46L7zP8tz2BEaKnXDl/7e16MoXkvR0Y/BruZOTsVZT2R/SMIqfUFn/etrkKK1BbjnaSuoU/eI3BxK++NIOf8SUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOkdVTA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOkdVTA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424B01F000FF;
	Sat, 12 Sep 2026 15:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227701;
	bh=yvYLcU8uaYc6MQ7GTSJg0YZka+qPIhCrMihNk2JL2XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOkdVTA3tpdS9xzf044ga8RQ8ror56qyVzZgVzxbYzj9MOmoBYytTbez/mY9woQW3
	 JyWUH9tMIFzQzYGj2R1izLp2vHEUf0wxCqu3Z8iV2nrZQlQxcTq7TYCZiSRRRO39ml
	 lOcffQQ7BgLK+ay4q+XXU7P6kzj9ebyF5WXavp4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junzhe Yu <junzheyu1@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0233/1191] dm-stats: fix a crash if allocation of per-cpu data fails
Date: Sat, 12 Sep 2026 08:49:21 +0200
Message-ID: <20260912065553.444338212@linuxfoundation.org>
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


