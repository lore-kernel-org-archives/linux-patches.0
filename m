Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D364E1A256B;
	Tue, 26 Aug 2025 11:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207486; cv=none; b=XkPY9br4qSATefrY0w6XSZ8rPDlLI5UxFgJO93wwpdMdaUpimT0ggi27KaoJoZwKSgTCG0qaIXee9Xg0Hh4x3PIrW3nK9uufb7+gpmjCDxgiFFjgvXZsDEQX22Q5B/Tc9wJZaIoa8vjdPC2aWY7hn0XzR8S6+j/2qtQ4BaIgXqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207486; c=relaxed/simple;
	bh=mhTSqypE7mxOMfuZ6wFuUz+eBKXZN7w+yRIAnUJrIuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F/yFb8KY++bcIs5+gnGK+P/yMK2aFLHKqRqngbzpYE/lUBjLGZuvW6+XdWtjClZlFr7f5Cmx9Kvvrs0OyKpt75cTG0rmJIErUp+bdWaNOlqF5RiVIYYYKaHM8ez16xR2t9bVpUXtEGv4hHaC5lWbzDO0L0UganlghsSTeQ4GOwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+hON5lL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+hON5lL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D70FC113CF;
	Tue, 26 Aug 2025 11:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207486;
	bh=mhTSqypE7mxOMfuZ6wFuUz+eBKXZN7w+yRIAnUJrIuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+hON5lLmOUW+tOCzOw/A9SGzVwAq/aix/FsVdyPj8Kv7n2CHusZr37OX1zTkLYTn
	 W5KbXiqZ1xSrnHvv/+BNgK6e51dWVznwgfJ41pFHTb2ZwhPu/e/Hs2o958eVOzF1RB
	 C5Q2CsrFUjHxJ5sBSCuZeNgebYAL5J1lese4jVrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JP Kobryn <inwardvessel@gmail.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	syzbot+8d052e8b99e40bc625ed@syzkaller.appspotmail.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.16 200/457] cgroup: avoid null de-ref in css_rstat_exit()
Date: Tue, 26 Aug 2025 13:08:04 +0200
Message-ID: <20250826110942.309533416@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: JP Kobryn <inwardvessel@gmail.com>

commit eea51c6e3f6675b795f6439eaa960eb2948d6905 upstream.

css_rstat_exit() may be called asynchronously in scenarios where preceding
calls to css_rstat_init() have not completed. One such example is this
sequence below:

css_create(...)
{
	...
	init_and_link_css(css, ...);

	err = percpu_ref_init(...);
	if (err)
		goto err_free_css;
	err = cgroup_idr_alloc(...);
	if (err)
		goto err_free_css;
	err = css_rstat_init(css, ...);
	if (err)
		goto err_free_css;
	...
err_free_css:
	INIT_RCU_WORK(&css->destroy_rwork, css_free_rwork_fn);
	queue_rcu_work(cgroup_destroy_wq, &css->destroy_rwork);
	return ERR_PTR(err);
}

If any of the three goto jumps are taken, async cleanup will begin and
css_rstat_exit() will be invoked on an uninitialized css->rstat_cpu.

Avoid accessing the unitialized field by returning early in
css_rstat_exit() if this is the case.

Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Fixes: 5da3bfa029d68 ("cgroup: use separate rstat trees for each subsystem")
Cc: stable@vger.kernel.org # v6.16
Reported-by: syzbot+8d052e8b99e40bc625ed@syzkaller.appspotmail.com
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/rstat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -488,6 +488,9 @@ void css_rstat_exit(struct cgroup_subsys
 	if (!css_uses_rstat(css))
 		return;
 
+	if (!css->rstat_cpu)
+		return;
+
 	css_rstat_flush(css);
 
 	/* sanity check */


