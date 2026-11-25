Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619737;
	b=pyWJ23LxLrCIsThijKRc5kz1oVhtOmA+7djyIzt1R5zsgKT6iirLfR1Qy0WuZq/e7FaF
	 VqXMyLaNVAL0ysh4gfk5ow05+IrCA060KMm7L1bANqauE/Az5SfQ+nkgwn5lokNAIUIn7
	 m6sXddtVt70rtxSZud5EGWCMKIfnTO8RHoTxV2PiLrKZIiImOZXaX0utKngp4o9jHsxBg
	 N33SYV3xlsszD5d8ZbcmhBeGK0TJ+o/rvHhxldTIr+BaerfIcXDBMupxknOm1acddBNs5
	 OnWLq8KIO/7hxu/7zIye8mAsq6OyIrvZKmVNWvD/oyPR4l6HyC8wqLL2Qd43JtDN9Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nLI0u7MRA6tOw6qpLv40k8Bf7FMnMDhQ0VjIIlOTm1M=;
	b=DqRciEMaHK9ks7hacZzWzvkI3Ebxvt1jE/Edo7JVvIYRC6SoABbL1NJewAN8PUTbr3CZ
	 F+GLvbqDd2SfAzeG6k/JW0HzPgJ1KvPwnY8AOY/AhPfiVCrwtP/tfD0Z21qJqcW7jjwzG
	 NXF27jTeQXhmHRQ2MWo/Gio+uOsEax9SUo8Hhvtfn+vGyER8c0nGoas7xgMMHU0W6OeXC
	 ciaRNJCoSQoxLbyJMmPQWLDedWQm89PkqUtyezfyRa/Qmb5msF9AldRj3Z8XDh4ZPVHWb
	 G0BUj+Nl9tZjPhPqriOwlJG944LsIeMFz0nz855N+wjhll0sqomGRHFJEtFmBcpGZrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hn4OHo2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57CB606A31E;
	Wed, 25 Nov 2026 15:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hn4OHo2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788F81F000D0;
	Wed, 25 Nov 2026 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619737;
	bh=nLI0u7MRA6tOw6qpLv40k8Bf7FMnMDhQ0VjIIlOTm1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hn4OHo2AqusD/HpfombjTBjF2gqNcSStKt11wHC8l99O+4LIxlu2sZOGCtw77fMbp
	 RUltA8Xzhy7CiJK8OoL3Dwh8e9Ztdoxm8LYqEO6ZgC1dXEBzKpaBA/n/aoXJG4nfp4
	 sUeYmWerbfoXsnYVUJzp1bWPK8vzbvj4sytl7MFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 7.3 0690/1005] cgroup/freezer: Fix exiting tasks left frozen forever after rmdir
Date: Wed, 25 Nov 2026 15:33:48 +0100
Message-ID: <20261125143837.916363479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit e1aed52b68a361f6fc047b24a37d9ec4d928a158 upstream.

Since 93618edf7538 ("cgroup: Defer css percpu_ref kill on rmdir until cgroup
is depopulated"), rmdir succeeds once cgroup.procs is empty, but exiting
tasks hidden from it can stay in the cgroup until their final context
switch. If such a task is frozen in a v1 freezer cgroup, nothing is left to
thaw it after rmdir: freezer.state is gone with the cgroup, and a THAWED
write to an ancestor clears only CGROUP_FREEZING_PARENT.

8ab6980c7007 ("cgroup/freezer: walk exiting tasks in the v1 freezer") made
the freezer walks include exiting tasks. A FROZEN write now also freezes a
hidden task in a freezable sleep on its exit path. The fix depends on that
commit, as the thaw reaches hidden tasks through the same walk.

Since 81933038f5e2 ("pid_namespace: make zap_pid_ns_processes() freezable"),
an exiting pid namespace init sleeps that way until a parent outside the
namespace reaps a zombie in it.

Thaw the cgroup from ->css_killed(), as a THAWED write to it would. A
descendant removed earlier can still hold hidden tasks frozen through
CGROUP_FREEZING_PARENT. The thaw reaches it too, as its css stays online
until its tasks are gone.

rmdir removes freezer.state only after ->css_killed() returns, and a write
to it takes no cgroup_mutex. A FROZEN write after the thaw would freeze the
removed cgroup again, so refuse to freeze a dead cgroup.

Verified with a reproducer, including under a frozen parent, from an already
removed child and with a racing FROZEN write.

Fixes: 93618edf7538 ("cgroup: Defer css percpu_ref kill on rmdir until cgroup is depopulated")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Tested-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/legacy_freezer.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/kernel/cgroup/legacy_freezer.c b/kernel/cgroup/legacy_freezer.c
index bd11047f2311..1792523d119a 100644
--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -382,6 +382,24 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 	 * CGROUP_FREEZING_PARENT.
 	 */
 	mutex_lock(&freezer_mutex);
+
+	/*
+	 * A dead cgroup must not be frozen.
+	 *
+	 * rmdir thaws the cgroup from freezer_css_killed(), but freezer.state
+	 * stays writable until rmdir removes it a moment later. A FROZEN write
+	 * in that gap would freeze the cgroup again, and nothing could thaw it
+	 * after that.
+	 *
+	 * A freezer.state write doesn't take cgroup_mutex, but testing
+	 * cgroup_is_dead() without it is safe. rmdir marks the cgroup dead
+	 * before the thaw, so a write that takes freezer_mutex after the thaw
+	 * sees it dead. One that takes it before the thaw may still see the
+	 * cgroup alive, but the thaw then undoes its freeze.
+	 */
+	if (freeze && data_race(cgroup_is_dead(freezer->css.cgroup)))
+		goto out_unlock;
+
 	rcu_read_lock();
 	css_for_each_descendant_pre(pos, &freezer->css) {
 		struct freezer *pos_f = css_freezer(pos);
@@ -403,10 +421,25 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 		css_put(pos);
 	}
 	rcu_read_unlock();
+out_unlock:
 	mutex_unlock(&freezer_mutex);
 	cpus_read_unlock();
 }
 
+/**
+ * freezer_css_killed - Thaw a freezer cgroup being removed
+ * @css: css being killed
+ *
+ * Exiting tasks hidden from cgroup.procs can still be in the cgroup when it is
+ * removed, and a frozen one has nothing left to thaw it once freezer.state is
+ * gone. Thaw the cgroup as a THAWED write to it would. A frozen ancestor keeps
+ * the tasks frozen through CGROUP_FREEZING_PARENT until the ancestor is thawed.
+ */
+static void freezer_css_killed(struct cgroup_subsys_state *css)
+{
+	freezer_change_state(css_freezer(css), false);
+}
+
 static ssize_t freezer_write(struct kernfs_open_file *of,
 			     char *buf, size_t nbytes, loff_t off)
 {
@@ -466,6 +499,7 @@ static struct cftype files[] = {
 struct cgroup_subsys freezer_cgrp_subsys = {
 	.css_alloc	= freezer_css_alloc,
 	.css_online	= freezer_css_online,
+	.css_killed	= freezer_css_killed,
 	.css_offline	= freezer_css_offline,
 	.css_free	= freezer_css_free,
 	.attach		= freezer_attach,
-- 
2.56.1



