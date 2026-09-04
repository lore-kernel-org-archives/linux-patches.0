Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E79378838;
	Fri,  4 Sep 2026 06:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501704; cv=none; b=JCtPQw+PfWWMiFi9y/FOMAC7CVZfrrIs7DvPyn3al7gTzPQioLtkTJznvVIIkArACH+jEoRmNBAqkV0q/hjfNh3tmzxEC0j6P7Sx2XAU+i5vd0CzhKp1QID06PivsaQpKYRs8WIPr+RiMFafAv3OVq9UFEEzydfNkoq850UHmHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501704; c=relaxed/simple;
	bh=kkOaxoQl1OM8mg835Va5ngCD0ME/yqH1eAscGyoppbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVa4u79sbo+IL/oMdbHxf2J+zXTxNVfBkwwWztuktAHwO3JFvl3yxVGrE6+ib9KeWLFOCb3XIymNSn298sJFHiMixdnmTr0qFTQy+7PxXybpRMdG1xnk6dz7O5QHxyAwzSXSy/dY3VDvAYcJDB6QJjPmIbFEVBSyef1/zYYKoLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4zfRA8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4zfRA8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3631F00A3D;
	Fri,  4 Sep 2026 06:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501703;
	bh=I5LyOeCiLcb/77fyukSFW6e7RkjoQBtm/mrpI28Xpaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4zfRA8idHnAJsp4bVIoT68jhSV63jiufKj+IYzFtcvhljwJTv+/8OUPxppB7grg2
	 GrBxkkpBSwqbo+UwfDnmo1ADb8f9pWjojiUINVmHgjzTO99UIcS4L++5sdacq5iw2W
	 rCDVIUOkdJ9qCnag6TrL4vQ/Th7+6xXA+BEXsUis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junzhe Yu <junzheyu1@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 504/552] dm-stats: fix a crash if allocation of per-cpu data fails
Date: Fri,  4 Sep 2026 07:01:01 +0200
Message-ID: <20260904045802.076065411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


